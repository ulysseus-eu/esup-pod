FROM python:3.7-slim

ENV PATH=/home/pod/.local/bin:$PATH

RUN useradd \
    --shell /bin/bash \
    --create-home \
    pod

RUN apt-get update \
 && apt upgrade -y \
 && apt-get install -y --no-install-recommends \
    git python3-pip ffmpeg ffmpegthumbnailer imagemagick nano rustc \
 && rm -rf /var/lib/apt/lists/*

USER pod
WORKDIR /home/pod

RUN git clone https://github.com/EsupPortail/Esup-Pod.git
WORKDIR /home/pod/Esup-Pod

RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt

RUN sh create_data_base.sh

RUN pip3 install uwsgi
COPY ./pod_uwsgi.ini /home/pod/Esup-Pod/pod/custom/
