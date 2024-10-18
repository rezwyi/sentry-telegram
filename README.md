# sentry-telegram

Plugin for self-hosted Sentry which allows sending notification via [Telegram](https://telegram.org/) messenger.

Presented plugin tested with the following self-hosted Sentry versions:
1. 24.3.x
1. 24.4.x
1. 24.5.x

## Install

```shell
vi sentry/enhance-image.sh #see https://develop.sentry.dev/self-hosted/#configuration

apt-get update && apt install -y git
pip install git+https://github.com/rezwyi/sentry-telegram.git@v24.5.1
```

## Testing

```shell
./run-tests.sh --version v24.5.1
```
