# VoHive Release

[中文](README.md) \| [English](README-EN.md)

公开分发仓库：提供 VoHive 二进制发布资产、安装脚本和运维文档。

## 项目源码

原始项目： https://github.com/iniwex5/vohive

------------------------------------------------------------------------

## 免责声明

> \[!WARNING\]
> **重要提示：本软件（VoHive）仅供个人内部测试使用，严禁商业使用，以及严禁将本软件用于任何非法或违规场景。**
>
> 使用者因违反当地法律法规、非法使用本软件造成的一切法律责任及后果，由使用者自行承担，软件原作者及本维护仓库不承担任何责任。使用本软件即表示您同意本免责声明。

# VoHive v2

VoHive v2 是一个用于部署和维护 VoHive 服务的独立安装仓库。

本项目用于保存 VoHive 可执行程序、配置模板以及 Linux
服务文件，使用户可以在上游项目停止维护后继续部署和管理自己的 VoHive
环境。

# 功能介绍

VoHive 是面向高通 4G/5G 模组场景的一体化测试平台，核心能力包括：

-   网页 / Bot 收发短信
-   多卡统一管理
-   实体 eSIM/eUICC 管理（加卡、切卡、删卡）
-   Telegram Bot / 飞书 Bot / QQ Bot
-   在条件满足时启用 VoWiFi 测试
-   通过 `/vocall` 发起 VoWiFi 模拟外呼测试

本仓库提供：

-   ARM64 Linux 可执行程序
-   systemd 服务配置
-   自动安装脚本
-   卸载脚本
-   配置模板
-   离线安装支持

## 系统支持

当前测试：

-   Debian 12
-   Debian 13
-   ARM64 / aarch64

# 硬件要求

推荐：

-   移远 EC20CE 系列 4G 模块
-   移远 EM500Q 系列 5G 模块
-   高通 410 WIFI 板
-   各类高通 USB 4G/5G 模组

要求：

-   设备具备 SIM 卡槽
-   或搭配带 SIM 卡槽的 USB 底板

## 安装

在线安装：

``` bash
curl -fsSL https://raw.githubusercontent.com/Hercules-Zhaoziyi/vohive/main/install.sh | sudo bash
```

离线安装：

``` bash
tar xzf vohive-offline.tar.gz
cd vohive-offline
sudo bash install-local.sh
```

## 文件位置

程序：

    /opt/vohive/bin/vohive

配置：

    /opt/vohive/config/config.yaml

数据：

    /opt/vohive/data

日志：

    /opt/vohive/logs

服务：

    /etc/systemd/system/vohive.service

## 服务管理

启动：

``` bash
systemctl start vohive
```

停止：

``` bash
systemctl stop vohive
```

重启：

``` bash
systemctl restart vohive
```

状态：

``` bash
systemctl status vohive
```

日志：

``` bash
journalctl -u vohive -f
```

------------------------------------------------------------------------

## Web 管理

默认端口：

    7575

访问：

    http://设备IP:7575

首次登录后请修改默认密码。

## 功能展示

### 短信中心

![短信中心](https://cdn.nodeimage.com/i/rnGhjMfPlMatrdxQMPogawI3d5OGc1Fu.png)

### 实时日志

![实时日志](https://cdn.nodeimage.com/i/GGAj5ua1dK4vZihroXV0pUmT7COonPnQ.png)

### 系统设置

![系统设置](https://cdn.nodeimage.com/i/hX90MLQqjmgkaPkZt4Pz4uCM1lHmDBx4.png)

### 设备管理

![设备管理](https://cdn.nodeimage.com/i/jbbwBuP1Zu9iPpfZrSsXzftGo0et5i4F.png)

### 仪表盘

![仪表盘](https://cdn.nodeimage.com/i/P7BpZu8fF98622Q3VCZlafg4aBHVM8Qu.png)

### 更多界面

![更多界面](https://cdn.nodeimage.com/i/X5Ps5w9AHo1Qas6DDsnxYnbrfYcVhAfV.png)

## 数据备份

升级或迁移前：

``` bash
tar czf vohive-backup.tar.gz /opt/vohive
```

## 安全建议

不要直接将管理端口暴露到公网。

推荐：

-   局域网
-   WireGuard
-   Tailscale
-   ZeroTier
-   SSH 隧道

# 项目维护

Maintainer:

**Hercules**

Repository:

https://github.com/Hercules-Zhaoziyi/vohive

本仓库不是 VoHive 官方项目。

由于上游项目停止维护，本项目用于保存已有版本并提供继续部署能力。

------------------------------------------------------------------------

# 致谢

感谢 VoHive 原作者开发并维护该项目。

本仓库旨在帮助已有用户保存、部署和维护可用版本。
