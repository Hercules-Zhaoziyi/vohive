#!/usr/bin/env bash

# ============================================================
# VoHive v2 Installer
#
# Maintainer: Hercules
# Repository: Hercules-Zhaoziyi/vohive
#
# Long-term maintenance edition for VoHive ARM64 deployment.
# ============================================================
set -Eeuo pipefail

APP_NAME="vohive"
INSTALL_DIR="/opt/vohive"
SERVICE_FILE="/etc/systemd/system/vohive.service"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
FORCE_CONFIG=0

usage() {
  cat <<USAGE
用法: sudo bash install.sh [--force-config]

--force-config  用安装包中的空白配置覆盖现有 config.yaml
默认行为会保留已有配置与数据。
USAGE
}

for arg in "$@"; do
  case "$arg" in
    --force-config) FORCE_CONFIG=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "未知参数: $arg" >&2; usage; exit 2 ;;
  esac
done

if [[ ${EUID} -ne 0 ]]; then
  echo "请使用 root 运行：sudo bash install.sh" >&2
  exit 1
fi

ARCH="$(dpkg --print-architecture 2>/dev/null || uname -m)"
case "$ARCH" in
  arm64|aarch64) ;;
  *)
    echo "此安装包仅支持 ARM64/aarch64，当前架构：$ARCH" >&2
    exit 1
    ;;
esac

for f in bin/vohive config/config.yaml data/mcc-mnc-table.json systemd/vohive.service; do
  if [[ ! -f "$SCRIPT_DIR/$f" ]]; then
    echo "安装包缺少文件：$f" >&2
    exit 1
  fi
done

if systemctl is-active --quiet "$APP_NAME" 2>/dev/null; then
  systemctl stop "$APP_NAME"
fi

if [[ -d "$INSTALL_DIR" ]]; then
  BACKUP="/root/vohive-before-install-$(date +%Y%m%d-%H%M%S).tar.gz"
  tar -czf "$BACKUP" -C / opt/vohive 2>/dev/null || true
  echo "已有安装已备份到：$BACKUP"
fi

install -d -m 755 "$INSTALL_DIR/bin" "$INSTALL_DIR/config" "$INSTALL_DIR/data" "$INSTALL_DIR/logs"
install -m 755 "$SCRIPT_DIR/bin/vohive" "$INSTALL_DIR/bin/vohive"
install -m 644 "$SCRIPT_DIR/data/mcc-mnc-table.json" "$INSTALL_DIR/data/mcc-mnc-table.json"

if [[ ! -f "$INSTALL_DIR/config/config.yaml" || $FORCE_CONFIG -eq 1 ]]; then
  install -m 600 "$SCRIPT_DIR/config/config.yaml" "$INSTALL_DIR/config/config.yaml"
  echo "已安装空白配置。默认账号：admin，默认密码：admin，请登录后立即修改。"
else
  echo "已保留现有配置：$INSTALL_DIR/config/config.yaml"
fi

install -m 644 "$SCRIPT_DIR/systemd/vohive.service" "$SERVICE_FILE"
systemctl daemon-reload
systemctl enable "$APP_NAME" >/dev/null
systemctl restart "$APP_NAME"
sleep 1

if systemctl is-active --quiet "$APP_NAME"; then
  echo
  echo "VoHive 安装成功。"
  echo "访问地址：http://设备IP:7575"
  echo "状态查看：systemctl status vohive --no-pager -l"
  echo "日志查看：journalctl -u vohive -f"
else
  echo "VoHive 启动失败，最近日志如下：" >&2
  journalctl -u "$APP_NAME" -n 80 --no-pager >&2 || true
  exit 1
fi
