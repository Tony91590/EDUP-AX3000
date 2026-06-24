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

mkdir -p files/etc/uci-defaults

cat > files/etc/uci-defaults/99-default-settings << 'EOF'
#!/bin/sh

# LuCI theme (optional: does not fail if Argon is missing)
uci -q set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci

# Iterate over wireless radios in a safe way
for radio in $(uci show wireless | sed -n "s/^wireless\.\(radio[0-9]\+\)=wifi-device.*/\1/p"); do

    # Get Wi-Fi band (fallback to hwmode if band is not available)
    band="$(uci -q get wireless.$radio.band)"
    [ -z "$band" ] && band="$(uci -q get wireless.$radio.hwmode)"

    # Get first wifi-iface bound to this radio
    iface="$(uci show wireless | sed -n "s/^wireless\.\(wifinet[0-9]\+\)\.device='$radio'.*/\1/p" | head -n1)"

    # Skip if no interface found
    [ -z "$iface" ] && continue

    # Ensure radio is enabled
    uci set wireless.$radio.disabled='0'

    # Configure 2.4 GHz interfaces
    if [ "$band" = "2g" ] || echo "$band" | grep -q "11g"; then
        uci set wireless.$iface.ssid='OpenWrt_2.4G'
        uci set wireless.$iface.encryption='psk2+ccmp'
        uci set wireless.$iface.key='12345678'
        uci set wireless.$iface.disabled='0'
    fi

    # Configure 5 GHz interfaces
    if [ "$band" = "5g" ] || echo "$band" | grep -q "11a"; then
        uci set wireless.$iface.ssid='OpenWrt_5G'
        uci set wireless.$iface.encryption='psk2+ccmp'
        uci set wireless.$iface.key='12345678'
        uci set wireless.$iface.disabled='0'
    fi

done

# Commit wireless configuration changes
uci commit wireless

# Remove this uci-defaults script after first boot execution
rm -f /etc/uci-defaults/99-default-settings

exit 0
EOF

chmod +x files/etc/uci-defaults/99-default-settings
