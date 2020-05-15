Prevent disconnection of usb devices.
[Documentation](https://ubuntuforums.org/showthread.php?t=2159645&page=6&p=12926730#post12926730)

/etc/rc.local:

```
# Prevents the Bluetooth USB card from getting reset which disconnects the mouse
BTUSB_DEV="0a5c:21e8"
BTUSB_BINDING="$(lsusb -d "$BTUSB_DEV" |
    cut -f 1 -d : |
    sed -e 's,Bus ,,' -e 's, Device ,/,' |
    xargs -I {} udevadm info -q path -n /dev/bus/usb/{} |
    xargs basename)"


echo "Disabling autosuspend for Bluetooth USB Soundcard: $BTUSB_BINDING..."
echo -1 > "/sys/bus/usb/devices/$BTUSB_BINDING/power/autosuspend_delay_ms"
```
