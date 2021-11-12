docker build -f Dockerfile-etcdctl-alpine-3.4.13 -t stefangenov/etcdctl:3.4.13-alpine -t stefangenov/etcdctl:latest -t stefangenov/etcdctl:alpine-latest . \
&& docker push stefangenov/etcdctl:3.4.13-alpine \
&& docker push stefangenov/etcdctl:alpine-latest \
&& docker push stefangenov/etcdctl:latest