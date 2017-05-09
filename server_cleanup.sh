#!/bin/bash


echo "Start"

echo "System Storage"

#check system storage before cleanup starts

df

#STarting clenup

find /var/www/html/rm.service/storage/logs* -mtime +10 -exec rm {} \;

find /var/www/html/rm.service/storage/logs* -mtime +10 -exec rm {} \;
