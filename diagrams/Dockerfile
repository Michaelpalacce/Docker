FROM openjdk:8-alpine AS build

LABEL FROM=https://github.com/jgraph/docker-drawio/blob/dev/alpine/Dockerfile
ARG TAG_VERSION

RUN apk update --no-cache && \
    apk add --no-cache \
        apache-ant \
        git

RUN cd /tmp && \
    git clone --depth 1 --branch $TAG_VERSION https://github.com/jgraph/drawio.git && \
    cd /tmp/drawio/etc/build/ && \
    ant war

FROM tomcat:9-jre8-alpine

LABEL maintainer="JGraph Ltd"

RUN apk update --no-cache && \
    apk add --no-cache \
        certbot \
        curl \
        xmlstarlet

COPY --from=build /tmp/drawio/build/draw.war /tmp

# Extract draw.io war & Update server.xml to set Draw.io webapp to root
RUN mkdir -p $CATALINA_HOME/webapps/draw && \
    unzip /tmp/draw.war -d $CATALINA_HOME/webapps/draw && \
    rm -rf /tmp/draw.war /tmp/drawio && \
    cd $CATALINA_HOME && \
    xmlstarlet ed \
        -P -S -L \
        -i '/Server/Service/Engine/Host/Valve' -t 'elem' -n 'Context' \
        -i '/Server/Service/Engine/Host/Context' -t 'attr' -n 'path' -v '/' \
        -i '/Server/Service/Engine/Host/Context[@path="/"]' -t 'attr' -n 'docBase' -v 'draw' \
        -s '/Server/Service/Engine/Host/Context[@path="/"]' -t 'elem' -n 'WatchedResource' -v 'WEB-INF/web.xml' \
        -i '/Server/Service/Engine/Host/Valve' -t 'elem' -n 'Context' \
        -i '/Server/Service/Engine/Host/Context[not(@path="/")]' -t 'attr' -n 'path' -v '/ROOT' \
        -s '/Server/Service/Engine/Host/Context[@path="/ROOT"]' -t 'attr' -n 'docBase' -v 'ROOT' \
        -s '/Server/Service/Engine/Host/Context[@path="/ROOT"]' -t 'elem' -n 'WatchedResource' -v 'WEB-INF/web.xml' \
        conf/server.xml

# Copy docker-entrypoint
COPY files/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

WORKDIR $CATALINA_HOME

EXPOSE 8080 8443

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]