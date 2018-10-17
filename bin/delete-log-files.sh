#!/bin/sh

echo "Log File delete Start"
find /home/www/1worldtec.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/dev.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/gisnetworkingsystems.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/hotwiretellecom.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/lcbsolutions.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/reports.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/staging.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/steadyconnections.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/supertech.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/teluxhd.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/vishal.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/vos-rate-update/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/vos-rate-update-streamco/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/associatesmarketing.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/codedesk.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/demo.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/familytalk.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/imedia.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/pbxlines.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/sipsynergy.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/telpeer.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/twistvoip.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/usmantel.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/voicecourier.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/wavetelpbx.neon/app/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;




find /home/www/1worldtec.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/gisnetworkingsystems.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/hotwiretellecom.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/lcbsolutions.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/reports.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/staging.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/steadyconnections.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/supertech.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/teluxhd.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /home/www/vishal.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/associatesmarketing.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/codedesk.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/demo.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/familytalk.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/imedia.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/pbxlines.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/sipsynergy.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/telpeer.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/twistvoip.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/usmantel.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/voicecourier.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
find /var/www/html/wavetelpbx.neon.service/storage/logs -mtime +7 -type f -name "*.log" -exec rm {} \;
echo "Log File delete End"