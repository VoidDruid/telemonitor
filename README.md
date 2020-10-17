# Telemonitor
Telegram bot that helps me monitor my vps.

>[Telemonitor at docker hub](https://hub.docker.com/r/voidwalker/telemonitor) - `docker pull voidwalker/telemonitor`
>
>[docker-compose.yml](https://github.com/VoidDruid/telemonitor/blob/master/docker-compose.yml) - **docker-compose file for deployment**

Required env variables:

- `TELEMONITOR_TOKEN`: telegram bot token
- `ADMIN_IDS`: comma separated list of telegram ids of users that are allowed to use bot - `id1,id2`
- `RUN_LEVEL`: set `production` for deployment, it will disable debug logs

Supported commands:

- **/start** - welcome message
- **/help** - welcome message
- **/system** - system stats (uptime and processes)
- **/ram** - RAM usage
- **/docker** - running docker containers
- **/stats** - all available stats

In progress:

- more commands - cpu, disk (for now they return current time as placeholder)
