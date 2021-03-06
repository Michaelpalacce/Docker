FROM jenkins/inbound-agent:latest-jdk11 as jnlp

FROM node:17.1.0-alpine3.14

RUN apk -U add openjdk8-jre git openssh

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]