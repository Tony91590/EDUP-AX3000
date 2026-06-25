#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
# 
# Custom for EDUP-AX3000 112m

sed -i 's/model = "CLT R30B1"/model = "EP-2980"/g' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-clt-r30b1-base.dtsi
sed -i 's/default-settings-chn/default-settings/g' include/target.mk
sed -i '/\["FR"\]/s/{ 1, 2 }/{ 1, 1 }/' package/mtk/applications/mtwifi-cfg/files/mtwifi-cfg/mtwifi_defs.lua
grep -R '\["FR"\]' package/mtk/applications/mtwifi-cfg/files/mtwifi-cfg/mtwifi_defs.lua
grep -R 'model = "EP-2980"' -n target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-clt-r30b1-base.dtsi
