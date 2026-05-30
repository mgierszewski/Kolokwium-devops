
FROM python:3.12-slim as base

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
COPY requirements-dev.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ ./app/

# Ustawienie nie-rootowego użytkownika
RUN useradd -m appuser
USER appuser

EXPOSE 8080

# Komenda startowa (gunicorn, WSGI, port 8080, katalog app)
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "app.main:app"]
