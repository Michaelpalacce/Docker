FROM lissy93/dashy

RUN apk add git && rm -rf /app/dist/item-icons && GIT_SSL_NO_VERIFY=true git clone https://github.com/NX211/homer-icons.git /app/dist/item-icons

COPY extraimages/* /app/dist/item-icons
