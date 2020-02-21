# Telemonitor
Telegram bot that helps me monitor my vps.

[Telemonitor at docker hub](https://hub.docker.com/r/voidwalker/telemonitor) - `docker pull voidwalker/telemonitor`

Supported commands:

- **/start** - welcome message
- **/help** - welcome message
- **/system** - system stats (uptime and processes)
- **/ram** - RAM usage
- **/docker** - running docker containers
- **/stats** - all available stats

In progress:
- auth
- "normal" Dockerfile (build inside container)
- more commands - cpu, disk
