#!/bin/sh

#Hosted server files

/usr/bin/s3cmd put --recursive /home/hostedfolders/codedesk/tmp/1 s3://neon-hosted-files/codedesk/
/usr/bin/s3cmd put --recursive /home/hostedfolders/covercommunications/tmp/1 s3://neon-hosted-files/covercommunications/
/usr/bin/s3cmd put --recursive /home/hostedfolders/shaztech/tmp/1 s3://neon-hosted-files/shaztech/
/usr/bin/s3cmd put --recursive /home/hostedfolders/twistvoip/tmp/1 s3://neon-hosted-files/twistvoip/
/usr/bin/s3cmd put --recursive /home/hostedfolders/voicecourier/tmp/1 s3://neon-hosted-files/voicecourier/
/usr/bin/s3cmd put --recursive /home/hostedfolders/pbxline/tmp/1 s3://neon-hosted-files/pbxline/
/usr/bin/s3cmd put --recursive /home/hostedfolders/usmantel/tmp/uploads/1 s3://neon-hosted-files/usmantel/
/usr/bin/s3cmd put --recursive /home/hostedfolders/familytalk/tmp/uploads s3://neon-hosted-files/familytalk/
