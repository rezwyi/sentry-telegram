FROM getsentry/sentry:24.4.1

WORKDIR /app

RUN pip install pytest responses pytest-django pytest-sentry selenium

COPY . .

ENTRYPOINT ["sh", "-c"]
CMD ["pytest"]
