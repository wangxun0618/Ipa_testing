#!/bin/bash

echo "Content-Type: text/plain"
echo ""

# 获取默认网络接口
IFACE=$(route get default | awk '/interface:/{print $2}')

# 获取当前 IP
HOST=$(ipconfig getifaddr "$IFACE" 2>/dev/null)

if [ -z "$HOST" ]; then
    HOST="127.0.0.1"
fi

PLIST="/Library/WebServer/Documents/app.plist"

if [ ! -f "$PLIST" ]; then
    echo "plist 文件不存在: $PLIST"
    exit 1
fi

/usr/libexec/PlistBuddy \
-c "Set :items:0:assets:0:url http://$HOST/ipa/XiaoMoZB.ipa" \
"$PLIST"

if [ $? -ne 0 ]; then
    echo "更新 plist 失败"
    exit 1
fi

echo "当前IP: $HOST"

echo "plist 已更新"

echo "OTA 安装链接:"

echo "itms-services://?action=download-manifest&url=http://$HOST/app.plist"
