#!/bin/sh

#Hosted server files

/usr/bin/s3cmd put --recursive /home/hostedfolders/codedesk/tmp s3://neon-hosted-files/codedesk/
/usr/bin/s3cmd put --recursive /home/hostedfolders/covercommunications/tmp s3://neon-hosted-files/covercommunications/
/usr/bin/s3cmd put --recursive /home/hostedfolders/shaztech/tmp s3://neon-hosted-files/shaztech/
/usr/bin/s3cmd put --recursive /home/hostedfolders/twistvoip/tmp s3://neon-hosted-files/twistvoip/
/usr/bin/s3cmd put --recursive /home/hostedfolders/voicecourier/tmp s3://neon-hosted-files/voicecourier/
/usr/bin/s3cmd put --recursive /home/hostedfolders/pbxline/tmp s3://neon-hosted-files/pbxline/
/usr/bin/s3cmd put --recursive /home/hostedfolders/usmantel/tmp s3://neon-hosted-files/usmantel/
/usr/bin/s3cmd put --recursive /home/hostedfolders/familytalk/tmp s3://neon-hosted-files/familytalk/
