#!/usr/bin/env bash

echo "copying env files..."
cp -f  ${SCRIPT_BASEDIR}/api_env ${SCRIPT_BASEDIR}/api_env_new
cp -f ${SCRIPT_BASEDIR}/env ${SCRIPT_BASEDIR}/env_new

echo "Setup env files..."
cat <<EOT >> ${SCRIPT_BASEDIR}/api_env_new
${LICENCE_KEY}={ "${COMPANY}":{"RMDB":{"DB_HOST":"${DB_HOST}","DB_DATABASE":"${DB_DATABASE}","DB_USERNAME":"${DB_USERNAME}","DB_PASSWORD":"${DB_PASSWORD}"}, "BILLINGDB":{"DB_HOST":"${DB_HOST}","DB_DATABASE":"${DB_DATABASE2}","DB_USERNAME":"${DB_USERNAME}","DB_PASSWORD":"${DB_PASSWORD}"}, "CDRDB":{"DB_HOST":"${DB_HOST}","DB_DATABASE":"${DB_DATABASECDR}","DB_USERNAME":"${DB_USERNAME}","DB_PASSWORD":"${DB_PASSWORD}"} } }
EOT


echo "Replacing env variables..."

sed -i 's/=COMPANY_NAME/='${COMPANY}'/g' ${SCRIPT_BASEDIR}/env_new

sed -i 's/=LICENCE_KEY/='${LICENCE_KEY}'/g' ${SCRIPT_BASEDIR}/env_new


sed -i 's/=DB_HOST/='${DB_HOST}'/g' ${SCRIPT_BASEDIR}/env_new

sed -i 's/=DB_USERNAME/='${DB_USERNAME}'/g' ${SCRIPT_BASEDIR}/env_new

sed -i 's/=DB_PASSWORD/='${DB_PASSWORD}'/g' ${SCRIPT_BASEDIR}/env_new


sed -i 's/=DB_DATABASEREPORT/='${DB_DATABASEREPORT}'/g' ${SCRIPT_BASEDIR}/env_new

sed -i 's/=DB_DATABASECDR/='${DB_DATABASECDR}'/g' ${SCRIPT_BASEDIR}/env_new

sed -i 's/=DB_DATABASE2/='${DB_DATABASE2}'/g' ${SCRIPT_BASEDIR}/env_new

sed -i 's/=DB_DATABASE/='${DB_DATABASE}'/g' ${SCRIPT_BASEDIR}/env_new

echo "Place .env files in web service and api"

cp -f ${SCRIPT_BASEDIR}/env_new ${WEB_LOCATION}/.env

cp -f ${SCRIPT_BASEDIR}/env_new  ${SERVICE_LOCATION}/.env

cp -f ${SCRIPT_BASEDIR}/api_env_new ${API_LOCATION}/.env



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


echo "place licence file in service and web directory"

cp -f ${SCRIPT_BASEDIR}/web_licence ${WEB_LOCATION}/licence

cp -f ${SCRIPT_BASEDIR}/service_licence ${SERVICE_LOCATION}/licence



echo "Creating folders and Adding Permissions to folders"

chmod -R 777 ${WEB_LOCATION}

chmod -R 777 ${SERVICE_LOCATION}


mkdir -p ${TEMP_PATH}

mkdir -p ${UPLOAD_PATH}

mkdir -p ${ACC_DOC_PATH}

mkdir -p ${PAYMENT_PROOF_PATH}

mkdir -p ${PROFILE_PICTURE_PATH}

mkdir -p ${VOS_LOCATION}

mkdir -p ${SIPPYFILE_LOCATION}

chmod -R 777 ${TEMP_PATH}
chmod -R 777 ${WEB_LOCATION}
chmod -R 777 ${SERVICE_LOCATION}

chown -R apache:apache ${WEB_LOCATION}
chown -R apache:apache ${SERVICE_LOCATION}
chown -R apache:apache ${TEMP_PATH}