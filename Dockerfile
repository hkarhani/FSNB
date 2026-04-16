FROM quay.io/jupyter/base-notebook:python-3.11

LABEL org.opencontainers.image.title="FSNB" \
      org.opencontainers.image.description="FSNB custom JupyterLab environment" \
      org.opencontainers.image.source="https://github.com/hkarhani/FSNB"

ENV JUPYTER_PORT=8888 \
    JUPYTER_IP=0.0.0.0 \
    JUPYTER_NOTEBOOK_DIR=/notebooks \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

ARG DEBIAN_FRONTEND=noninteractive
ARG ENABLE_IPERL=true
ARG INSTALL_DEBUG_TOOLS=false

USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      pkg-config \
      libzmq3-dev \
      libssl-dev \
      python3-dev \
      libjpeg-dev \
      zlib1g-dev \
      zip \
      libxml-simple-perl \
      libyaml-tiny-perl \
      cpanminus && \
    if [ "$INSTALL_DEBUG_TOOLS" = "true" ]; then \
      apt-get install --no-install-recommends -y \
        git \
        openssh-client \
        vim \
        nmap; \
    fi && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt

RUN python -m pip install --upgrade pip setuptools wheel && \
    if [ -s /tmp/requirements.txt ]; then \
      pip install --no-cache-dir -r /tmp/requirements.txt; \
    fi && \
    rm -f /tmp/requirements.txt

RUN if [ "$ENABLE_IPERL" = "true" ]; then \
      cpanm --notest IO::Socket::SSL Net::SSLeay && \
      cpanm --notest Alien::FFI FFI::Platypus && \
      cpanm --notest ZMQ::FFI && \
      cpanm --notest Devel::IPerl; \
    fi

RUN mkdir -p "${JUPYTER_NOTEBOOK_DIR}" && \
    chown -R "${NB_UID}:${NB_GID}" "${JUPYTER_NOTEBOOK_DIR}"

USER ${NB_UID}
WORKDIR ${JUPYTER_NOTEBOOK_DIR}

EXPOSE 8888

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8888/lab', timeout=5)" || exit 1

CMD ["start-notebook.py", "--ServerApp.root_dir=/notebooks", "--ServerApp.ip=0.0.0.0", "--ServerApp.port=8888"]