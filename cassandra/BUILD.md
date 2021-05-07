docker build -f Dockerfile -t stefangenov/cassandra:latest -t stefangenov/cassandra:3.11 . \
&& docker push stefangenov/cassandra:latest \
&& docker push stefangenov/cassandra:3.11 