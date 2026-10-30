# Nextcloud's official Apache image on the stable channel (the previous major's latest release).
FROM nextcloud:34.0.5-apache

# The image installs itself on first boot from the POSTGRES_*, NEXTCLOUD_ADMIN_* and REDIS_* variables.
# After the install, switch background jobs from AJAX (run only while someone has a page open) to cron,
# and add the indices and repairs the admin overview otherwise warns about.
COPY --chmod=755 hooks/post-installation.sh /docker-entrypoint-hooks.d/post-installation/railway.sh
COPY --chmod=755 hooks/post-installation.sh /docker-entrypoint-hooks.d/post-upgrade/railway.sh

# The Apache image ships cron.sh (busybox crond running cron.php every 5 minutes as www-data) but only
# the separate cron container runs it; run it beside Apache instead.
# Railway flattens image layers without applying deletions, so the php:apache base's disabled
# mpm_event links come back ("More than one MPM loaded"): remove them at start instead.
ENTRYPOINT ["sh", "-c", "rm -f /etc/apache2/mods-enabled/mpm_event.*; /cron.sh & exec /entrypoint.sh apache2-foreground"]
CMD []
