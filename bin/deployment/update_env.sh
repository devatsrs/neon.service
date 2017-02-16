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

