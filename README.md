# sentry-telegram

Plugin for self-hosted Sentry which allows sending notification via [Telegram](https://telegram.org/) messenger.

Presented plugin tested with the following self-hosted Sentry versions:
1. 24.3.0
1. 24.4.0
1. 24.4.1
1. 24.4.2
1. 24.5.0

## Install

```shell
vi sentry/enhance-image.sh #see https://develop.sentry.dev/self-hosted/#configuration

apt-get update && apt install -y git
pip install git+https://github.com/rezwyi/sentry-telegram.git@v24.5.0
```

## Testing

```shell
./run-tests.sh --version 24.5.0
```
