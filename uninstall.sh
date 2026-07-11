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

if [[ ${EUID} -ne 0 ]]; then
  echo "请使用 root 运行：sudo bash uninstall.sh" >&2
  exit 1
fi

PURGE=0
[[ "${1:-}" == "--purge" ]] && PURGE=1

systemctl disable --now vohive 2>/dev/null || true
rm -f /etc/systemd/system/vohive.service
systemctl daemon-reload

if [[ $PURGE -eq 1 ]]; then
  BACKUP="/root/vohive-before-purge-$(date +%Y%m%d-%H%M%S).tar.gz"
  [[ -d /opt/vohive ]] && tar -czf "$BACKUP" -C / opt/vohive
  rm -rf /opt/vohive
  echo "已彻底卸载；删除前备份：$BACKUP"
else
  rm -f /opt/vohive/bin/vohive
  echo "已卸载程序，配置、数据库和日志仍保留在 /opt/vohive。"
  echo "彻底删除请运行：sudo bash uninstall.sh --purge"
fi
