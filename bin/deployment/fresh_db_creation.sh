#!/bin/sh

echo "Creating Databases..."

echo 'CREATE DATABASE `'${DB_DATABASE}'` /*!40100 COLLATE utf8_unicode_ci */ ' | mysql 
echo 'CREATE DATABASE `'${DB_DATABASE2}'` /*!40100 COLLATE utf8_unicode_ci */' | mysql 
echo 'CREATE DATABASE `'${DB_DATABASECDR}'` /*!40100 COLLATE utf8_unicode_ci */' | mysql 
echo 'CREATE DATABASE `'${DB_DATABASEREPORT}'` /*!40100 COLLATE utf8_unicode_ci */' | mysql 


echo "Exporting Staging DBs Schema to sql file..."

mysqldump  --no-data --routines  Ratemanagement3 > /home/Ratemanagement3.sql
mysqldump  --no-data --routines  RMBilling3 > /home/RMBilling3.sql
mysqldump  --no-data --routines  RMCDR3 > /home/RMCDR3.sql
mysqldump  --no-data --routines  StagingReport > /home/StagingReport.sql

echo "Preparing sql file for new DBs."

sed -i 's/utf8mb4_general_ci/utf8_unicode_ci/g' /home/Ratemanagement3.sql
sed -i 's/utf8mb4_general_ci/utf8_unicode_ci/g' /home/RMBilling3.sql
sed -i 's/utf8mb4_general_ci/utf8_unicode_ci/g' /home/RMCDR3.sql
sed -i 's/utf8mb4_general_ci/utf8_unicode_ci/g' /home/StagingReport.sql

sed -i 's/utf8mb4/utf8/g' /home/Ratemanagement3.sql
sed -i 's/utf8mb4/utf8/g' /home/RMBilling3.sql
sed -i 's/utf8mb4/utf8/g' /home/RMCDR3.sql
sed -i 's/utf8mb4/utf8/g' /home/StagingReport.sql


sed -i 's/Ratemanagement3/'${DB_DATABASE}'/g' /home/Ratemanagement3.sql
sed -i 's/RMBilling3/'${DB_DATABASE2}'/g' /home/Ratemanagement3.sql
sed -i 's/RMCDR3/'${DB_DATABASECDR}'/g' /home/Ratemanagement3.sql
sed -i 's/StagingReport/'${DB_DATABASEREPORT}'/g' /home/Ratemanagement3.sql


sed -i 's/Ratemanagement3/'${DB_DATABASE}'/g' /home/RMBilling3.sql
sed -i 's/RMBilling3/'${DB_DATABASE2}'/g' /home/RMBilling3.sql
sed -i 's/RMCDR3/'${DB_DATABASECDR}'/g' /home/RMBilling3.sql
sed -i 's/StagingReport/'${DB_DATABASEREPORT}'/g' /home/RMBilling3.sql


sed -i 's/Ratemanagement3/'${DB_DATABASE}'/g' /home/RMCDR3.sql
sed -i 's/RMBilling3/'${DB_DATABASE2}'/g' /home/RMCDR3.sql
sed -i 's/RMCDR3/'${DB_DATABASECDR}'/g' /home/RMCDR3.sql
sed -i 's/StagingReport/'${DB_DATABASEREPORT}'/g' /home/RMCDR3.sql


sed -i 's/Ratemanagement3/'${DB_DATABASE}'/g' /home/StagingReport.sql
sed -i 's/RMBilling3/'${DB_DATABASE2}'/g' /home/StagingReport.sql
sed -i 's/RMCDR3/'${DB_DATABASECDR}'/g' /home/StagingReport.sql
sed -i 's/StagingReport/'${DB_DATABASEREPORT}'/g' /home/StagingReport.sql

sed -i 's/ AUTO_INCREMENT=[0-9]*//g' /home/Ratemanagement3.sql
sed -i 's/ AUTO_INCREMENT=[0-9]*//g' /home/RMBilling3.sql
sed -i 's/ AUTO_INCREMENT=[0-9]*//g' /home/RMCDR3.sql
sed -i 's/ AUTO_INCREMENT=[0-9]*//g' /home/StagingReport.sql

echo "Importing Prepared sql files for new DBs."

mysql   ${DB_DATABASE} < /home/Ratemanagement3.sql
mysql   ${DB_DATABASE2} < /home/RMBilling3.sql
mysql   ${DB_DATABASECDR} < /home/RMCDR3.sql
mysql   ${DB_DATABASEREPORT} < /home/StagingReport.sql

echo "Generating Post Installation sql file."

source ${SCRIPT_BASEDIR}/fresh_post_installation_sql.sh

