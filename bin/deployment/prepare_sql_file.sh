#!/usr/bin/env bash

echo "Preparing POST_INSTALLATION_SQL_SCRIPT_NEW file for new DB."

sed -i 's/utf8mb4_general_ci/utf8_unicode_ci/g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i 's/utf8mb4/utf8/g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i 's/Ratemanagement3/'${DB_DATABASE}'/g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i 's/RMBilling3/'${DB_DATABASE2}'/g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i 's/RMCDR3/'${DB_DATABASECDR}'/g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i 's/StagingReport/'${DB_DATABASEREPORT}'/g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i 's/ AUTO_INCREMENT=[0-9]*//g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}

sed -i 's/Sumera Khan/System/g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i 's/bhavin@code-desk.com//g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i 's/umer.ahmed@code-desk.com//g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i 's/umer.ahmed@code-desk.com//g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i 's/girish.vadher@code-desk.com//g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i 's/saeedsumera@hotmail.com//g' ${POST_INSTALLATION_SQL_SCRIPT_NEW}

sed -i "s/_HOST_DOMAIN_URL_/$(echo "$HOST_DOMAIN_URL" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_DB_COMPANY_NAME_/$(echo "$DB_COMPANY_NAME" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_WEB_URL_/$(echo "$WEB_URL" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_SSH_HOST_USER_/$(echo "$SSH_HOST_USER" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_SSH_HOST_PASS_/$(echo "$SSH_HOST_PASS" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_SSH_HOST_/$(echo "$SSH_HOST" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_UPLOAD_PATH_/$(echo "$UPLOAD_PATH" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_TEMP_PATH_/$(echo "$TEMP_PATH" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}

sed -i "s/_FRONT_STORAGE_PATH_/$(echo "$FRONT_STORAGE_PATH" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_SIPPYFILE_LOCATION_/$(echo "$SIPPYFILE_LOCATION" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_VOS_LOCATION_/$(echo "$VOS_LOCATION" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_LICENCE_KEY_/$(echo "$LICENCE_KEY" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_RM_ARTISAN_FILE_LOCATION_/$(echo "${SERVICE_LOCATION}"/artisan | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_CRM_DASHBOARD_/$(echo "$CRM_DASHBOARD" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_MONITOR_DASHBOARD_/$(echo "$MONITOR_DASHBOARD" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_BILLING_DASHBOARD_CUSTOMER_/$(echo "$BILLING_DASHBOARD_CUSTOMER" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_BILLING_DASHBOARD_/$(echo "$BILLING_DASHBOARD" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_EMAIL_TO_CUSTOMER_/$(echo "$EMAIL_TO_CUSTOMER" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_NEON_API_URL_/$(echo "$NEON_API_URL" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_ACC_DOC_PATH_/$(echo "$ACC_DOC_PATH" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
sed -i "s/_PAYMENT_PROOF_PATH_/$(echo "$PAYMENT_PROOF_PATH" | sed 's/\//\\\//g')/g" ${POST_INSTALLATION_SQL_SCRIPT_NEW}
