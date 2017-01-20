#!/usr/bin/perl

#  This command is used to backup db and upload to amazon
# Created by Dev : 18-01-2017 - Shriramsoft.com - shriramsoft@gmail.com


use strict;
use warnings FATAL => 'all';

use constant BACKUP_CMD => '/usr/local/bin/automysqlbackup /etc/automysqlbackup/vos3000-85.13.211.22.conf > /var/log/dbbackup';
use constant AMAZON_BUCKET => 'wholesale.gateway.backups/85.13.211.22-VOS';
use constant AWS_CMD  => '/usr/bin/s3cmd sync --recursive /var/backups/db s3://' . AMAZON_BUCKET . '/';

system(BACKUP_CMD);
system(AWS_CMD);


1;