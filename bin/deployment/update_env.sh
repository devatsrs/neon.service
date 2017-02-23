#!/bin/sh

echo "loading configuration..."
source $(dirname "$0")/config.sh

#echo "stoping crond..."
#service crond stop

echo "copying code..."
echo "copying web..."
git checkout ${VERSION} ${WEB_LOCATION}
echo "copying service..."
git checkout ${VERSION} ${SERVICE_LOCATION}
echo "copying api..."
git checkout ${VERSION} ${API_LOCATION}

echo "Executing env_file_folder_permission..."
source ${SCRIPT_BASEDIR}/env_file_and_folder_permission.sh


echo "Executing POST UPDATE SQL file on env DB."
echo "Preparing sql file for env DBs."

POST_UPDATE_SQL_SCRIPT=${SCRIPT_BASEDIR}"/update.sql"

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

