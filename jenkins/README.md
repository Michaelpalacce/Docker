Jenkins agent with nodejs made for ARM64/AMD64 architectures.

Setup a new builder if you don't have one already: 
~~~bash
docker buildx create --use
~~~

This agent is based on alpine linux. It has openjdk8-jre, git and openssh installed.