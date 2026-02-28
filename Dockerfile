FROM python:3.11-slim-trixie

RUN apt-get update && apt-get install -y libgl1 git libglib2.0-0
RUN python3 -m pip install pip --upgrade && pip3 install setuptools wheel --upgrade

COPY src/* /opt/

RUN useradd -ms /bin/bash sd && \
    mkdir -p /opt/stable-diffusion-webui && \
    chown sd:sd /opt/stable-diffusion-webui && \
    chmod +x /opt/entrypoint.sh

VOLUME /opt/stable-diffusion-webui
EXPOSE 7860

ENTRYPOINT [ "/opt/entrypoint.sh" ]