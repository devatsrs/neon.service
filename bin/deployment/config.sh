#!/bin/sh


#define variables

VERSION=4.08

IS_WHOLESALE=0

COMPANY=DevCompany

DB_COMPANY_NAME="Dev Company"

FIRST_NAME=Dev

LAST_NAME=Company

COMPANY_EMAIL=dev@companyname.com

LICENCE_KEY=P2bs9zeJGFfAOitXauVjio0G3Q12xQet

TEMP_PATH=/home/tmp1

DB_HOST=localhost

DB_USERNAME=neon-user-dev

DB_PASSWORD=B!I27U03Yx68

DB_DATABASE=NeonRMDev

DB_DATABASE2=NeonBillingDev

DB_DATABASECDR=NeonCDRDev

DB_DATABASEREPORT=NeonReportDev

HOST_DOMAIN=linux1.neon-soft.com

HOST_DOMAIN_URL=http://${HOST_DOMAIN}

HOST_IP=${DB_HOST}

WEB_FOLDER_NAME=${COMPANY}.neon

SERVICE_FOLDER_NAME=${COMPANY}.neon.service

API_FOLDER_NAME=neon.api

WEB_LOCATION=/var/www/html/devtest/${WEB_FOLDER_NAME}

SITE_URL=${HOST_DOMAIN_URL}/devtest/${WEB_FOLDER_NAME}/public

SERVICE_LOCATION=/var/www/html/devtest/${SERVICE_FOLDER_NAME}

API_LOCATION=/var/www/html/devtest/${WEB_FOLDER_NAME}/public/${API_FOLDER_NAME}

NEON_API_URL=${SITE_URL}/${API_FOLDER_NAME}/public

SCRIPT_BASEDIR=$(dirname "$0")

SSH_HOST=localhost

SSH_HOST_USER=root

SSH_HOST_PASS=KatiteDo48

FRONT_STORAGE_PATH=${WEB_LOCATION}/app/storage

SIPPYFILE_LOCATION=${TEMP_PATH}/sippy_files

VOS_LOCATION=${TEMP_PATH}/vos_files

RMArtisanFileLocation=${SERVICE_LOCATION}/artisan

CRM_DASHBOARD=CrmDashboardTasks,CrmDashboardRecentAccount,CrmDashboardSalesRevenue,CrmDashboardSalesOpportunity,CrmDashboardPipeline,CrmDashboardForecast,CrmDashboardOpportunities

if [ "$IS_WHOLESALE" = "1" ]; then
    #Wholesale
    BILLING_DASHBOARD=BillingDashboardSummaryWidgets,BillingDashboardMissingGatewayWidget,BillingDashboardTotalOutstanding,BillingDashboardTotalInvoiceSent,BillingDashboardDueAmount,BillingDashboardOverDueAmount,BillingDashboardPendingDispute,BillingDashboardInvoiceExpense,BillingDashboardOutstanding
else
    #Retail
    BILLING_DASHBOARD=BillingDashboardSummaryWidgets,BillingDashboardPincodeWidget,BillingDashboardMissingGatewayWidget,BillingDashboardTotalOutstanding,BillingDashboardTotalInvoiceSent,BillingDashboardTotalInvoiceReceived,BillingDashboardDueAmount,BillingDashboardOverDueAmount,BillingDashboardPaymentReceived,BillingDashboardPaymentSent,BillingDashboardPendingDispute,BillingDashboardPendingEstimate,BillingDashboardInvoiceExpense,BillingDashboardOutstanding
fi

BILLING_DASHBOARD_CUSTOMER=BillingDashboardTotalOutstanding,BillingDashboardTotalInvoiceSent,BillingDashboardDueAmount,BillingDashboardOverDueAmount,BillingDashboardPendingDispute,BillingDashboardInvoiceExpense,BillingDashboardOutstanding

EMAIL_TO_CUSTOMER=1

UPLOAD_PATH=${TEMP_PATH}

ACC_DOC_PATH=${TEMP_PATH}

PAYMENT_PROOF_PATH=${TEMP_PATH}

STAGING_RM_DB=Ratemanagement3

WHOLESALE_RM_DB=RateManagement4

POST_INSTALLATION_SQL_SCRIPT=${SCRIPT_BASEDIR}"/post_installation_data.sql"
