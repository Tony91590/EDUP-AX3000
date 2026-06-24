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

# Configuration
wlan_name="OpenWrt"

# root_password=""
# lan_ip_address="192.168.1.1/24"
# pppoe_username=""
# pppoe_password=""

# Log potential errors
exec >/tmp/setup.log 2>&1

# Configure root password
if [ -n "$root_password" ]; then
  (echo "$root_password"; sleep 1; echo "$root_password") | passwd > /dev/null
fi

# Configure LAN
if [ -n "$lan_ip_address" ]; then
  uci set network.lan.ipaddr="$lan_ip_address"
  uci commit network
fi

# Configure WLAN (open network, no password)
if [ -n "$wlan_name" ]; then
  # Radio 0 (généralement 2.4 GHz)
  uci set wireless.@wifi-device[0].disabled='0'
  uci set wireless.@wifi-iface[0].disabled='0'
  uci set wireless.@wifi-iface[0].encryption='none'
  uci set wireless.@wifi-iface[0].ssid="$wlan_name"

  # Radio 1 (généralement 5 GHz)
  uci set wireless.@wifi-device[1].disabled='0'
  uci set wireless.@wifi-iface[1].disabled='0'
  uci set wireless.@wifi-iface[1].encryption='none'
  uci set wireless.@wifi-iface[1].ssid="$wlan_name"

  uci commit wireless
fi

# Configure PPPoE
if [ -n "$pppoe_username" ] && [ -n "$pppoe_password" ]; then
  uci set network.wan.proto='pppoe'
  uci set network.wan.username="$pppoe_username"
  uci set network.wan.password="$pppoe_password"
  uci commit network
fi

echo "All done!"

# Remove this uci-defaults script after first boot execution
rm -f /etc/uci-defaults/99-default-settings

exit 0
EOF

chmod +x files/etc/uci-defaults/99-default-settings
