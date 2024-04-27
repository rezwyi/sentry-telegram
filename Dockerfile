FROM getsentry/sentry:24.1.0

WORKDIR /app

RUN pip install \
    fixtures \
    pytest \
    pytest-django \
    responses \
    selenium

COPY . .

ENTRYPOINT ["sh", "-c"]
CMD ["pytest"]
