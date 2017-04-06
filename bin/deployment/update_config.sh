#!/bin/sh

#Version number to be deploy
VERSION=4.10

#Company name in Licence
COMPANY=DevCompany
#RM DB Name
DB_DATABASE=${COMPANY}RM
#Billing DB Name
DB_DATABASE2=${COMPANY}Billing
#CDR DB Name
DB_DATABASECDR=${COMPANY}CDR
#Report DB Name
DB_DATABASEREPORT=${COMPANY}Report


#web folder name (standard)
WEB_FOLDER_NAME=${COMPANY}.neon
#service folder name (standard)
SERVICE_FOLDER_NAME=${COMPANY}.neon.service
#API folder name (standard)
API_FOLDER_NAME=neon.api
#Web Service Root location
DOC_ROOT=/var/www/html
#Web location
WEB_LOCATION=${DOC_ROOT}/${WEB_FOLDER_NAME}
#Service location
SERVICE_LOCATION=${DOC_ROOT}/${SERVICE_FOLDER_NAME}
#API location within web.
API_LOCATION=${WEB_LOCATION}/public/${API_FOLDER_NAME}


#Internal variable for __DIR__ equivalent in shell script
SCRIPT_BASEDIR=$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )

COMPOSER_UPDATE=0
