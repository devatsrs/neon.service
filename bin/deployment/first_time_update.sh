#!/bin/sh

#this script is for first time auto deployment on existing env which was not managed by auto deployment.

echo "loading configuration..."
source $(dirname "$0")/config.sh

#echo "stoping crond..."
#service crond stop

echo "copying code..."
echo "copying web..."
git clone -b ${VERSION} https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/neon.web.encrypt.git ${WEB_LOCATION}
echo "copying service..."
git clone -b ${VERSION} https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/neon.service.encrypt.git ${SERVICE_LOCATION}
echo "copying api..."
git clone -b ${VERSION} https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/api.neon-crm.git ${API_LOCATION}

echo "Executing env_file_folder_permission..."
source ${SCRIPT_BASEDIR}/env_file_folder_permission.sh

#Stop Crontab
#service crond stop

echo "Executing fresh_db_creation.sh..."
source ${SCRIPT_BASEDIR}/first_time_db_rename.sh

echo "Complete!"
# Terminate our shell script

exit 0

