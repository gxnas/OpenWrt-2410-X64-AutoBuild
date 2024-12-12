#!/bin/bash
#=======================================================
# Description: OpenWrt-2410-X64-AutoBuild DIY script
# File name: x64-wjq-diy-part.sh
# Lisence: MIT
# By: GXNAS
#=======================================================

echo "开始 DIY 配置……"
echo "========================="
build_date=$(TZ=Asia/Shanghai date "+%Y%m%d")

# 修改主机名字，修改你喜欢的就行（不能纯数字或者使用中文）
sed -i "/uci commit system/i\uci set system.@system[0].hostname='OpenWrt-GXNAS'" package/new/addition-trans-zh/files/zzz-default-settings
sed -i "s/hostname='.*'/hostname='OpenWrt-GXNAS'/g" package/base-files/files/bin/config_generate

# 修改默认IP
sed -i 's/192.168.1.1/192.168.18.1/g' package/base-files/files/bin/config_generate

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
sed -i '/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF./d' package/new/addition-trans-zh/files/zzz-default-settings

# 调整 x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/new/autocore

# 设置ttyd免帐号登录
# sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# 默认 shell 为 bash
# sed -i 's/\/bin\/ash/\/bin\/bash/g' package/base-files/files/etc/passwd

# samba解除root限制
sed -i 's/invalid users = root/#&/g' feeds/packages/net/samba4/files/smb.conf.template

# 修改 argon 为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/Bootstrap theme/Argon theme/g' feeds/luci/collections/*/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/*/Makefile

# 最大连接数修改为65535
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

# 修改右下角脚本版本信息
sed -i 's/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\" target=\"_blank\">Powered by <%= ver.luciname %> (<%= ver.luciversion %>)<\/a>/OpenWrt-2410-X64-主路由版 by GXNAS build @R'"$build_date"'/' package/new/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">ArgonTheme <%# vPKG_VERSION %></a>|<a class="luci-link" href="https://wp.gxnas.com" target="_blank">🌐固件编译者：【GXNAS博客】</a>|' package/new/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<%= ver.distversion %>|<a href="https://d.gxnas.com" target="_blank">👆点这里下载最新版本</a>|' package/new/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i "/<a class=\"luci-link\"/d; /<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\"/d; s|<%= ver.distversion %>|OpenWrt-2410-X64-主路由版 by GXNAS build @R$build_date|" package/new/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm

# 修改欢迎banner
cp -f $GITHUB_WORKSPACE/SCRIPTS/DIY/banner package/base-files/files/etc/banner

echo "========================="
echo " DIY 配置完成……"
