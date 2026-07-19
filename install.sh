#!/usr/bin/env bash

# ============================================================
# VoHive v2 安装脚本
#
# 维护者：Hercules
# 仓库：https://github.com/Hercules-Zhaoziyi/vohive
#
# VoHive ARM64 长期维护版本安装程序
# ============================================================


set -Eeuo pipefail


APP_NAME="vohive"

INSTALL_DIR="/opt/vohive"

SERVICE_FILE="/etc/systemd/system/vohive.service"


REPO_RAW="https://raw.githubusercontent.com/Hercules-Zhaoziyi/vohive/main"


# 当前脚本目录
# curl | bash 模式下不存在，因此需要兼容

if [[ -n "${BASH_SOURCE:-}" && -f "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="/tmp/vohive-install"
fi


FORCE_CONFIG=0



usage() {

cat <<USAGE

用法：

sudo bash install.sh [参数]


参数：

--force-config
使用安装包中的默认配置覆盖已有 config.yaml

默认：
保留已有配置和数据。


USAGE

}



for arg in "$@"; do

case "$arg" in

    --force-config)
        FORCE_CONFIG=1
        ;;

    -h|--help)
        usage
        exit 0
        ;;

    *)
        echo "未知参数：$arg"
        usage
        exit 2
        ;;

esac

done



#
# Root检查
#

if [[ ${EUID} -ne 0 ]]; then

    echo "请使用 root 权限运行：sudo bash install.sh"

    exit 1

fi



#
# 架构检查
#

ARCH="$(dpkg --print-architecture 2>/dev/null || uname -m)"


case "$ARCH" in

arm64|aarch64)

    echo "检测到 ARM64 架构：$ARCH"

    ;;


*)

    echo "错误：VoHive 仅支持 ARM64/aarch64"

    echo "当前架构：$ARCH"

    exit 1

    ;;


esac



#
# 在线安装模式
#

prepare_online_files()
{

mkdir -p "$SCRIPT_DIR"



echo "检测安装文件..."



for f in \
bin/vohive \
config/config.yaml \
data/mcc-mnc-table.json \
systemd/vohive.service
do

    if [[ ! -f "$SCRIPT_DIR/$f" ]]; then


        echo "下载：$f"


        mkdir -p "$SCRIPT_DIR/$(dirname "$f")"



        curl -fsSL \
        "$REPO_RAW/$f" \
        -o "$SCRIPT_DIR/$f"


    fi


done


}



prepare_online_files



#
# 文件检查
#

for f in \
bin/vohive \
config/config.yaml \
data/mcc-mnc-table.json \
systemd/vohive.service

do

    if [[ ! -f "$SCRIPT_DIR/$f" ]]; then

        echo "安装文件缺失：$f"

        exit 1

    fi

done



#
# 停止旧服务
#

if systemctl is-active --quiet "$APP_NAME" 2>/dev/null; then

    echo "停止旧服务..."

    systemctl stop "$APP_NAME"

fi



#
# 备份旧安装
#

if [[ -d "$INSTALL_DIR" ]]; then


BACKUP="/root/vohive-before-install-$(date +%Y%m%d-%H%M%S).tar.gz"



tar -czf "$BACKUP" \
-C / \
opt/vohive \
2>/dev/null || true



echo "已有安装备份：$BACKUP"


fi



#
# 创建目录
#

install -d -m 755 \
"$INSTALL_DIR/bin" \
"$INSTALL_DIR/config" \
"$INSTALL_DIR/data" \
"$INSTALL_DIR/logs"



#
# 安装程序
#

install -m755 \
"$SCRIPT_DIR/bin/vohive" \
"$INSTALL_DIR/bin/vohive"



#
# 安装数据
#

install -m644 \
"$SCRIPT_DIR/data/mcc-mnc-table.json" \
"$INSTALL_DIR/data/mcc-mnc-table.json"



#
# 配置文件
#

if [[ ! -f "$INSTALL_DIR/config/config.yaml" || $FORCE_CONFIG -eq 1 ]]; then


install -m600 \
"$SCRIPT_DIR/config/config.yaml" \
"$INSTALL_DIR/config/config.yaml"


echo

echo "已安装默认配置"

echo "默认账号：admin"

echo "默认密码：admin"

echo "请首次登录后立即修改密码"


else


echo "保留现有配置："

echo "$INSTALL_DIR/config/config.yaml"


fi



#
# systemd
#

install -m644 \
"$SCRIPT_DIR/systemd/vohive.service" \
"$SERVICE_FILE"



systemctl daemon-reload


systemctl enable "$APP_NAME" >/dev/null



systemctl restart "$APP_NAME"



sleep 2



#
# 状态检查
#

if systemctl is-active --quiet "$APP_NAME"; then


echo

echo "================================"

echo " VoHive 安装成功 "

echo "================================"


echo

echo "访问地址："

echo "http://设备IP:7575"


echo

echo "状态："

echo "systemctl status vohive --no-pager -l"


echo

echo "日志："

echo "journalctl -u vohive -f"



else


echo

echo "VoHive 启动失败"

echo

journalctl -u "$APP_NAME" \
-n 80 \
--no-pager


exit 1


fi
