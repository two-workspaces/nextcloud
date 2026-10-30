# Deploy and Host Nextcloud on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/nextcloud-server?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=nextcloud-server)

[Nextcloud](https://nextcloud.com/) is the open-source file sync and collaboration platform: files on every device, sharing with links and passwords, calendars, contacts, Talk video calls, and hundreds of apps on top. This template runs Nextcloud's official image on Postgres and Redis, installs it on first boot with your admin account, and runs its background jobs on cron.

## About Hosting Nextcloud

The stack is three services: Nextcloud, Postgres and Redis.

- **Installed on boot.** The first boot installs Nextcloud with your admin account, so the setup wizard is never open to whoever finds the URL first.
- **Postgres, not SQLite.** Nextcloud's own docs advise against SQLite beyond testing: it locks the whole database on every write, and the desktop and mobile clients sync slowly against it.
- **Redis for locking and caching.** Transactional file locking and the memory cache run on Redis, which keeps concurrent syncs from corrupting each other.
- **Background jobs on cron.** Cleanup, previews, notifications and shares expiry run every five minutes, not only while someone has a page open.
- **Upgrades on a tag bump.** The image is pinned to Nextcloud's stable channel. A newer tag upgrades the installation on boot.

## Common Use Cases

- A private Dropbox or Google Drive replacement for a family or small team
- Shared calendars, contacts and documents for a small business
- File sharing with clients through password-protected links

## Dependencies for Nextcloud Hosting

- Postgres 18 (included, private network only)
- Redis 8 (included, private network only)

### Deployment Dependencies

- [Nextcloud admin manual](https://docs.nextcloud.com/server/latest/admin_manual/)
- [Nextcloud Docker image](https://github.com/nextcloud/docker)
- [Template source on GitHub](https://github.com/two-workspaces/nextcloud)

### Implementation Details

**Sign in** at the Nextcloud service's Railway domain as `admin` with the `NEXTCLOUD_ADMIN_PASSWORD` value from the Nextcloud service's Variables tab. The first boot copies Nextcloud onto the volume and installs it, so give it three or four minutes. Change the password afterwards under Personal settings → Security; the variable is only read on first boot.

**Storage.** Files live on the Nextcloud service's volume at `/var/www/html/data`. Grow the volume in the service's settings as you add files, and enable Railway's volume backups on it and on the Postgres volume.

**Memory.** Around 350 MB at idle: about 200 MB for Nextcloud, 100 MB for Postgres and a few MB for Redis. Previews of large images and office documents take more while they render. It fits every plan.

**Email.** Nextcloud sends share notifications and password resets by email. Railway only allows outbound SMTP on the Pro plan; on Pro, set it up under Administration settings → Basic settings.

**Custom domain.** Add it in the Nextcloud service's Settings → Networking, then add it to Nextcloud's trusted domains in a `railway ssh` session on the Nextcloud service: `su -s /bin/sh www-data -c "php occ config:system:set trusted_domains 2 --value=cloud.example.com"`, and set `OVERWRITECLIURL` to `https://` plus your domain.

## Why Deploy Nextcloud on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Nextcloud on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
