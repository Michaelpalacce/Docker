A php7.2-fpm installation bsed on alpine linux with a lot of preloaded plugins and a lot of environment variables. This can be used as a base and a lot of things can be removed.

- Contains composer installation
- Contains PHPUNIT 7.x installation
- Contains cassandra php driver
- Contains nodejs and npm installation
- Contains git installation
- Enabled plugins: cassandra, memcached, imap, gd, bcmath, mbstring, zip, opcache, yaml

# Environment variables:

- APP_PORT=9000
- PM_MAX_CHILDREN=20
- PM_START_SERVERS=10
- PM_MIN_SPARE_SERVERS=10
- PM_MAX_SPARE_SERVERS=15
- R_LIMIT_FILES=10000
- PHP_MEMORY_LIMIT=64m
- MAX_EXECUTION_TIME=120
- EXPOSE_PHP=Off
- DATE_TIMEZONE=UTC
- DISPLAY_ERRORS=0
- ERROR_LOG_LOCATION=/var/log/www-error.log
- ERROR_REPORTING=22527
- LOG_ERRORS=1
- LOG_ERRORS_MAX_LEN=2048
- MAX_INPUT_TIME=60
- OUTPUT_BUFFERING=4096
- REGISTER_ARGC_ARGV=0
- REQUEST_ORDER=GP
- SESSION_GC_DIVISOR=1000
- SHORT_OPEN_TAG=0