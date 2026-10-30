#!/bin/sh
# Runs as www-data after the first install and after every upgrade.
php /var/www/html/occ background:cron
php /var/www/html/occ db:add-missing-indices
php /var/www/html/occ maintenance:repair --include-expensive
php /var/www/html/occ config:system:set maintenance_window_start --type=integer --value=1
