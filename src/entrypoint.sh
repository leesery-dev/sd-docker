#!/bin/bash

set -euo pipefail

export TARGET_DIR="/opt/stable-diffusion-webui"

chown -R sd:sd "$TARGET_DIR"

# Drop privileges and execute the main logic as the `sd` user.
runuser -u sd -- /bin/bash -s -- "$@" <<'EOF'
    set -euo pipefail

    if [ ! -d "$TARGET_DIR/.git" ]; then
        echo "Cloning stable-diffusion-webui into $TARGET_DIR/.git..."

        pushd "$TARGET_DIR"
        git init
        git remote add origin https://github.com/AUTOMATIC1111/stable-diffusion-webui
        git fetch origin dev --depth=1
        # Use dev branch due to stablediffusion repo URL change.
        # See: https://github.com/AUTOMATIC1111/stable-diffusion-webui/pull/17207
        git checkout FETCH_HEAD --force
        popd
    fi

    cd "$TARGET_DIR"
    [ -d "venv" ] || python3 -m venv venv
    . venv/bin/activate

    # Install torch~=2.7.0 and torchvision~=0.22.0 with cuda 12.8 toolkit to support Pascal GPU.
    [ -d "venv/lib/python3.13/site-packages/torch" ] || pip3 install -r ../requirements.txt
   
    ./webui.sh "$@"
EOF