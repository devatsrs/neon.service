#!/bin/sh

sudo git --git-dir /vol/data/speakintelligent.neon.service/.git  pull

sudo chown -R neon_sys:apache /vol/data/speakintelligent.neon.service

sudo find /vol/data/speakintelligent.neon.service -type d -exec chmod 575 {} +
sudo find /vol/data/speakintelligent.neon.service -type f -exec chmod 464 {} +

touch /vol/data/cron_job_speakintelligent

sudo chmod -R 770 /vol/data/speakintelligent.neon.service/storage
sudo chown -R neon_sys:apache /vol/data/cron_job_speakintelligent
echo "success"