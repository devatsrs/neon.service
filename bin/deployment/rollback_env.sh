#!/bin/sh

echo "loading configuration..."
source $(dirname "$0")/config.sh

#echo "stoping crond..."
#service crond stop

echo "Rolling Back code..."
echo "copying web..."
git checkout ${PREVIOUS_VERSION} ${WEB_LOCATION}
echo "copying service..."
git checkout ${PREVIOUS_VERSION} ${SERVICE_LOCATION}
echo "copying api..."
git checkout ${PREVIOUS_VERSION} ${API_LOCATION}

echo "Executing env_file_folder_permission..."
source ${SCRIPT_BASEDIR}/env_file_and_folder_permission.sh


echo "Executing POST UPDATE SQL file on env DB."
echo "Preparing sql file for env DBs."

ROLLBACK_SQL_SCRIPT=${SCRIPT_BASEDIR}"/rollback.sql"

sed -i 's/utf8mb4_general_ci/utf8_unicode_ci/g' ${ROLLBACK_SQL_SCRIPT}
sed -i 's/utf8mb4/utf8/g' ${ROLLBACK_SQL_SCRIPT}

sed -i 's/Ratemanagement3/'${DB_DATABASE}'/g' ${ROLLBACK_SQL_SCRIPT}
sed -i 's/RMBilling3/'${DB_DATABASE2}'/g' ${ROLLBACK_SQL_SCRIPT}
sed -i 's/RMCDR3/'${DB_DATABASECDR}'/g' ${ROLLBACK_SQL_SCRIPT}
sed -i 's/StagingReport/'${DB_DATABASEREPORT}'/g' ${ROLLBACK_SQL_SCRIPT}

sed -i 's/ AUTO_INCREMENT=[0-9]*//g' ${ROLLBACK_SQL_SCRIPT}

#check drop column for data deletion in script before install.
mysql ${DB_DATABASE} < ${ROLLBACK_SQL_SCRIPT}

#Start Crontab
#service crond start

echo "Complete!"
# Terminate our shell script
exit 0

