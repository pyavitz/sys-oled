# Description
Application to display System Status on I2C OLED display.
This fork hopes to add out-of-the-box support for the OLED display.

![system status](capture/luma_000001.png)

* All the credit to [kobol-io/sys-oled](https://github.com/kobol-io/sys-oled)
## INSTALLATION

```
git clone https://github.com/pyavitz/sys-oled.git
cd sys-oled
sudo ./install.sh
```
### Configure storage info

By default **sys-oled** will display usage info of your micro SDcard which is most probably your Root File System. You can display storage usage info of one more storage device by editing */etc/sys-oled.conf*

```
sudo nano /etc/sys-oled.conf
```

You can edit the following lines to define for which storage devices you want to display usage info.

```
# Storage Device 1
# Device name
storage1_name = mmcblk

# Device mount path
storage1_path = /

# Storage Device 2
storage2_name= md0
storage2_path= /mnt/md0

```

In the above example, we are displaying **sd** (SDcard) usage which is the rootfs mounted on *'/'*. We are also displaying **md0** (RAID array) that is mounted on *'/mnt/mnd0'*.
