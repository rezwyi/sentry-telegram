FROM getsentry/sentry:24.4.1

WORKDIR /app

RUN pip install pytest exam responses pytest-django pytest-sentry

COPY . .

ENTRYPOINT ["sh", "-c"]
CMD ["pytest"]
