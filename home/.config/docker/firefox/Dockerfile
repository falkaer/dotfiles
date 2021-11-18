FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y \
        software-properties-common \
        ubuntu-restricted-extras \
        libavcodec58 \
        ffmpeg \
        x11-apps \
        libxv1 \
        pulseaudio \
        libpulse0 \
    && add-apt-repository -y ppa:mozillateam/ppa \
    && apt-get install -y \
        firefox-esr

RUN groupadd -g 1001 group && useradd -m -u 1000 -g 1001 user \
  && yes password | passwd user

RUN usermod -s /bin/bash user

ENV PULSE_SERVER=unix:/pulse/socket
CMD firefox-esr --new-instance --private-window
