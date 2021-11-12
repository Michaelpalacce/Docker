~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:node-latest \
-t stefangenov/jenkins-agent:node-gallium \
-f Dockerfile-gallium \
--push .
~~~
~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:node-fermium \
-f Dockerfile-fermium \
--push .
~~~
~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:node-erbium \
-f Dockerfile-erbium \
--push .
~~~
~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:docker \
-f Dockerfile-docker-agent \
--push .
~~~