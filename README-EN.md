# VoHive Release

[中文](README.md) \| [English](README-EN.md)

Public distribution repository providing VoHive binary releases,
installation scripts, and operation documentation.

## Original Project

Original source project:

https://github.com/iniwex5/vohive

------------------------------------------------------------------------

# VoHive v2

VoHive v2 is an independent deployment and maintenance repository for
VoHive.

This project preserves VoHive executable files, configuration templates,
and Linux service files, allowing users to continue deploying and
maintaining VoHive environments after the upstream project stopped
maintenance.

## Features

This repository provides:

-   ARM64 Linux executable binary
-   systemd service configuration
-   Automatic installation scripts
-   Uninstallation scripts
-   Configuration templates
-   Offline installation support
-   Operation and maintenance documentation

------------------------------------------------------------------------

## Disclaimer

> \[!WARNING\] **Important: VoHive is intended for personal internal
> testing only. Commercial use is prohibited. The software must not be
> used for any illegal or unauthorized purpose.**
>
> Users are solely responsible for any legal consequences caused by
> violating local laws, regulations, or misuse of this software. The
> original author and this maintenance repository assume no
> responsibility. By using this software, you agree to this disclaimer.

------------------------------------------------------------------------

# Features Overview

VoHive is an integrated testing platform designed for Qualcomm 4G/5G
modem scenarios.

Main features:

-   SMS sending and receiving through Web interface / Bots
-   Multi-SIM device management
-   Physical eSIM/eUICC management (add, switch, delete profiles)
-   Telegram Bot / Feishu Bot / QQ Bot support
-   VoWiFi testing when requirements are met
-   VoWiFi simulated outgoing call testing through `/vocall`

------------------------------------------------------------------------

# Supported Environment

Currently tested:

-   Debian 12
-   Debian 13
-   ARM64 / aarch64

Theoretically supported:

-   Ubuntu ARM64
-   Raspberry Pi
-   NAS devices
-   Other Linux systems with systemd support

------------------------------------------------------------------------

# Hardware Requirements

Recommended devices:

-   Quectel EC20CE series 4G modules
-   Quectel EM500Q series 5G modules
-   Qualcomm 410 WiFi boards
-   Various Qualcomm USB 4G/5G modem devices

Requirements:

-   Device with SIM card slot
-   Or USB adapter board with SIM card slot

------------------------------------------------------------------------

# Installation

## Online Installation

``` bash
curl -fsSL https://raw.githubusercontent.com/Hercules-Zhaoziyi/vohive/main/install.sh | sudo bash
```

## Offline Installation

``` bash
tar xzf vohive-offline.tar.gz
cd vohive-offline
sudo bash install-local.sh
```

------------------------------------------------------------------------

# File Locations

Program:

    /opt/vohive/bin/vohive

Configuration:

    /opt/vohive/config/config.yaml

Data:

    /opt/vohive/data

Logs:

    /opt/vohive/logs

Service:

    /etc/systemd/system/vohive.service

------------------------------------------------------------------------

# Service Management

Start:

``` bash
systemctl start vohive
```

Stop:

``` bash
systemctl stop vohive
```

Restart:

``` bash
systemctl restart vohive
```

Status:

``` bash
systemctl status vohive
```

Logs:

``` bash
journalctl -u vohive -f
```

------------------------------------------------------------------------

# Web Management

Default port:

    7575

Access:

    http://DEVICE_IP:7575

Please change the default password immediately after first login.

------------------------------------------------------------------------

# ModemManager Compatibility

In QMI mode, VoHive uses qmi-proxy to access the control channel and can
coexist with ModemManager.

Note:

Do not allow multiple management services to control dialing, APN, or
data connections at the same time.

------------------------------------------------------------------------

# USBNET Mode Configuration

If the modem USB mode needs to be changed:

``` bash
sudo apt update
sudo apt install -y socat

echo 'AT+QCFG="usbnet",0;+CFUN=1,1' | sudo socat - /dev/ttyUSB2,crnl
```

Notes:

-   `usbnet=0`: Common QMI mode
-   `CFUN=1,1`: Restart modem
-   `/dev/ttyUSB2` should be replaced with the actual AT port

------------------------------------------------------------------------

# Docker Deployment

Create directories:

``` bash
mkdir -p vohive/{config,data,logs}
cd vohive
```

Configuration:

``` yaml
server:
  port: 7575
  debug: false

web:
  username: admin
  password: admin123
```

docker-compose.yml:

``` yaml
services:
  vohive:
    image: iniwex/vohive:latest
    container_name: vohive
    restart: unless-stopped
    network_mode: host
    privileged: true
    volumes:
      - ./config:/app/config
      - ./data:/app/data
      - ./logs:/app/logs
      - /dev:/dev
```

Start:

``` bash
docker compose up -d
```

------------------------------------------------------------------------

# Screenshots

### SMS Center

![SMS
Center](https://cdn.nodeimage.com/i/rnGhjMfPlMatrdxQMPogawI3d5OGc1Fu.png)

### Real-time Logs

![Real-time
Logs](https://cdn.nodeimage.com/i/GGAj5ua1dK4vZihroXV0pUmT7COonPnQ.png)

### System Settings

![System
Settings](https://cdn.nodeimage.com/i/hX90MLQqjmgkaPkZt4Pz4uCM1lHmDBx4.png)

### Device Management

![Device
Management](https://cdn.nodeimage.com/i/jbbwBuP1Zu9iPpfZrSsXzftGo0et5i4F.png)

### Dashboard

![Dashboard](https://cdn.nodeimage.com/i/P7BpZu8fF98622Q3VCZlafg4aBHVM8Qu.png)

### More Interface

![More
Interface](https://cdn.nodeimage.com/i/X5Ps5w9AHo1Qas6DDsnxYnbrfYcVhAfV.png)

------------------------------------------------------------------------

# Backup

Before upgrading or migrating:

``` bash
tar czf vohive-backup.tar.gz /opt/vohive
```

------------------------------------------------------------------------

# Security Recommendations

Do not expose the management port directly to the public Internet.

Recommended:

-   WireGuard
-   Tailscale
-   ZeroTier
-   SSH Tunnel

------------------------------------------------------------------------

# Project Maintenance

Maintainer:

**Hercules**

Repository:

https://github.com/Hercules-Zhaoziyi/vohive

This is not the official VoHive project.

The purpose of this repository is to preserve available versions and
provide continued deployment capability after upstream maintenance
stopped.

------------------------------------------------------------------------

# Acknowledgements

Thanks to the original VoHive author for developing this project.

This repository exists to help existing users preserve, deploy, and
maintain available VoHive versions.
