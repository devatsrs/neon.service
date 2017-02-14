#!/bin/sh

#define variables

VERSION=4.08

COMPANY=DevCompany1

DB_HOST=188.227.186.98

DB_USERNAME=neon-user-dev

DB_PASSWORD=B!I27U03Yx68

DB_DATABASE=NeonRMDev

DB_DATABASE2=NeonBillingDev

DB_DATABASECDR=NeonCDRDev

DB_DATABASEREPORT=NeonReportDev


WEB_LOCATION=/var/www/html/${COMPANY}.neon

SERVICE_LOCATION=/var/www/html/${COMPANY}.neon.service

API_LOCATION=/var/www/html/${COMPANY}.neon/public/neon.api


#Stop Crontab
#service crond stop

#copy code

git clone -b ${VERSION} https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/neon.web.encrypt.git ${WEB_LOCATION}

git clone -b ${VERSION} https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/neon.service.encrypt.git ${SERVICE_LOCATION}

git clone -b ${VERSION} https://devsrsgirish:Welcome100@bitbucket.org/devatsrs/api.neon-crm.git ${API_LOCATION}


#run composer update
echo -e " Running composer update on " ${WEB_LOCATION} " --no-plugins --no-scripts";

composer update -d ${WEB_LOCATION} --no-plugins --no-scripts

echo -e " Running composer update on " ${SERVICE_LOCATION}  " --no-plugins --no-scripts";

composer update -d  ${SERVICE_LOCATION} --no-plugins --no-scripts


echo -e " Running composer update on " ${API_LOCATION}  " --no-plugins --no-scripts";

composer update -d  ${API_LOCATION} --no-plugins --no-scripts

#replace place composer folder.

cp ./web_composer/* ${WEB_LOCATION}/vendor/composer

cp ./service_composer/* ${SERVICE_LOCATION}/vendor/composer

#Start cron job
#service crond start

exit 0

