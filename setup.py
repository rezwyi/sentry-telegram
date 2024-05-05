#!/usr/bin/env python

from setuptools import setup

setup(
    entry_points={
        'sentry.plugins': [
            'sentry_telegram = sentry_telegram.plugin:TelegramPlugin',
        ],
    },
)
