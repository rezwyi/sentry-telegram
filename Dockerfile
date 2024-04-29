ARG SENTRY_VERSION=24.1.0
FROM getsentry/sentry:${SENTRY_VERSION}

WORKDIR /app

RUN pip install \
    fixtures \
    pytest \
    pytest-django \
    pytest-xdist \
    responses \
    selenium \
    time_machine

COPY . .

ENTRYPOINT ["sh", "-c"]
CMD ["pytest"]
