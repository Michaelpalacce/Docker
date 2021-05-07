# Kubectl + aws cli + php
FROM odaniait/aws-kubectl

USER root

RUN apk add php7 php7-json

USER user

ENV AS_PHP_ARRAY=1

COPY --chown=user:user secrets_parser.php .