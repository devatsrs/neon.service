#!/bin/sh


#This script will rename existing db with new db name
#Run this script before update on existing env.

echo "Generating Post Installation sql file."
POST_INSTALLATION_SQL_SCRIPT_NEW=${SCRIPT_BASEDIR}"/first_time_post_installation.sql"

echo "copy Pre generated post installation data file to new"
cp FIRST_TIME_POST_INSTALLATION_SQL_SCRIPT POST_INSTALLATION_SQL_SCRIPT_NEW


source ${SCRIPT_BASEDIR}/prepare_sql_file.sh

echo "Creating New DBs for first time ."

mysql   ${DB_DATABASE} < POST_INSTALLATION_SQL_SCRIPT_NEW

echo "Renaming tables.";
echo "###########################################################";
#source https://gist.github.com/pmoranga/2006012

TNAMES=${OLD_DB_DATABASE}"_tables.txt"
SCRIPT=${OLD_DB_DATABASE}"_rename_tables.sql"

##########################DB_DATABASE####################################

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

##########################DB_DATABASE2####################################

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


########################DB_DATABASECDR######################################

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


#######################DB_DATABASEREPORT#######################################

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


