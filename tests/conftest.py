import os

os.environ.setdefault("DB", "postgres")
pytest_plugins = [
    "sentry.testutils.pytest",
]
