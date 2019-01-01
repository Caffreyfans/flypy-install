#!/bin/bash
set -e
clear
echo "**********************************************"
echo "欢迎使用 Linux-Rime 输入法 Fcitx-Rime 引导程序"
echo "向导:"
echo "请在有网络情况下开始，否则请立即按 Ctrl+c 停止！"
echo "安装分为3步："
echo "1. 卸载旧版 Fcitx 程序"
echo "2. 安装 Fcitx 程序" 
echo "3. 部署音形方案文件"
echo "           power by Qshu and Caffreyfans"
echo "**********************************************"
echo -e "\n"
read -p "请按任意键以继续，(n/N)停止…………:" choice
if [[ $choice = "n" ]]||[[ $choice = "N" ]]; then
    echo "脚本已停止"
    exit 1
fi
DISTRO="安装开始"

# 检测包管理工具
if [ -n `which apt` ]; then
	PM="apt"
elif [ -n `which yum` ]; then
	PM="yum"
elif [ -n `which pacman` ]; then
	PM="pacman"
else
	DISTRO="暂不支持当前系统"
	exit -1
fi

clear
echo "${DISTRO}"
echo "请输入 sudo 密码: "
# 卸载安装 Fcitx
case $PM in
"apt"|"yum")
	sudo $PM update -y
	sudo $PM remove fcitx* ibus -y
	sudo $PM install fcitx fcitx-rime fcitx-ui-classic fcitx-config-gtk grep sed wget -y
	;;
"pacman")
	sudo $PM -Syu
	sudo $PM -Rs fcitx* ibus -y
	sudo $PM -S fcitx fcitx-rime fcitx-ui-classic fcitx-config-gtk grep sed wget -y
	;;
esac
rime=~/.config/fcitx/rime
# rm -rf `ls ${rime}/ | grep -v "^default.yaml$"`
cp ${rime}/default.yaml ${rime}/default.yaml.bak
sed -i -e "/schema:/d" ${rime}/default.yaml
ROW=`cat ${rime}/default.yaml | grep schema_list: -n | awk -F: '{print $1}'`
sed -i "${ROW}a\ \ - schema: flypy" ${rime}/default.yaml
sed -i "${ROW}a\ \ - schema: flypyplus" ${rime}/default.yaml
wget -O ~/flypy.zip https://github.com/Caffreyfans/flypy-install/releases/download/latest/rime.zip
unzip -o ~/flypy.zip
cp -r ~/rime/* ${rime}/
fcitx-remote -r
rm -r ~/flypy.zip ~/rime
echo "**********************************************"
echo "恭喜小鹤音形方案已部署完成请选择 Rime 输入法进行使用"
echo "Rime 输入法下使用 Crtl+\` 进行方案选择"
echo "祝你用的愉快"
echo "**********************************************"
exit 0
