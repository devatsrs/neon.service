#!/bin/sh

echo "loading configuration..."
source $(dirname "$0")/config.sh

#echo "stoping crond..."
#service crond stop

echo "copying code..."
echo "copying web..."
#example cd /var/www/html/release.neon && git config core.fileMode false && git pull
cd ${WEB_LOCATION} && git config core.fileMode false && git checkout ${VERSION} && git pull
echo "copying service..."
cd ${SERVICE_LOCATION} && git config core.fileMode false && git checkout ${VERSION} && git pull
echo "copying api..."
cd ${API_LOCATION} && git config core.fileMode false && git checkout ${VERSION} && git pull

echo "Executing env_file_folder_permission..."
source ${SCRIPT_BASEDIR}/env_file_and_folder_permission.sh


echo "Executing POST UPDATE SQL file on env DB."
echo "Preparing sql file for env DBs."

POST_UPDATE_SQL_SCRIPT=${SCRIPT_BASEDIR}"/update.sql"

POST_INSTALLATION_SQL_SCRIPT_NEW=${SCRIPT_BASEDIR}"/update_new.sql"
echo "copy Pre generated post installation data file to new"
cp -f ${POST_UPDATE_SQL_SCRIPT} ${POST_INSTALLATION_SQL_SCRIPT_NEW}

#Prepare sql file
# Replace db names paths urls and other variables set in config.
source  ${SCRIPT_BASEDIR}/prepare_sql_file.sh

#check drop column for data deletion in script before install.
mysql --force ${DB_DATABASE} < ${POST_INSTALLATION_SQL_SCRIPT_NEW}

#Start Crontab
#service crond start

#clear cache
php ${WEB_LOCATION}/artisan cache:clear
php ${SERVICE_LOCATION}/artisan cache:clear
php ${API_LOCATION}/artisan cache:clear

echo "Complete!"
# Terminate our shell script
exit 0

