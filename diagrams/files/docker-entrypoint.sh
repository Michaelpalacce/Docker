#!/bin/bash
#set -e

LETS_ENCRYPT_ENABLED=${LETS_ENCRYPT_ENABLED:-false}
PUBLIC_DNS=${PUBLIC_DNS:-'draw.example.com'}
ORGANISATION_UNIT=${ORGANIZATION_UNIT:-'Cloud Native Application'}
ORGANISATION=${ORGANISATION:-'example inc'}
CITY=${CITY:-'Paris'}
STATE=${STATE:-'Paris'}
COUNTRY_CODE=${COUNTRY:-'FR'}
KEYSTORE_PASS=${KEYSTORE_PASS:-'V3ry1nS3cur3P4ssw0rd'}
KEY_PASS=${KEY_PASS:-$KEYSTORE_PASS}

echo "Init PreConfig.js"
#Add CSP to prevent calls to draw.io
echo "(function() {" > $CATALINA_HOME/webapps/draw/js/PreConfig.js
echo "  try {" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
echo "	    var s = document.createElement('meta');" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
echo "	    s.setAttribute('content', '${DRAWIO_CSP_HEADER:-default-src \'self\'; script-src \'self\' https://storage.googleapis.com https://apis.google.com https://docs.google.com https://code.jquery.com \'unsafe-inline\'; connect-src \'self\' https://*.dropboxapi.com https://api.trello.com https://api.github.com https://raw.githubusercontent.com https://*.googleapis.com https://*.googleusercontent.com https://graph.microsoft.com https://*.1drv.com https://*.sharepoint.com https://gitlab.com https://*.google.com https://fonts.gstatic.com https://fonts.googleapis.com; img-src * data:; media-src * data:; font-src * about:; style-src \'self\' \'unsafe-inline\' https://fonts.googleapis.com;}');" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
echo "	    s.setAttribute('http-equiv', 'Content-Security-Policy');" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
echo " 	    var t = document.getElementsByTagName('meta')[0];" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
echo "      t.parentNode.insertBefore(s, t);" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
echo "  } catch (e) {} // ignore" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
echo "})();" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
#Overrides of global vars need to be pre-loaded
if [[ "${DRAWIO_SELF_CONTAINED}" ]]; then
    echo "window.EXPORT_URL = '/service/0'; //This points to ExportProxyServlet which uses the local export server at port 8000. This proxy configuration allows https requests to the export server via Tomcat." >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
    echo "window.PLANT_URL = '/service/1';" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
fi
#DRAWIO_BASE_URL is path to base of deployment, e.g. https://www.example.com/folder
echo "window.DRAWIO_BASE_URL = '${DRAWIO_BASE_URL:-http://localhost:8080}';" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
#DRAWIO_VIEWER_URL is path to the viewer js, e.g. https://www.example.com/js/viewer.min.js
echo "window.DRAWIO_VIEWER_URL = '${DRAWIO_VIEWER_URL}';" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
echo "window.DRAW_MATH_URL = 'math';" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
#Custom draw.io configurations. For more details, https://desk.draw.io/support/solutions/articles/16000058316
echo "window.DRAWIO_CONFIG = ${DRAWIO_CONFIG:-null};" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
#Real-time configuration
if [[ "${DRAWIO_IOT_ENDPOINT}" ]]; then
    echo "urlParams['sync'] = 'auto'; //Enable Real-Time" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
    echo "window.MXPUSHER_IOT_ENDPOINNT = '${DRAWIO_MXPUSHER_ENDPOINT}'; //Specifies the IoT endpoint" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
    echo "window.DRAWIO_PUSHER_MODE = 2;" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
    mkdir -p $CATALINA_HOME/webapps/draw/WEB-INF/aws_iot_auth
    echo -n "${DRAWIO_IOT_CERT_PEM}" > $CATALINA_HOME/webapps/draw/WEB-INF/aws_iot_auth/mxPusherSrv.cert.pem
    echo -n "${DRAWIO_IOT_PRIVATE_KEY}" > $CATALINA_HOME/webapps/draw/WEB-INF/aws_iot_auth/mxPusherSrv.private.key
    echo -n "${DRAWIO_IOT_ROOT_CA}" > $CATALINA_HOME/webapps/draw/WEB-INF/aws_iot_auth/root-CA.crt
 	echo -n "${DRAWIO_IOT_ENDPOINT}" > $CATALINA_HOME/webapps/draw/WEB-INF/aws_iot_auth/endpoint_url
else
    echo "urlParams['sync'] = 'manual'; //Disable Real-Time" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
fi

#Disable unsupported services
echo "urlParams['db'] = '0'; //dropbox" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
echo "urlParams['gh'] = '0'; //github" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
echo "urlParams['tr'] = '0'; //trello" >> $CATALINA_HOME/webapps/draw/js/PreConfig.js

#Google Drive
if [[ -z "${DRAWIO_GOOGLE_CLIENT_ID}" ]]; then
    echo "urlParams['gapi'] = '0'; //Google Drive"  >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
else
    #Google drive application id and client id for the editor
    echo "window.DRAWIO_GOOGLE_APP_ID = '${DRAWIO_GOOGLE_APP_ID}'; " >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
    echo "window.DRAWIO_GOOGLE_CLIENT_ID = '${DRAWIO_GOOGLE_CLIENT_ID}'; " >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
    echo -n "${DRAWIO_GOOGLE_CLIENT_ID}" > $CATALINA_HOME/webapps/draw/WEB-INF/google_client_id
    echo -n "${DRAWIO_GOOGLE_CLIENT_SECRET}" > $CATALINA_HOME/webapps/draw/WEB-INF/google_client_secret
    #If you want to use the editor as a viewer also, you can create another app with read-only access. You can use the same info as above if write-access is not an issue.
    if [[ "${DRAWIO_GOOGLE_VIEWER_CLIENT_ID}" ]]; then
        echo "window.DRAWIO_GOOGLE_VIEWER_APP_ID = '${DRAWIO_GOOGLE_VIEWER_APP_ID}'; " >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
        echo "window.DRAWIO_GOOGLE_VIEWER_CLIENT_ID = '${DRAWIO_GOOGLE_VIEWER_CLIENT_ID}'; " >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
        echo -n "/:::/${DRAWIO_GOOGLE_VIEWER_CLIENT_ID}" >> $CATALINA_HOME/webapps/draw/WEB-INF/google_client_id
        echo -n "/:::/${DRAWIO_GOOGLE_VIEWER_CLIENT_SECRET}" >> $CATALINA_HOME/webapps/draw/WEB-INF/google_client_secret
    fi
fi

#Microsoft OneDrive
if [[ -z "${DRAWIO_MSGRAPH_CLIENT_ID}" ]]; then
    echo "urlParams['od'] = '0'; //OneDrive"  >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
else
    #Google drive application id and client id for the editor
    echo "window.DRAWIO_MSGRAPH_CLIENT_ID = '${DRAWIO_MSGRAPH_CLIENT_ID}'; " >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
    echo -n "${DRAWIO_MSGRAPH_CLIENT_ID}" > $CATALINA_HOME/webapps/draw/WEB-INF/msgraph_client_id
    echo -n "${DRAWIO_MSGRAPH_CLIENT_SECRET}" > $CATALINA_HOME/webapps/draw/WEB-INF/msgraph_client_secret
fi

#Gitlab
if [[ -z "${DRAWIO_GITLAB_ID}" ]]; then
    echo "urlParams['gl'] = '0'; //Gitlab"  >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
else
    #Gitlab url and id for the editor
    echo "window.DRAWIO_GITLAB_URL = '${DRAWIO_GITLAB_URL}'; " >> $CATALINA_HOME/webapps/draw/js/PreConfig.js
    echo "window.DRAWIO_GITLAB_ID = '${DRAWIO_GITLAB_ID}'; " >> $CATALINA_HOME/webapps/draw/js/PreConfig.js

    #Gitlab server flow auth (since 14.6.7)
    echo -n "${DRAWIO_GITLAB_URL}/oauth/token" > $CATALINA_HOME/webapps/draw/WEB-INF/gitlab_auth_url
    echo -n "${DRAWIO_GITLAB_ID}" > $CATALINA_HOME/webapps/draw/WEB-INF/gitlab_client_id
    echo -n "${DRAWIO_GITLAB_SECRET}" > $CATALINA_HOME/webapps/draw/WEB-INF/gitlab_client_secret
fi

cat $CATALINA_HOME/webapps/draw/js/PreConfig.js

echo "Init PostConfig.js"

#null'ing of global vars need to be after init.js
echo "window.VSD_CONVERT_URL = null;" > $CATALINA_HOME/webapps/draw/js/PostConfig.js
echo "window.ICONSEARCH_PATH = null;" >> $CATALINA_HOME/webapps/draw/js/PostConfig.js
echo "EditorUi.enableLogging = false; //Disable logging" >> $CATALINA_HOME/webapps/draw/js/PostConfig.js

#This requires subscription with cloudconvert.com
if [[ -z "${DRAWIO_CLOUD_CONVERT_APIKEY}" ]]; then
    echo "window.EMF_CONVERT_URL = null;"  >> $CATALINA_HOME/webapps/draw/js/PostConfig.js
else
    echo "window.EMF_CONVERT_URL = '/convert';" >> $CATALINA_HOME/webapps/draw/js/PostConfig.js
    echo -n "${DRAWIO_CLOUD_CONVERT_APIKEY}" > $CATALINA_HOME/webapps/draw/WEB-INF/cloud_convert_api_key
fi

if [[ "${DRAWIO_SELF_CONTAINED}" ]]; then
    echo "EditorUi.enablePlantUml = true; //Enables PlantUML" >> $CATALINA_HOME/webapps/draw/js/PostConfig.js
fi

#Treat this domain as a draw.io domain
echo "App.prototype.isDriveDomain = function() { return true; }" >> $CATALINA_HOME/webapps/draw/js/PostConfig.js

cat $CATALINA_HOME/webapps/draw/js/PostConfig.js

if ! [ -f $CATALINA_HOME/.keystore ] && [ "$LETS_ENCRYPT_ENABLED" == "true" ]; then
    echo "Generating Let's Encrypt certificate"

    keytool -genkey -noprompt -alias tomcat -dname "CN=${PUBLIC_DNS}, OU=${ORGANISATION_UNIT}, O=${ORGANISATION}, L=${CITY}, S=${STATE}, C=${COUNTRY_CODE}" -keystore $CATALINA_HOME/.keystore -storepass "${KEYSTORE_PASS}" -KeySize 2048 -keypass "${KEY_PASS}" -keyalg RSA -storetype pkcs12

    keytool -list -keystore $CATALINA_HOME/.keystore -v -storepass "${KEYSTORE_PASS}"

    keytool -certreq -alias tomcat -file request.csr -keystore $CATALINA_HOME/.keystore -storepass "${KEYSTORE_PASS}"

    certbot certonly --csr $CATALINA_HOME/request.csr --standalone --register-unsafely-without-email --agree-tos

    keytool -import -trustcacerts -alias tomcat -file 0001_chain.pem -keystore $CATALINA_HOME/.keystore -storepass "${KEYSTORE_PASS}"
fi

if ! [ -f $CATALINA_HOME/.keystore ] && [ "$LETS_ENCRYPT_ENABLED" == "false" ]; then
    echo "Generating Self-Signed certificate"

    keytool -genkey -noprompt -alias selfsigned -dname "CN=${PUBLIC_DNS}, OU=${ORGANISATION_UNIT}, O=${ORGANISATION}, L=${CITY}, S=${STATE}, C=${COUNTRY_CODE}" -keystore $CATALINA_HOME/.keystore -storepass "${KEYSTORE_PASS}" -KeySize 2048 -keypass "${KEY_PASS}" -keyalg RSA -validity 3600 -storetype pkcs12

    keytool -list -keystore $CATALINA_HOME/.keystore -v -storepass "${KEYSTORE_PASS}"
fi

# Update SSL port configuration if it does'nt exists
#
UUID="$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 1 | head -n 1)$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 7 | head -n 1)"
VAR=$(cat conf/server.xml | grep "$CATALINA_HOME/.keystore")

if [ -f $CATALINA_HOME/.keystore ] && [ -z $VAR ]; then
     echo "Append https connector to server.xml"

    xmlstarlet ed \
        -P -S -L \
        -s '/Server/Service' -t 'elem' -n "${UUID}" \
        -i "/Server/Service/${UUID}" -t 'attr' -n 'port' -v '8443' \
        -i "/Server/Service/${UUID}" -t 'attr' -n 'protocol' -v 'org.apache.coyote.http11.Http11NioProtocol' \
        -i "/Server/Service/${UUID}" -t 'attr' -n 'SSLEnabled' -v 'true' \
        -i "/Server/Service/${UUID}" -t 'attr' -n 'maxThreads' -v '150' \
        -i "/Server/Service/${UUID}" -t 'attr' -n 'scheme' -v 'https' \
        -i "/Server/Service/${UUID}" -t 'attr' -n 'secure' -v 'true' \
        -i "/Server/Service/${UUID}" -t 'attr' -n 'clientAuth' -v 'false' \
        -i "/Server/Service/${UUID}" -t 'attr' -n 'sslProtocol' -v 'TLS' \
        -i "/Server/Service/${UUID}" -t 'attr' -n 'KeystoreFile' -v "$CATALINA_HOME/.keystore" \
        -i "/Server/Service/${UUID}" -t 'attr' -n 'KeystorePass' -v "${KEY_PASS}" \
        -r "/Server/Service/${UUID}" -v 'Connector' \
    conf/server.xml
fi


exec "$@"