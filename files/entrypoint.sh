#!/bin/bash

set -euo pipefail

export TARGET_DIR="/opt/stable-diffusion-webui"

chown -R sd:sd "$TARGET_DIR"

# Drop privileges and execute the main logic as the `sd` user.
runuser -u sd -- /bin/bash -s -- "$@" <<'EOF'
    set -euo pipefail

    if [ ! -d "$TARGET_DIR/.git" ]; then
        echo "Cloning stable-diffusion-webui into $TARGET_DIR..."

        # Use dev branch due to stablediffusion repo URL change.
        # See: https://github.com/AUTOMATIC1111/stable-diffusion-webui/pull/17207
        git clone --branch dev https://github.com/AUTOMATIC1111/stable-diffusion-webui "$TARGET_DIR"
    fi

    cd "$TARGET_DIR"
    [ -d "venv" ] || python3 -m venv venv
    . venv/bin/activate

    # Install torch and torchvision with cuda 12.6 toolkit to support Pascal GPU.
    [ -d "venv/lib/python3.11/site-packages/torch" ] || pip install -r ../requirements-torch.txt

    # Install clip from git because module 'pkg_resources' removed setuptools.
    # See: https://github.com/AUTOMATIC1111/stable-diffusion-webui/issues/17284
    [ -d "venv/lib/python3.11/site-packages/clip" ] || pip install -r ../requirements-clip.txt
    
    ./webui.sh "$@"
EOF