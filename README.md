# TARS Software Setup

TARS is powered by a modular software stack designed for real-time speech, vision, and motor control. Follow these instructions to install and set up the TARS environment on your Raspberry Pi.

---

## Minimum Hardware Prerequisites

* **Raspberry Pi**
* **USB Microphone**
* **Speaker**

If you don’t already have Raspberry Pi OS installed, follow the Raspberry Pi Imager guide: 
https://youtu.be/DRJAILbqjy0?si=tuGTmIKr4FZVbT1F

---

## Environment Setup and Installation

### Configure Raspberry Pi

```sh
sudo raspi-config
```

Use the `Update` option to update the configuration tool (as shown in the provided image).

* Enable VNC, SPI, and I2C under **Interface Options**
* Go to **Advanced Options > Audio Config > Pipewire**

```sh
sudo reboot
```

### Install and Configure LCD-show

```sh
git clone https://github.com/goodtft/LCD-show.git
cd LCD-show
chmod +x LCD35-show
sudo ./LCD35-show
```

Update `/boot/config.txt` with:

```ini
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=82
framebuffer_width=1920
framebuffer_height=1080
dtoverlay=tft35a:rotate=270
```

Reboot:

```sh
sudo reboot
```

---

## Touchscreen Calibration

```sh
sudo apt-get install xinput-calibrator
xinput_calibrator
```

Follow the tool and save config:

```sh
sudo nano /usr/share/X11/xorg.conf.d/99-calibration.conf
```

Reboot:

```sh
sudo reboot
```

---

## Clone the TARS Repository

```sh
sudo apt install python3-venv -y
git clone https://github.com/omm-narayan/tars-main
cd tars-main
```

---

## Install System Dependencies

```sh
sudo apt update
sudo apt upgrade -y
chmod 777 Install.sh
chmod a+x Install.sh
sudo ./Install.sh
```

Fix permissions:

```sh
sudo chown $(id -u):$(id -g) .env
sudo chown $(id -u):$(id -g) src/config.ini
```

---

## Connect Hardware

* **USB Microphone**
* **External Speaker** (audio jack/Bluetooth)

---

## Install Audio AMP

Edit `/boot/config.txt`:

```ini
dtparam=audio=on
dtoverlay=hifiberry-dac
dtoverlay=i2s-mmap
```

```sh
source src/.venv/bin/activate
sudo apt install -y wget
pip3 install adafruit-python-shell
wget https://github.com/adafruit/Raspberry-Pi-Installer-Scripts/raw/main/i2samp.py
sudo -E env PATH=$PATH python3 i2samp.py
```

```sh
sudo reboot
```

After reboot:

```sh
source src/.venv/bin/activate
sudo -E env PATH=$PATH python3 i2samp.py
```

Adjust volume:

```sh
alsamixer
```

---

## Configure API Keys

Edit `.env`:

```env
OPENAI_API_KEY="your-key"
OOBA_API_KEY="your-key"
TABBY_API_KEY="your-key"
AZURE_API_KEY="your-key"
```

---

## Set Configuration Parameters

Edit `src/config.ini`:

```ini
[LLM]
llm_backend = openai
base_url = https://api.openai.com
openai_model = gpt-4o-mini

[TTS]
ttsoption = azure
azure_region = eastus
tts_voice = en-US-Steffan:DragonHDLatestNeural
```

---

## Run the Program

```sh
cd src/
python app.py
```

---

## Optional: Home Assistant Integration

Edit `src/config.ini`:

```ini
[HOME_ASSISTANT]
enabled = True
url = http://homeassistant.local:8123
```

Edit `.env`:

```env
HA_TOKEN="your-token"
```

Restart:

```sh
cd src/
python app.py
```

---

