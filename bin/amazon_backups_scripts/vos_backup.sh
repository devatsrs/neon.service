#!/usr/bin/perl

#  This command is used to backup db and upload to amazon
# Created by Dev : Shriramsoft.com - shriramsoft@gmail.com
# Last Updated : 24-06-2017


use strict;
#use warnings FATAL => 'all';

use Time::Local;

use constant BACKUP_CMD => '/usr/local/bin/automysqlbackup /etc/automysqlbackup/89.187.70.170-vos.conf > /var/log/dbbackup';

use constant AMAZON_BUCKET => 'wholesale.gateway.backups/89.187.70.170-VOS/daily';
use constant AMAZON_BUCKET_MONTHLY => 'wholesale.gateway.backups/89.187.70.170-VOS/monthly';

use constant AWS_CMD  => '/usr/bin/s3cmd sync --recursive /backup/db/daily/vos3000 s3://' . AMAZON_BUCKET . '/';
use constant AWS_CMD_MONTHLY  => '/usr/bin/s3cmd sync --recursive /backup/db/daily/vos3000 s3://' . AMAZON_BUCKET_MONTHLY . '/';

use constant EXPIRY_AWS_CMD  => '/usr/bin/s3cmd expire --expiry-days=30 --expiry-prefix=s3://' . AMAZON_BUCKET . '/';
use constant EXPIRY_AWS_CMD_MONTHLY  => '/usr/bin/s3cmd expire --expiry-days=180 s3://' . AMAZON_BUCKET . '/ --expiry-prefix=s3://' . AMAZON_BUCKET_MONTHLY . '/';


system('find /backup/db -type f -exec rm {} \;');
system(BACKUP_CMD);
system(AWS_CMD);
#system(EXPIRY_AWS_CMD);

#monthly backup logic
(my $sec , my $min, my $hour , my $mday) = localtime();

print $mday;

if ($mday == 1 || $mday == '01') {
	#last generated file copy from amazon to amazon
	#ls -lat | head -2 | tail -1 | awk '{print $9}'

    system(AWS_CMD_MONTHLY);
    #system(EXPIRY_AWS_CMD_MONTHLY);
}

#Crontab entry
#DB Backups 19-01-2017
#Daily
#0 0 * * * /var/dbbackup_daily > /dev/dbbackup_daily 2>&1
#Monthy
#0 0 1 * * /var/dbbackup_monthly > /dev/dbbackup_monthly 2>&1

1;