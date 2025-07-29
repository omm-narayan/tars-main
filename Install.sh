#!/bin/bash

set -e  # Exit on any error

# Function to retry pip install if it fails
retry_pip_install() {
    local n=1
    local max=5
    local delay=5

    while true; do
        pip install -r requirements.txt && break || {
            if [[ $n -lt $max ]]; then
                echo "pip install failed (attempt $n/$max). Retrying in $delay seconds..."
                sleep $delay
                ((n++))
            else
                echo "pip install failed after $max attempts. Exiting."
                exit 1
            fi
        }
    done
}

sudo apt clean
sudo apt update -y
sudo apt install -y chromium-browser chromium-chromedriver sox libsox-fmt-all portaudio19-dev espeak-ng

chromium-browser --version
chromedriver --version
sox --version

if [ ! -d "src" ]; then
    echo "Error: 'src' directory not found!"
    exit 1
fi
cd src

python3 -m venv .venv

if [ -f ".venv/bin/activate" ]; then
    source .venv/bin/activate
else
    echo "Error: Virtual environment activation script not found!"
    exit 1
fi

sudo apt-get install -y libcap-dev

pip install --upgrade pip

retry_pip_install

if [ ! -f "config.ini" ]; then
    cp config.ini.template config.ini
    echo "Default config.ini created. Please edit it with necessary values."
fi

if [ ! -f "../.env" ]; then
    cp ../.env.template ../.env
    echo "Default .env created. Please edit it with necessary values."
fi

echo "Installation completed successfully!"
