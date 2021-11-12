~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:node-latest \
-t stefangenov/jenkins-agent:node-17.x \
-f Dockerfile-17.x \
--cpu-quota="200000" \
--memory=4g \
--push .
~~~
~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:node-gallium \
-f Dockerfile-gallium \
--cpu-quota="200000" \
--memory=4g \
--push .
~~~
~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:node-fermium \
-f Dockerfile-fermium \
--cpu-quota="200000" \
--memory=4g \
--push .
~~~
~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:node-erbium \
-f Dockerfile-erbium \
--cpu-quota="200000" \
--memory=4g \
--push .
~~~
~~~bash
docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/jenkins-agent:docker \
-f Dockerfile-docker-agent \
--cpu-quota="200000" \
--memory=4g \
--push .
~~~