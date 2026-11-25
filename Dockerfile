# syntax=docker/dockerfile:1

# ---- Build stage: uv + git already present ----
FROM ghcr.io/astral-sh/uv:python3.15-trixie AS build

# Copy the application into the container.
COPY . /app

# Install the application dependencies (runtime only, precompiled bytecode).
WORKDIR /app
RUN uv sync --locked --no-cache --no-dev --compile-bytecode

# ---- Run stage: slim python + venv only ----
FROM python:3.15-slim

WORKDIR /app
COPY --from=build /app /app

# Call the venv's uvicorn directly; uv has done its job once the venv exists.
CMD ["/app/.venv/bin/uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80", "--log-config", "log-config.json"]
