FROM python:3.11-slim-buster as base

RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends g++ curl \
    && rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV=/opt/django_auto_instrumentation
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["opentelemetry-instrument", "python", "manage.py", "runserver", "--noreload", "0.0.0.0:8000"]
