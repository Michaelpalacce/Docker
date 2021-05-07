Cassandra installation with lucene index plugin.

Contains 2 ready probes that can be used to check if the node/seed is up and running.

If you want to use the Ready probes make sure to set an env variable: POD_IP equal to the ip of the current pod.

~~~
env:
  - name: POD_IP
    valueFrom:
        fieldRef:
            fieldPath: status.podIP
~~~