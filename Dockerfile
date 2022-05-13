# This file is a template, and might need editing before it works on your project.
FROM python:3.7

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
#RUN python -m venv env
RUN pip install -r requirements.txt

COPY ./create_db.sh /home/pod/Esup-Pod/
RUN ./create_db.sh


# USER root
RUN pip3 install uwsgi
COPY ./pod_uwsgi.ini /home/pod/Esup-Pod/pod/custom/
#COPY ./uwsgi-pod.service /etc/systemd/system/uwsgi-pod.service
#RUN systemctl daemon-reload
#RUN service uwsgi-pod enable
#RUN service uwsgi-pod start
