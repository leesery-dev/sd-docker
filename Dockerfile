FROM python:3.11-trixie

RUN apt-get update && apt-get install -y libgl1 git

COPY src/* /opt/

RUN useradd -ms /bin/bash sd && \
    mkdir -p /opt/stable-diffusion-webui && \
    chown sd:sd /opt/stable-diffusion-webui && \
    chmod +x /opt/entrypoint.sh

VOLUME /opt/stable-diffusion-webui
EXPOSE 7860

ENTRYPOINT [ "/opt/entrypoint.sh" ]