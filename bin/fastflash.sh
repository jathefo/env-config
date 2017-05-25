#!/bin/sh
#adb reboot bootloader       -- input fastboot mode
#
#sudo fastboot flash modem NON-HLOS.bin or path to APQ.bin
#sudo fastboot flash sbl1 sbl1.mbn
#sudo fastboot flash rpm rpm.mbn
#sudo fastboot flash tz tz.mbn
#sudo fastboot flash xbl xbl.elf
fastboot flash aboot emmc_appsboot.mbn
fastboot flash boot boot.img
fastboot flash system system.img
fastboot flash userdata userdata.img
fastboot flash persist persist.img
fastboot flash recovery recovery.img

fastboot reboot        # reboot to android
