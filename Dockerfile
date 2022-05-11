# This file is a template, and might need editing before it works on your project.
FROM python:3.6

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git python3-pip ffmpeg ffmpegthumbnailer imagemagick \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
RUN git clone https://github.com/EsupPortail/Esup-Pod.git
WORKDIR /usr/src/Esup-Pod
RUN python -m venv env
RUN source env/bin/activate
RUN pip install --no-cache-dir -r requirements.txt

COPY ./uwsgi-pod.service /etc/systemd/system/
service start uwsgi-pod

# For Django
EXPOSE 8000
