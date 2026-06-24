#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# Custom for EDUP-AX3000 112m
#

# ===== Argon Theme =====

rm -rf package/luci-theme-argon
rm -rf package/luci-app-argon-config

git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# Définir Argon comme thème par défaut
mkdir -p files/etc/uci-defaults

cat > files/etc/uci-defaults/99-default-settings << 'EOF'
#!/bin/sh

# LuCI
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci

# Automatically configure Wi-Fi by band to avoid the radio0/radio1 order being reversed
for radio in $(uci show wireless | grep "=wifi-device" | cut -d. -f2 | cut -d= -f1); do
    band="$(uci -q get wireless.$radio.band)"

    # Find the first wifi-iface corresponding to this radio
    iface="$(uci show wireless | grep ".device='$radio'" | head -n1 | cut -d. -f2 | cut -d= -f1)"

    [ -z "$iface" ] && continue

    # 2.4G
    if [ "$band" = "2g" ]; then
        uci set wireless.$iface.ssid='OpenWrt_2.4G'
        uci set wireless.$iface.encryption='psk2'
        uci set wireless.$iface.key='12345678'
        uci set wireless.$iface.disabled='0'
        uci set wireless.$radio.disabled='0'
    fi

    # 5G
    if [ "$band" = "5g" ]; then
        uci set wireless.$iface.ssid='OpenWrt_5G'
        uci set wireless.$iface.encryption='psk2'
        uci set wireless.$iface.key='12345678'
        uci set wireless.$iface.disabled='0'
        uci set wireless.$radio.disabled='0'
    fi
done

uci commit wireless

rm -f /etc/uci-defaults/99-default-settings

exit 0
EOF

chmod +x files/etc/uci-defaults/99-default-settings
