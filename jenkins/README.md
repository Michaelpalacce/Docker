Jenkins image based on https://hub.docker.com/r/jenkins/jenkins.

# Notes
- jenkins:2.307 supports arm processors, from what I can tell, the previous ones do not
- It has python3 and ansible preinstalled

# Environment Variables

~~~
JENKINS_USER
~~~
The default jenkins username
Defaults to 'admin'

~~~
JENKINS_PASS
~~~
The default jenkins password
Defaults to 'admin'

~~~
JAVA_OPTS
~~~
Extra java opts to pass
Defaults to '-Djenkins.install.runSetupWizard=false'