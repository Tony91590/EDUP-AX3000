#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
# 
# Custom for EDUP-AX3000 112m
sed -i '/\["FR"\]/s/{ 1, 2 }/{ 1, 1 }/' package/mtk/applications/mtwifi-cfg/files/mtwifi-cfg/mtwifi_defs.lua
grep -R '\["FR"\]' package/mtk/applications/mtwifi-cfg/files/mtwifi-cfg/mtwifi_defs.lua

cp feeds.conf.default feeds.conf.default.bak

cat > feeds.conf.default << 'EOF'
src-git packages https://git.openwrt.org/feed/packages.git
src-git luci https://git.openwrt.org/project/luci.git
src-git routing https://git.openwrt.org/feed/routing.git
src-git telephony https://git.openwrt.org/feed/telephony.git

# Custom feed
# src-git custom https://github.com/TON_USER/ton-feed.git
EOF
