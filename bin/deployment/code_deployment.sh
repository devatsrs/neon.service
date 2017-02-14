#!/bin/sh

#include configuration file
source config.sh


#Stop Crontab
#service crond stop

#copy code

git clone -b ${VERSION} https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/neon.web.encrypt.git ${WEB_LOCATION}
git clone -b ${VERSION} https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/neon.service.encrypt.git ${SERVICE_LOCATION}
git clone -b ${VERSION} https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/api.neon-crm.git ${API_LOCATION}

#git clone -b ${VERSION} --reference ~/gitcaches/neon.web.encrypt.reference https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/neon.web.encrypt.git ${WEB_LOCATION}
#git clone -b ${VERSION} --reference ~/gitcaches/neon.service.encrypt.reference https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/neon.service.encrypt.git ${SERVICE_LOCATION}
#git clone -b ${VERSION} --reference ~/gitcaches/api.neon-crm.reference https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/api.neon-crm.git ${API_LOCATION}


cp -f  ${SCRIPT_BASEDIR}/api_env ${SCRIPT_BASEDIR}/api_env_new
cp -f ${SCRIPT_BASEDIR}/env ${SCRIPT_BASEDIR}/env_new

#Setup .env files
cat <<EOT >> ${SCRIPT_BASEDIR}/api_env_new
${LICENCE}={ "${COMPANY}":{"RMDB":{"DB_HOST":"${DB_HOST}","DB_DATABASE":"${DB_DATABASE}","DB_USERNAME":"${DB_USERNAME}","DB_PASSWORD":"${DB_PASSWORD}"}, "BILLINGDB":{"DB_HOST":"${DB_HOST}","DB_DATABASE":"${DB_DATABASE2}","DB_USERNAME":"${DB_USERNAME}","DB_PASSWORD":"${DB_PASSWORD}"}, "CDRDB":{"DB_HOST":"${DB_HOST}","DB_DATABASE":"${DB_DATABASECDR}","DB_USERNAME":"${DB_USERNAME}","DB_PASSWORD":"${DB_PASSWORD}"} } }
EOT



sed -i 's/=COMPANY_NAME/='${COMPANY}'/g' ${SCRIPT_BASEDIR}/env_new

sed -i 's/=LICENCE_KEY/='${LICENCE}'/g' ${SCRIPT_BASEDIR}/env_new


sed -i 's/=DB_HOST/='${DB_HOST}'/g' ${SCRIPT_BASEDIR}/env_new

sed -i 's/=DB_USERNAME/='${DB_USERNAME}'/g' ${SCRIPT_BASEDIR}/env_new

sed -i 's/=DB_PASSWORD/='${DB_PASSWORD}'/g' ${SCRIPT_BASEDIR}/env_new


sed -i 's/=DB_DATABASEREPORT/='${DB_DATABASEREPORT}'/g' ${SCRIPT_BASEDIR}/env_new

sed -i 's/=DB_DATABASECDR/='${DB_DATABASECDR}'/g' ${SCRIPT_BASEDIR}/env_new

sed -i 's/=DB_DATABASE2/='${DB_DATABASE2}'/g' ${SCRIPT_BASEDIR}/env_new

sed -i 's/=DB_DATABASE/='${DB_DATABASE}'/g' ${SCRIPT_BASEDIR}/env_new





#place both .env file in same directory



cp ${SCRIPT_BASEDIR}/env_new ${WEB_LOCATION}/.env

cp ${SCRIPT_BASEDIR}/env_new  ${SERVICE_LOCATION}/.env

cp api_env_new ${API_LOCATION}/.env




#run composer update
echo -e " Running composer update on " ${WEB_LOCATION} " --no-plugins --no-scripts";

composer update -d ${WEB_LOCATION} --no-plugins --no-scripts

echo -e " Running composer update on " ${SERVICE_LOCATION}  " --no-plugins --no-scripts";

composer update -d  ${SERVICE_LOCATION} --no-plugins --no-scripts


echo -e " Running composer update on " ${API_LOCATION}  " --no-plugins --no-scripts";

composer update -d  ${API_LOCATION} --no-plugins --no-scripts


#replace place composer folder.

cp -rf ${SCRIPT_BASEDIR}/web_composer/* ${WEB_LOCATION}/vendor/

cp -rf ${SCRIPT_BASEDIR}/service_composer/* ${SERVICE_LOCATION}/vendor/



#place licence file in same directory of this script.

cp -f ${SCRIPT_BASEDIR}/licence ${WEB_LOCATION}

cp -f ${SCRIPT_BASEDIR}/licence ${SERVICE_LOCATION}




chmod -R 777 ${WEB_LOCATION}

chmod -R 777 ${SERVICE_LOCATION}


mkdir -p ${TEMP_FOLDER}

mkdir -p ${TEMP_FOLDER}/uploads

mkdir -p ${TEMP_FOLDER}/account_documents

mkdir -p ${TEMP_FOLDER}/payment_proof

mkdir -p ${TEMP_FOLDER}/profile_pictures

mkdir -p ${VOS_LOCATION}/vos_files

mkdir -p ${SIPPYFILE_LOCATION}

chmod -R 777 ${TEMP_FOLDER}
chmod -R 777 ${WEB_LOCATION}
chmod -R 777 ${SERVICE_LOCATION}

chown -R apache:apache ${WEB_LOCATION}
chown -R apache:apache ${SERVICE_LOCATION}
chown -R apache:apache ${TEMP_FOLDER}

#Stop Crontab
#service crond stop

source ${SCRIPT_BASEDIR}/fresh_db_creation.sh

# Terminate our shell script

exit 0

