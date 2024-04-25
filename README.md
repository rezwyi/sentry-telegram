# sentry-telegram

Plugin for self-hosted Sentry which allows sending notification via [Telegram](https://telegram.org/) messenger.

Presented plugin tested with the following self-hosted Sentry versions:
1. 22.x.x
1. 23.x.x
1. 24.x.x

## Install

```shell
vi sentry/enhance-image.sh #see https://develop.sentry.dev/self-hosted/#configuration

apt-get update
apt-get install -y git
pip install git+https://github.com/rezwyi/sentry-telegram.git@v24.3.0
```
