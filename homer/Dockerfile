FROM b4bz/homer:21.07.1

RUN apk add git && GIT_SSL_NO_VERIFY=true git clone https://github.com/WalkxCode/dashboard-icons.git /www/icons

COPY extraimages/* /www/icons
