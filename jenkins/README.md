Jenkins agent with nodejs made for ARM64/AMD64 architectures.

Setup a new builder if you don't have one already: 
~~~bash
docker buildx create --use
~~~

This agent is based on alpine linux. It has openjdk8-jre, git and openssh installed.

If you want to run this in kubernetes, make sure to setup the template like so:

~~~text
name: jnlp
Docker Image: stefangenov/jenkins-agent-node:node-16.7-v2 # I have made a custom Node image that runs for arm processors, but you can check my docker repo and make your own
Working directory: /home/jenkins/agent
Command to run: <blank>
arguments passed: <blank>
Allocate pseudo TTY: yes
~~~