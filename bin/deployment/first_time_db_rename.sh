#!/bin/sh

echo "Creating Databases..."

echo 'CREATE DATABASE `'${DB_DATABASE}'` /*!40100 COLLATE utf8_unicode_ci */ ' | mysql
echo 'CREATE DATABASE `'${DB_DATABASE2}'` /*!40100 COLLATE utf8_unicode_ci */' | mysql
echo 'CREATE DATABASE `'${DB_DATABASECDR}'` /*!40100 COLLATE utf8_unicode_ci */' | mysql
echo 'CREATE DATABASE `'${DB_DATABASEREPORT}'` /*!40100 COLLATE utf8_unicode_ci */' | mysql


echo "Exporting Staging DBs Schema to sql file..."
#source http://www.computerhope.com/unix/mysqldum.htm
mysqldump  --no-data --routines --no-create-info Ratemanagement3 > /home/Ratemanagement3.sql
mysqldump  --no-data --routines --no-create-info RMBilling3 > /home/RMBilling3.sql
mysqldump  --no-data --routines --no-create-info RMCDR3 > /home/RMCDR3.sql
mysqldump  --no-data --routines --no-create-info StagingReport > /home/StagingReport.sql

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

echo "Renaming tables.";
echo "###########################################################";
#source https://gist.github.com/pmoranga/2006012

TNAMES=${OLD_DB_DATABASE}"_tables.txt"
SCRIPT=${OLD_DB_DATABASE}"_rename_tables.sql"

##############################################################

mysql $OLD_DB_DATABASE -e "show tables" | tail -n +2 > $TNAMES

cat $TNAMES | while read T; do
  echo "RENAME TABLE ${OLD_DB_DATABASE}.${T} to ${DB_DATABASE}.${T};";
done > $SCRIPT

#execute rename table script on new db.
mysql --show-warnings $DB_DATABASE < $SCRIPT

[ $? -ne 0 ] && echo "We had some error, please verify"

[ $(mysql $OLD_DB_DATABASE -e "show tables" | wc -l) -ne 0 ] && \
  echo "WARNING! we still have some objects inside $OLD_DB_DATABASE" && exit 5

echo "rename of tables done! dont forget to give permissions to the new Database $OLD_DB_DATABASE and drop the old DB"

##############################################################

mysql $OLD_DB_DATABASE2 -e "show tables" | tail -n +2 > $TNAMES

cat $TNAMES | while read T; do
  echo "RENAME TABLE ${OLD_DB_DATABASE2}.${T} to ${DB_DATABASE2}.${T};";
done > $SCRIPT

#execute rename table script on new db.
mysql --show-warnings $DB_DATABASE2 < $SCRIPT

[ $? -ne 0 ] && echo "We had some error, please verify"

[ $(mysql $OLD_DB_DATABASE2 -e "show tables" | wc -l) -ne 0 ] && \
  echo "WARNING! we still have some objects inside $OLD_DB_DATABASE2" && exit 5

echo "rename of tables done! dont forget to give permissions to the new Database $OLD_DB_DATABASE2 and drop the old DB"


##############################################################

mysql $OLD_DB_DATABASECDR -e "show tables" | tail -n +2 > $TNAMES

cat $TNAMES | while read T; do
  echo "RENAME TABLE ${OLD_DB_DATABASECDR}.${T} to ${DB_DATABASECDR}.${T};";
done > $SCRIPT

#execute rename table script on new db.
mysql --show-warnings $DB_DATABASECDR < $SCRIPT

[ $? -ne 0 ] && echo "We had some error, please verify"

[ $(mysql $OLD_DB_DATABASECDR -e "show tables" | wc -l) -ne 0 ] && \
  echo "WARNING! we still have some objects inside $OLD_DB_DATABASECDR" && exit 5

echo "rename of tables done! dont forget to give permissions to the new Database $OLD_DB_DATABASECDR and drop the old DB"


##############################################################

mysql $OLD_DB_DATABASEREPORT -e "show tables" | tail -n +2 > $TNAMES

cat $TNAMES | while read T; do
  echo "RENAME TABLE ${OLD_DB_DATABASEREPORT}.${T} to ${DB_DATABASEREPORT}.${T};";
done > $SCRIPT

#execute rename table script on new db.
mysql --show-warnings $DB_DATABASEREPORT < $SCRIPT

[ $? -ne 0 ] && echo "We had some error, please verify"

[ $(mysql $OLD_DB_DATABASEREPORT -e "show tables" | wc -l) -ne 0 ] && \
  echo "WARNING! we still have some objects inside $OLD_DB_DATABASEREPORT" && exit 5

echo "rename of tables done! dont forget to give permissions to the new Database $OLD_DB_DATABASEREPORT and drop the old DB"


