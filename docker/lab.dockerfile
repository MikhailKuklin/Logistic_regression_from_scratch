FROM jupyter/base-notebook

USER root
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt : \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
    bash \
    curl \
    git \
    ssh-client \
    && :

# Install poetry
USER root
# Prevent poetry from creating virtual envs
ENV POETRY_VIRTUALENVS_CREATE=false
RUN : \
    && curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | POETRY_HOME=/opt/poetry python - \
    && chmod +rx /opt/poetry/bin/poetry \
    && ln -s /opt/poetry/bin/poetry /usr/local/bin \
    && :

# Install project
USER $NB_USER

# Run personal jupyter setup
COPY --chown=$NB_UID:$NB_GID docker/personal-setup.sh* /image-setup/personal-setup.sh
# We cannot get the error-trapping right with `&&` and `||`.
RUN if [ -x /image-setup/personal-setup.sh ]; then /image-setup/personal-setup.sh; fi


# Copy project and dependencies.
#COPY --chown=$NB_UID:$NB_GID xaiops/ /app/xaiops/
# Use poetry.lock* to cope with missing lock-file
COPY --chown=$NB_UID:$NB_GID pyproject.toml poetry.lock* /app/

RUN --mount=type=ssh,mode=0666 : \
    # Install project
    && cd /app \
    && poetry install \
    && :

# Configure Jupyter image
# See https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html#docker-options
ENV GRANT_SUDO="yes" \
    JUPYTER_ENABLE_LAB="yes" \
    TOKEN="logreg"

# Set password.
CMD ["sh", "-c", "exec start-notebook.sh --NotebookApp.token=$TOKEN"]

# Start as root to make GRANT_SUDO work
USER root
