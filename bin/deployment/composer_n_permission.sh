#!/usr/bin/env bash

echo -e " Running composer update on " ${WEB_LOCATION} " --no-plugins --no-scripts";

composer update -d ${WEB_LOCATION} --no-plugins --no-scripts

echo -e " Running composer update on " ${SERVICE_LOCATION}  " --no-plugins --no-scripts";

composer update -d  ${SERVICE_LOCATION} --no-plugins --no-scripts


echo -e " Running composer update on " ${API_LOCATION}  " --no-plugins --no-scripts";

composer update -d  ${API_LOCATION} --no-plugins --no-scripts

echo "replace composer folders for web and service."

cp -rf ${SCRIPT_BASEDIR}/web_composer/* ${WEB_LOCATION}/vendor/

cp -rf ${SCRIPT_BASEDIR}/service_composer/* ${SERVICE_LOCATION}/vendor/

git config core.fileMode false
#for vos ssh file collect.
git checkout -- ${SERVICE_LOCATION}/vendor/laravelcollective/remote/src




echo "Creating folders and Adding Permissions to folders"

chmod -R 777 ${WEB_LOCATION}

chmod -R 777 ${SERVICE_LOCATION}




chmod -R 777 ${TEMP_PATH}
chmod -R 777 ${WEB_LOCATION}
chmod -R 777 ${SERVICE_LOCATION}

chown -R apache:apache ${WEB_LOCATION}
chown -R apache:apache ${SERVICE_LOCATION}
chown -R apache:apache ${TEMP_PATH}