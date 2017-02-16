#!/bin/sh

echo "loading configuration..."
source $(dirname "$0")/update_config.sh

#echo "stoping crond..."
#service crond stop

echo "copying code..."
echo "copying web..."
git checkout ${VERSION} ${WEB_LOCATION}
echo "copying service..."
git checkout ${VERSION} ${SERVICE_LOCATION}
echo "copying api..."
git checkout ${VERSION} ${API_LOCATION}

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

echo "Creating folders and Adding Permissions to folders"

chmod -R 777 ${WEB_LOCATION}

chmod -R 777 ${SERVICE_LOCATION}

chown -R apache:apache ${WEB_LOCATION}
chown -R apache:apache ${SERVICE_LOCATION}

echo "Executing POST UPDATE SQL file on env DB."
echo "Preparing sql file for env DBs."

sed -i 's/utf8mb4_general_ci/utf8_unicode_ci/g' ${POST_UPDATE_SQL_SCRIPT}
sed -i 's/utf8mb4/utf8/g' ${POST_UPDATE_SQL_SCRIPT}

sed -i 's/Ratemanagement3/'${DB_DATABASE}'/g' ${POST_UPDATE_SQL_SCRIPT}
sed -i 's/RMBilling3/'${DB_DATABASE2}'/g' ${POST_UPDATE_SQL_SCRIPT}
sed -i 's/RMCDR3/'${DB_DATABASECDR}'/g' ${POST_UPDATE_SQL_SCRIPT}
sed -i 's/StagingReport/'${DB_DATABASEREPORT}'/g' ${POST_UPDATE_SQL_SCRIPT}

sed -i 's/ AUTO_INCREMENT=[0-9]*//g' ${POST_UPDATE_SQL_SCRIPT}

#check drop column for data deletion in script before install.
mysql ${DB_DATABASE} < ${POST_UPDATE_SQL_SCRIPT}

#Start Crontab
#service crond start

echo "Complete!"
# Terminate our shell script
exit 0

