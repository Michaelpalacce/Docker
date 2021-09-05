~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:node-latest \
-t stefangenov/jenkins-agent:node-16.7-1 \
-f Dockerfile-16.7 \
--push .
~~~
~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:node-14.17.5-1 \
-f Dockerfile-14.17.5 \
--push .
~~~
~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:node-12.22.5-1 \
-f Dockerfile-12.22.5 \
--push .
~~~

~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:docker \
-f Dockerfile-docker-agent \
--push .
~~~