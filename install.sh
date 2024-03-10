#!/bin/bash
# Install script for sys-oled

# style
BLD="\033[1m"
ITL="\033[3m"
FIN="\033[0m"
EE="echo -e"
EN="echo -en"

# paths
INSTALL_PATH="/usr/local/"
SYSTEMD_PATH="/etc/systemd/"
BUILD_DEPS="python3-dev python3-pip python3-setuptools python3-wheel python3-psutil libfreetype6-dev libjpeg-dev build-essential"
RUNTIME_DEPS="python3 python3-psutil python3-luma.oled python3-rpi.gpio"

if [ "$USER" != "root" ]; then
        echo "Please run this as root or with sudo privileges."
        exit 1
fi

$EE ""
if [[ `ls /dev/i2c-[0-9]` ]] > /dev/null 2>&1; then
	$EE "${BLD}${ITL}AVAILABLE I2C${FIN}"
	ls /dev/i2c-[0-9]
else
	$EE ""
	$EE "There are no available I2C to use."
	exit 0
fi

$EE ""
$EE "${BLD}${ITL}From the list of I2C above, write in the number:${FIN}"
$EN "/dev/i2c-"
read NUM
I2C_NUM="/dev/i2c-${NUM}"
if [[ -e "$I2C_NUM" ]]; then
	:;
else
	$EE
	$EE "${BLD}WARNING:${FIN} The I2C you selected is not available or invalid."
	exit 0
fi

$EE ""
$EE "Installing Dependencies ..."
apt-get update

if [[ "$(lsb_release -cs)" == "jammy" || "$(lsb_release -cs)" == "kinetic"  || "$(lsb_release -cs)" == "lunar"  || "$(lsb_release -cs)" == "bookworm"  || "$(lsb_release -cs)" == "trixie" || "$(lsb_release -cs)" == "sid" ]]; then
	echo "$(lsb_release -cs); use Ubuntu-packaged Python deps."
	apt-get install -y ${RUNTIME_DEPS}
else
	echo "Not jammy, installing build deps, then using pip for python stuff. This is gonna take a while."
	apt-get install -y $BUILD_DEPS
	# luma.oled depends on this thing, but released non-alpha version does not build under gcc10
	$EE "Installing GPIO library dependency in pip..."
	pip3 install RPi.GPIO==0.7.1a4

	$EE "Installing luma.oled library"
	pip3 install --upgrade luma.oled
fi

$EE "Installing sys-oled files ..."
mkdir -p /etc/default
cp -fv etc/default/sys-oled /etc/default/
cp -frv bin "$INSTALL_PATH"
cp -frv share "$INSTALL_PATH"
cp -frv system "$SYSTEMD_PATH"
if [[ -f "${SYSTEMD_PATH}/system/sys-oled.service" ]]; then
	sed -i "s/--i2c-port 0/--i2c-port $NUM/g" ${SYSTEMD_PATH}/system/sys-oled.service
fi

$EE "Enabling sys-oled ..."
systemctl daemon-reload
systemctl enable sys-oled.service

$EE "Starting service ..."
systemctl start sys-oled.service

$EE "Done."

exit 0
