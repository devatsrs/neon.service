#!/bin/sh

#Execute this file to generate Schema for fresh installation.
#This script will have use database statement.

#After Ready to deploy we will first run this script.
# Before deploying to anybody we will generate this sql script to be deploy after fresh installation.
# And commit this POST_INSTALLATION_SQL_SCRIPT to master.
#source $(dirname "$0")/config.sh

echo "Exporting Staging DBs Schema to sql file..."

POST_INSTALLATION_SQL_SCRIPT=$(dirname "$0")"/post_installation_data.sql"


#source http://www.computerhope.com/unix/mysqldum.htm
mysqldump  --no-data --routines --databases Ratemanagement3 RMBilling3 RMCDR3 StagingReport > ${POST_INSTALLATION_SQL_SCRIPT}
#permission
chmod -R 777 ${POST_INSTALLATION_SQL_SCRIPT}
#Do not write CREATE TABLE statements for first time update
#mysqldump  --no-data --routines --no-create-info --databases Ratemanagement3 RMBilling3 RMCDR3 StagingReport > ${FIRST_TIME_POST_INSTALLATION_SQL_SCRIPT}
#permission
#chmod -R 777 ${FIRST_TIME_POST_INSTALLATION_SQL_SCRIPT}

#Staging RM DB for schema export
STAGING_RM_DB=Ratemanagement3
#Wholesale RM Db for tblRate export
WHOLESALE_RM_DB=wavetelwholesaleRM

echo "Adding default tables into POST INSTALLATION SQL file."
cat <<EOT >> ${POST_INSTALLATION_SQL_SCRIPT}
USE \`Ratemanagement3\`;
EOT

mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblCronJobCommand >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblCountry >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblGateway >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblGatewayConfig >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblGlobalAdmin >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblGlobalSetting >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblJobStatus >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblJobType >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblRateSheetFormate >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblPermission >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblResource >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblResourceCategories >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblIntegration >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblIntegration >> ${POST_INSTALLATION_SQL_SCRIPT}
mysqldump --compact --no-create-info -w 'CodeDeckId = 1' ${WHOLESALE_RM_DB} tblRate >> ${POST_INSTALLATION_SQL_SCRIPT}

#Backup for rollback  --------
#manually backup for rollback to old release.
#echo "Backup Tables data and old procedures for rollback."
#mkdir -p /home/auto_backup/${COMPANY}
#mysqldump --compact --no-create-info  ${OLD_DB_DATABASE} tblResourceCategories tblResource tblCompanyConfiguration  > /home/auto_backup/${COMPANY}/tblresourcecategories_tblResource_tblCompanyConfiguration.sql
#mysqldump --compact --no-data  --routines --no-create-info --databases ReleaseRM > /home/auto_backup/${COMPANY}/ReleaseRM.sql
#mysqldump --compact --no-data --routines --no-create-info --databases ReleaseBilling > /home/auto_backup/${COMPANY}/ReleaseBilling.sql
#mysqldump --compact --no-data --routines --no-create-info --databases ReleaseCDR > /home/auto_backup/${COMPANY}/ReleaseCDR.sql
#mysqldump --compact --no-data --routines --no-create-info --databases ReleaseReport > /home/auto_backup/${COMPANY}/ReleaseReport.sql

# ----------------------------

echo "Cleanup sql file for new DBs."

sed -i 's/utf8mb4_general_ci/utf8_unicode_ci/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/utf8mb4/utf8/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/ AUTO_INCREMENT=[0-9]*//g' ${POST_INSTALLATION_SQL_SCRIPT}
echo "Done!"
exit 0;