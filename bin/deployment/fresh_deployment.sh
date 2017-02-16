#!/bin/sh

echo "loading configuration..."
source $(dirname "$0")/fresh_config.sh


#echo "stoping crond..."
#service crond stop

echo "copying code..."
echo "copying web..."
git clone -b ${VERSION} https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/neon.web.encrypt.git ${WEB_LOCATION}
echo "copying service..."
git clone -b ${VERSION} https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/neon.service.encrypt.git ${SERVICE_LOCATION}
echo "copying api..."
git clone -b ${VERSION} https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/api.neon-crm.git ${API_LOCATION}

#git clone -b ${VERSION} --reference ~/gitcaches/neon.web.encrypt.reference https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/neon.web.encrypt.git ${WEB_LOCATION}
#git clone -b ${VERSION} --reference ~/gitcaches/neon.service.encrypt.reference https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/neon.service.encrypt.git ${SERVICE_LOCATION}
#git clone -b ${VERSION} --reference ~/gitcaches/api.neon-crm.reference https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/api.neon-crm.git ${API_LOCATION}

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

cp ${SCRIPT_BASEDIR}/env_new ${WEB_LOCATION}/.env

cp ${SCRIPT_BASEDIR}/env_new  ${SERVICE_LOCATION}/.env

cp api_env_new ${API_LOCATION}/.env



echo -e " Running composer update on " ${WEB_LOCATION} " --no-plugins --no-scripts";

composer update -d ${WEB_LOCATION} --no-plugins --no-scripts

echo -e " Running composer update on " ${SERVICE_LOCATION}  " --no-plugins --no-scripts";

composer update -d  ${SERVICE_LOCATION} --no-plugins --no-scripts


echo -e " Running composer update on " ${API_LOCATION}  " --no-plugins --no-scripts";

composer update -d  ${API_LOCATION} --no-plugins --no-scripts

echo "replace composer folders for web and service."

cp -rf ${SCRIPT_BASEDIR}/web_composer/* ${WEB_LOCATION}/vendor/

cp -rf ${SCRIPT_BASEDIR}/service_composer/* ${SERVICE_LOCATION}/vendor/


echo "place licence file in service and web directory"

cp -f ${SCRIPT_BASEDIR}/licence ${WEB_LOCATION}

cp -f ${SCRIPT_BASEDIR}/licence ${SERVICE_LOCATION}



echo "Creating folders and Adding Permissions to folders"

chmod -R 777 ${WEB_LOCATION}

chmod -R 777 ${SERVICE_LOCATION}


mkdir -p ${TEMP_PATH}

mkdir -p ${TEMP_PATH}/uploads

mkdir -p ${TEMP_PATH}/account_documents

mkdir -p ${TEMP_PATH}/payment_proof

mkdir -p ${TEMP_PATH}/profile_pictures

mkdir -p ${VOS_LOCATION}/vos_files

mkdir -p ${SIPPYFILE_LOCATION}

chmod -R 777 ${TEMP_PATH}
chmod -R 777 ${WEB_LOCATION}
chmod -R 777 ${SERVICE_LOCATION}

chown -R apache:apache ${WEB_LOCATION}
chown -R apache:apache ${SERVICE_LOCATION}
chown -R apache:apache ${TEMP_PATH}

#Stop Crontab
#service crond stop

echo "Executing fresh_db_creation.sh..."
source ${SCRIPT_BASEDIR}/fresh_db_creation.sh

echo "Complete!"
# Terminate our shell script

exit 0

