#!/bin/sh

echo "loading configuration..."
source $(dirname "$0")/update_config.sh

#echo "stoping crond..."
#service crond stop

echo $WEB_LOCATION

if [ -d "$WEB_LOCATION" ]; then

    echo "copying code..."
    echo "copying web..."
    #example cd /var/www/html/release.neon && git config core.fileMode false && git pull
    cd ${WEB_LOCATION} && git fetch --all && git config core.fileMode false && git checkout ${VERSION} && git pull
    echo "copying service..."

    #Overwrite issue fix
    cd ${SERVICE_LOCATION} && git fetch --all && git reset --hard origin/${VERSION} && git checkout ${VERSION}

    cd ${SERVICE_LOCATION} && git config core.fileMode false && git checkout ${VERSION} && git pull
    echo "copying api..."
    cd ${API_LOCATION} && git fetch --all && git config core.fileMode false && git checkout ${VERSION} && git pull

    echo "Executing env_file_folder_permission..."
    source ${SCRIPT_BASEDIR}/composer_n_permission.sh

else

    echo "Web directory " $WEB_LOCATION " not found, Code import skipped. "

fi


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

