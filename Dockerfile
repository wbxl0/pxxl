# Runs app.py directly as a plain asyncio server.
#
# Do NOT put this behind Gunicorn or Uvicorn: app.py starts its own TCP
# server with asyncio.start_server() and exposes no WSGI/ASGI callable, so a
# process manager looking for an `app` object would fail at startup.
#
# The listen port comes from the platform's PORT env var (app.py resolves
# SERVER_PORT -> PORT -> 3000), so no EXPOSE is declared on purpose.

FROM python:3.13-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# curl is only used by the optional AUTO_ACCESS hook; ca-certificates keeps
# outbound TLS to the gateway working.
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY *.py ./

CMD ["python", "app.py"]
