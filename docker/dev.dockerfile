# syntax=docker/dockerfile:1.1.7-experimental
FROM python:3.8-slim-buster

ARG WORKDIR=/app
WORKDIR ${WORKDIR}

# 1. Image setup.
USER root

# 1.1 Install poetry and it's pre-requisistes 
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt : \
      && apt-get update \
      && apt-get install --yes git gosu make ssh-client \
      && :

# Install poetry and deactivate automatic virtual env for poetry
# See https://python-poetry.org/docs/faq/#i-dont-want-poetry-to-manage-my-virtual-environments-can-i-disable-it
RUN : \
      && pip install --no-cache-dir poetry \
      && :
env POETRY_VIRTUALENVS_CREATE=false

# 2. Install project dependencies

# Install non-conda requirements e.g. dain common library from private github.
COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock
RUN --mount=type=ssh,mode=0666 : \
      # Prepare ssh-keys for github
      && cd /app \
      && poetry install --no-root \
      && :

# Use an unpriviledged user by default.
ENV HOME=/tmp
USER nobody
