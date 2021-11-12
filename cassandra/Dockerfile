FROM cassandra:3.11

LABEL Maintainer="Stefan Genov"

COPY src/cassandra-lucene-index-plugin-3.11.1.0.jar /opt/cassandra/lib
COPY src/cassandra.yaml /etc/cassandra
COPY src/ready-probe.sh /ready-probe.sh
COPY src/ready-probe-node.sh /ready-probe-node.sh

RUN apt-get update && apt-get install -y netcat

# Add cleanup!