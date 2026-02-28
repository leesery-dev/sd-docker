# Quick Stable Diffusion Web UI Docker Setup

This repository provides a simple Docker and Docker Compose setup for running the [AUTOMATIC1111/stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui).

It's designed to be a very fast, quick, and dirty method to get a containerized instance of the web UI up and running with minimal configuration.

## How It Works

This setup essentially automates the steps outlined in the official [Install and Run on NVidia GPUs](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Install-and-Run-on-NVidia-GPUs) guide within a Docker container.

To build the image, run `docker build -t leesery/sd-docker:pascal .`

When you run `docker-compose up -d`, it will:
1.  Clone the latest version of the `stable-diffusion-webui` repository into it.
2.  Install dependencies and launch the web UI.

All models, outputs, and configuration will be stored in the `works` folder on your local machine.

## Updating or Resetting

To update the web UI to the latest version or to perform a clean reset, simply stop the container (`docker-compose down`), delete the volume (`docker volume rm sd-docker_sd-data`), and run `docker-compose up` again. This will re-download everything from scratch. The volatile files such as models and generated pictures remain safe
