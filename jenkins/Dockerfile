FROM jenkins/jenkins:2.307

USER root

RUN apt update && apt install -y python3 ansible

USER jenkins
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_USER admin
ENV JENKINS_PASS admin

COPY files/plugins.txt /usr/share/jenkins/ref/
COPY --chown=jenkins:jenkins files/executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
COPY files/default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt