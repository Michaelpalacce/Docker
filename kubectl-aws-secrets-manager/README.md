Contains an image with kubectl, awscliv2 and php. A custom php script is written to fetch data from AWS Secrets manager and output them as a php array. 

# Environment Variables

AS_PHP_ARRAY [int] - set to 0 if you want the array json_decoded instead of a php array. Defaults to 1

# Example use cases:

- Use in a cronjob to fetch credentials from ECR
~~~
apiVersion: v1
kind: Secret
metadata:
    name: aws-access-keys
type: Opaque
data:
    aws_access_key_id: {{ accessKeyId }}
    aws_secret_access_key: {{ secretAccessKey }}
    aws_default_region: {{ defaultRegion }}
    aws_account: {{ awsAccount }}

---

kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
    name: ecr-cred-helper
rules:
    - apiGroups: [""]
      resources:
          - secrets
          - serviceaccounts
          - serviceaccounts/token
      verbs:
          - 'delete'
          - 'create'
          - 'patch'
          - 'get'

---

kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
    name: ecr-cred-helper
subjects:
    - kind: ServiceAccount
      name: sa-ecr-cred-helper
roleRef:
    kind: Role
    name: ecr-cred-helper
    apiGroup: ""

---

apiVersion: v1
kind: ServiceAccount
metadata:
    name: sa-ecr-cred-helper

---

apiVersion: batch/v1
kind: CronJob
metadata:
    annotations:
    name: ecr-cred-helper
    labels:
        type: credentials-helper
spec:
    concurrencyPolicy: Allow
    failedJobsHistoryLimit: 1
    jobTemplate:
        metadata:
            creationTimestamp: null
        spec:
            template:
                metadata:
                    creationTimestamp: null
                spec:
                    serviceAccountName: sa-ecr-cred-helper
                    containers:
                        - command:
                              - /bin/sh
                              - -c
                              - |-
                                  TOKEN=`aws ecr --region=$REGION get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2`
                                  echo "ENV variables setup done."
                                  kubectl delete secret --ignore-not-found $SECRET_NAME
                                  kubectl create secret docker-registry $SECRET_NAME \
                                  --docker-server=https://$(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.${REGION}.amazonaws.com \
                                  --docker-username=AWS \
                                  --docker-password="${TOKEN}" \
                                  --docker-email="${EMAIL}"
                                  echo "Secret created by name. $SECRET_NAME"
                                  echo "All done."
                          env:
                              - name: AWS_DEFAULT_REGION
                                valueFrom:
                                    secretKeyRef:
                                        name: aws-access-keys
                                        key: aws_default_region
                              - name: AWS_ACCESS_KEY_ID
                                valueFrom:
                                    secretKeyRef:
                                        name: aws-access-keys
                                        key: aws_access_key_id
                              - name: AWS_SECRET_ACCESS_KEY
                                valueFrom:
                                    secretKeyRef:
                                        name: aws-access-keys
                                        key: aws_secret_access_key
                              - name: ACCOUNT
                                valueFrom:
                                    secretKeyRef:
                                        name: aws-access-keys
                                        key: aws_account
                              - name: SECRET_NAME
                                value: aws-creds
                              - name: REGION
                                valueFrom:
                                    secretKeyRef:
                                        name: aws-access-keys
                                        key: aws_default_region
                              - name: EMAIL
                                value: random@email.com
                          image: stefangenov/kubectl-aws-secrets-manager:latest
                          name: ecr-cred-helper
                          resources: {}
                          securityContext:
                              capabilities: {}
                          terminationMessagePath: /dev/termination-log
                          terminationMessagePolicy: File
                    dnsPolicy: Default
                    hostNetwork: true
                    restartPolicy: Never
                    schedulerName: default-scheduler
                    securityContext: {}
                    terminationGracePeriodSeconds: 30
    schedule: 0 */6 * * *
    successfulJobsHistoryLimit: 3
    suspend: false
~~~

- Fetch environment variables:
~~~
# Add an initContainer to a deploymnet/pod/sts etc 
   - name: api-secrets-manager-helper
     command:
         - /bin/sh
         - -c
         - |-
             echo $(php -f secrets_parser.php $REGION $SECRETS_MANAGER_KEY) > /env/environment_variables.php
             echo "All done."
     env:
         - name: AWS_DEFAULT_REGION
           valueFrom:
               secretKeyRef:
                   name: aws-access-keys
                   key: aws_default_region
         - name: AWS_ACCESS_KEY_ID
           valueFrom:
               secretKeyRef:
                   name: aws-access-keys
                   key: aws_access_key_id
         - name: AWS_SECRET_ACCESS_KEY
           valueFrom:
               secretKeyRef:
                   name: aws-access-keys
                   key: aws_secret_access_key
         - name: ACCOUNT
           valueFrom:
               secretKeyRef:
                   name: aws-access-keys
                   key: aws_account
         - name: SECRETS_MANAGER_KEY
           value: {{ .php.secretsManagerKey }}
         - name: REGION
           valueFrom:
               secretKeyRef:
                   name: aws-access-keys
                   key: aws_default_region
         - name: EMAIL
           value: random@email.com
     image: stefangenov/kubectl-aws-secrets-manager:latest
     volumeMounts:
         - name: env
           mountPath: /env
~~~