#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# Custom for EDUP-AX3000 112m
#

sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate
sed -i 's/pool.ntp.org/3.openwrt.pool.ntp.org/g' package/base-files/files/bin/config_generate
sed -i 's/time1.apple.com/0.openwrt.pool.ntp.org/g' package/base-files/files/bin/config_generate
sed -i 's/time1.google.com/1.openwrt.pool.ntp.org/g' package/base-files/files/bin/config_generate
sed -i 's/time.cloudflare.com/2.openwrt.pool.ntp.org/g' package/base-files/files/bin/config_generate

sed -i 's/default-settings-chn/default-settings/g' include/target.mk

sed -i 's/ImmortalWrt/OpenWrt/g' include/version.mk
sed -i 's,https://immortalwrt.org/,https://openwrt.org/,g' include/version.mk
sed -i 's,https://github.com/immortalwrt/immortalwrt/issues,https://bugs.openwrt.org/,g' include/version.mk
sed -i 's,https://github.com/immortalwrt/immortalwrt/discussions,https://forum.openwrt.org/,g' include/version.mk
sed -i 's,https://downloads.immortalwrt.org/releases/21.02-SNAPSHOT,https://downloads.openwrt.org/releases/21.02-SNAPSHOT,g' include/version.mk

cat > package/base-files/files/etc/banner << 'EOF'
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 %D %V, %C
 -----------------------------------------------------
EOF

# ===== Argon Theme =====

rm -rf package/luci-theme-argon
rm -rf package/luci-app-argon-config

git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# Définir Argon comme thème par défaut
mkdir -p files/etc/uci-defaults

cat > files/etc/uci-defaults/99-argon << 'EOF'
#!/bin/sh
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci
exit 0
EOF

chmod +x files/etc/uci-defaults/99-argon
