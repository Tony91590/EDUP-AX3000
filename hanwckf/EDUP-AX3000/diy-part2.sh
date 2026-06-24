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

  # Radio 0 (2.4 GHz)
  uci set wireless.@wifi-device[0].disabled='0'
  uci set wireless.@wifi-iface[0].disabled='0'
  uci set wireless.@wifi-iface[0].encryption='none'
  uci set wireless.@wifi-iface[0].ssid="OpenWrt_2.4G"

  # Radio 1 (5 GHz)
  uci set wireless.@wifi-device[1].disabled='0'
  uci set wireless.@wifi-iface[1].disabled='0'
  uci set wireless.@wifi-iface[1].encryption='none'
  uci set wireless.@wifi-iface[1].ssid="OpenWrt_5G"

  uci commit wireless
  
exit 0
EOF


#!/bin/sh

# Log des erreurs
exec >/tmp/setup.log 2>&1

# ===== WIFI CONFIG =====
wlan_name="ImmortalWrt"
wlan_password="12345678"

# Sécurité minimale
if [ -z "$wlan_name" ] || [ -z "$wlan_password" ]; then
  echo "WiFi parameters missing, aborting"
  exit 0
fi

# Déverrouille les radios (2.4 GHz + 5 GHz si présents)
uci set wireless.@wifi-device[0].disabled='0'
uci set wireless.@wifi-device[1].disabled='0'

# ===== 2.4 GHz =====
uci set wireless.@wifi-iface[0].disabled='0'
uci set wireless.@wifi-iface[0].ssid="$wlan_name"
uci set wireless.@wifi-iface[0].key="$wlan_password"
uci set wireless.@wifi-iface[0].encryption='psk2'

# ===== 5 GHz =====
uci set wireless.@wifi-iface[1].disabled='0'
uci set wireless.@wifi-iface[1].ssid="$wlan_name"
uci set wireless.@wifi-iface[1].key="$wlan_password"
uci set wireless.@wifi-iface[1].encryption='psk2'

# Sauvegarde configuration WiFi
uci commit wireless

# Redémarre le WiFi
wifi reload

echo "WiFi configured successfully"
exit 0

chmod +x files/etc/uci-defaults/99-default-settings
