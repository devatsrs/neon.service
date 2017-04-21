#!/bin/sh

#Hosted server files

/usr/bin/s3cmd put --recursive /home/hostedfolders/d2call/tmp/1 s3://neon-hosted-files/d2call/
/usr/bin/s3cmd put --recursive /home/hostedfolders/blueflex/tmp/1 s3://neon-hosted-files/blueflex/
/usr/bin/s3cmd put --recursive /home/hostedfolders/codedesk/tmp/1 s3://neon-hosted-files/codedesk/
/usr/bin/s3cmd put --recursive /home/hostedfolders/covercommunications/tmp/1 s3://neon-hosted-files/covercommunications/
/usr/bin/s3cmd put --recursive /home/hostedfolders/pbxline/tmp/1 s3://neon-hosted-files/pbxline/
/usr/bin/s3cmd put --recursive /home/hostedfolders/tech-1/tmp/1 s3://neon-hosted-files/tech-1/
/usr/bin/s3cmd put --recursive /home/hostedfolders/twistvoip/tmp/1 s3://neon-hosted-files/twistvoip/
/usr/bin/s3cmd put --recursive /mnt/hd2/wholesale_hosted/shaztech/tmp/1 s3://neon-hosted-files/shaztech/
 