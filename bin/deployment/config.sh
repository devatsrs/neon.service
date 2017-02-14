#!/bin/sh


#define variables

VERSION=4.08

ISRETAIL=1

IS_WHOLESALE=0

COMPANY=DevCompany

DB_COMPANY_NAME="Dev Company"

FIRST_NAME=Dev

LAST_NAME=Company

COMPANY_EMAIL=dev@companyname.com

LICENCE_KEY=P2bs9zeJGFfAOitXauVjio0G3Q12xQet

TEMP_FOLDER=/home/tmp1


DB_HOST=localhost

DB_USERNAME=neon-user-dev

DB_PASSWORD=B!I27U03Yx68

DB_DATABASE=NeonRMDev

DB_DATABASE2=NeonBillingDev

DB_DATABASECDR=NeonCDRDev

DB_DATABASEREPORT=NeonReportDev

WEB_LOCATION=/var/www/html/devtest/${COMPANY}.neon

SERVICE_LOCATION=/var/www/html/devtest/${COMPANY}.neon.service

API_LOCATION=/var/www/html/devtest/${COMPANY}.neon/public/neon.api

SCRIPT_BASEDIR=$(dirname "$0")

SSH_HOST=localhost

SSH_HOST_USER=root

SSH_HOST_PASS=KatiteDo48

FRONT_STORAGE_PATH=${WEB_LOCATION}/app/storage

SIPPYFILE_LOCATION=${TEMP_FOLDER}/sippy_files

VOS_LOCATION=${TEMP_FOLDER}/vos_files

RMArtisanFileLocation=${SERVICE_LOCATION}/artisan

CRM_DASHBOARD=

BILLING_DASHBOARD=

BILLING_DASHBOARD_CUSTOMER=

EMAIL_TO_CUSTOMER=

Neon_API_URL=

ACC_DOC_PATH=

PAYMENT_PROOF_PATH=

STAGING_RM_DB=Ratemanagement3

WHOLESALE_RM_DB=RateManagement4

POST_INSTALLATION_SQL_SCRIPT=${SCRIPT_BASEDIR}"/post_installation_data.sql"
