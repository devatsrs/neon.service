#!/bin/bash
###############################
# Will move all Mysql tables from one database to a new database

[ "$#" -lt 2  ] && echo "usage: $(basename $0) OLD_DB NEW_DB MYSQL_AUTH_OPTS" && exit 1

SRCDB=$1
DSTDB=$2
shift
shift

TNAMES=$(mktemp)
SCRIPT=$(mktemp).sql

OTHERSOPT="$*"

mysql $OTHERSOPT $SRCDB -e exit > /dev/null
[ $? -ne 0 ] && echo "$SRCDB don't exist or authentication problem, please verify!" && exit 2

#mysql $OTHERSOPT $DSTDB -e exit > /dev/null 2>&1 [ $? -ne 1 ] && echo "$DSTDB exists, please provide an new DB name!" && exit 2



mysql $OTHERSOPT $SRCDB -e "show tables" | tail -n +2 > $TNAMES

cat $TNAMES | while read T; do
  echo "RENAME TABLE ${SRCDB}.${T} to ${DSTDB}.${T};";
done > $SCRIPT

echo "Script generated on $SCRIPT please verify and confirm to execute"
echo "We will move $(wc -l < $TNAMES) tables, views are not supported, please type YES to confirm"
read A
[ "$A" = "yes" -o "$A" = "YES" ] || exit 4

#mysql --show-warnings $OTHERSOPT -e "CREATE DATABASE $DSTDB;"
mysql --show-warnings $OTHERSOPT $DSTDB < $SCRIPT

[ $? -ne 0 ] && echo "We had some error, please verify" 

[ $(mysql $OTHERSOPT $SRCDB -e "show tables" | wc -l) -ne 0 ] && \
  echo "WARNING! we still have some objects inside $SRCDB" && exit 5

echo "rename of tables done! dont forget to give permissions to the new Database $SRCDB and drop the old DB"
