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
  echo "请使用 root 运行：sudo bash backup.sh" >&2
  exit 1
fi
OUT="${1:-/root/vohive-backup-$(date +%Y%m%d-%H%M%S).tar.gz}"
systemctl stop vohive 2>/dev/null || true
trap 'systemctl start vohive 2>/dev/null || true' EXIT
tar -czf "$OUT" /opt/vohive /etc/systemd/system/vohive.service
sha256sum "$OUT" > "$OUT.sha256"
echo "备份完成：$OUT"
echo "校验文件：$OUT.sha256"
