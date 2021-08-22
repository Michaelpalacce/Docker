docker build -f Dockerfile -t stefangenov/jenkins:latest . \
&& docker build -f Dockerfile -t stefangenov/jenkins:2.307 . \
&& docker push stefangenov/jenkins:latest \
&& docker push stefangenov/jenkins:2.307 