FROM jupyter/minimal-notebook

MAINTAINER Hassan El Karhani <hkarhani@gmail.com>

ENV JUPYTER_PORT 8888
ENV JUPYTER_IP 0.0.0.0
ENV JUPYTER_NOTEBOOK_DIR /opt/jupyter
ENV DEBIAN_FRONTEND=noninteractive

USER root

# Installing dependencies
RUN apt-get update --fix-missing
RUN apt-get dist-upgrade -y
RUN apt-get install --no-install-recommends -y \
        build-essential \
        curl \
        git-core \
        pkg-config \
        libzmq3-dev \
        ssh \
        vim \
        python3 \
        python3-pip \
        python3-dev \
        zip


RUN pip --no-cache-dir install jupyter pandas numpy cython \
        ipython pyyaml pysnmp paramiko requests

# Installing IPerl without tests ...
RUN curl -sL http://cpanmin.us | perl - App::cpanminus \
    && /usr/local/bin/cpanm --notest Devel::IPerl \
        Test::More \
        XML::Simple \
        YAML::Tiny

RUN apt-get update
RUN apt-get install -y git libjpeg-dev zlib1g-dev

RUN apt-get clean && \
    rm -rf /tmp/downloaded_packages/* && \
    rm -rf /var/lib/apt/lists/*

VOLUME $JUPYTER_NOTEBOOK_DIR

RUN mkdir -p $JUPYTER_NOTEBOOK_DIR
WORKDIR $JUPYTER_NOTEBOOK_DIR

RUN CFLAGS="-I/usr/pkg/include" python3 -m pip install Pillow

COPY requirements.txt ./
RUN pip install -U pip
RUN pip install --no-cache-dir -r requirements.txt
RUN rm ./requirements.txt

ADD *.ipynb ./

RUN chown -R $(whoami):$(whoami) $JUPYTER_NOTEBOOK_DIR

ENTRYPOINT iperl notebook --port $JUPYTER_PORT --ip $JUPYTER_IP --notebook-dir $JUPYTER_NOTEBOOK_DIR --allow-root --NotebookApp.token=''
