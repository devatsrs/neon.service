#!/bin/sh

echo "CDR delete Start"
echo "CDR Folder = /home/hostedfolders/1worldtec/tmp/vos_files/1  "
find /home/hostedfolders/1worldtec/tmp/vos_files/1 -mtime +30 -type f -exec rm {} \;
echo "CDR Folder = /home/hostedfolders/familytalk/tmp/vos_files/1"
find /home/hostedfolders/familytalk/tmp/vos_files/1 -mtime +30 -type f -exec rm {} \;
echo "CDR Folder = /home/hostedfolders/familytalk/tmp/vos_files/2"
find /home/hostedfolders/familytalk/tmp/vos_files/2 -mtime +30 -type f -exec rm {} \;
echo "CDR Folder = /home/hostedfolders/familytalk/tmp/vos_files/3"
find /home/hostedfolders/familytalk/tmp/vos_files/3 -mtime +30 -type f -exec rm {} \;
echo "CDR Folder = /home/hostedfolders/familytalk/tmp/vos_files/4"
find /home/hostedfolders/familytalk/tmp/vos_files/4 -mtime +30 -type f -exec rm {} \;
echo "CDR Folder = /home/hostedfolders/familytalk/tmp/vos_files/2"
find /home/hostedfolders/familytalk/tmp/vos_files/2 -mtime +30 -type f -exec rm {} \;
echo "CDR Folder = /home/hostedfolders/usmantel/tmp/sippy_files/2"
find /home/hostedfolders/usmantel/tmp/sippy_files/2 -mtime +30 -type f -exec rm {} \;
echo "CDR Folder = /home/hostedfolders/usmantel/tmp/vos_files/1"
find /home/hostedfolders/usmantel/tmp/vos_files/1 -mtime +30 -type f -exec rm {} \;
echo "CDR Folder = /home/hostedfolders/voicecourier/sippy_files/1"
find /home/hostedfolders/voicecourier/sippy_files/1 -mtime +30 -type f -exec rm {} \;

echo "CDR delete End"