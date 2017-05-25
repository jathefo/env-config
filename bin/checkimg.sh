#!/bin/bash

dev_serial=`adb devices | sed -n 2p | awk '{print $1}'`
workspace="/data/cmpimg/"

#echo "---------- Generate system image ----------"
#packsparseimg -x rawprogram_unsparse4.xml -t system -o .
#img2simg system.raw system.img
unzip -n sha1-ota.zip META-INF/com/google/android/updater-script -d .

echo
echo "***** 1. package image *****"
tz_size=`ls -la tz.mbn | awk '{print $5}'`
zip tz.mbn.zip tz.mbn
rpm_size=`ls -la rpm.mbn | awk '{print $5}'`
zip rpm.mbn.zip rpm.mbn
aboot_size=`ls -la emmc_appsboot.mbn | awk '{print $5}'`
zip emmc_appsboot.mbn.zip emmc_appsboot.mbn
boot_size=`ls -la boot.img | awk '{print $5}'`
zip boot.img.zip boot.img
#system_size=`ls -la system.img | awk '{print $5}'`
#zip system.img.zip system.img

echo "root phone"
adb -s $dev_serial wait-for-device
adb -s  $dev_serial root
sleep 2
adb shell "mkdir -p $workspace"

echo
echo "***** 2. push image file *****"
adb push tz.mbn.zip $workspace
adb push rpm.mbn.zip $workspace
adb push emmc_appsboot.mbn.zip $workspace
adb push boot.img.zip $workspace
#adb push system.img.zip $workspace
adb push META-INF/com/google/android/updater-script $workspace

echo
echo "***** 3. decompression image in phone *****"
adb shell "unzip -n $workspace/tz.mbn.zip -d $workspace"
adb shell "unzip -n $workspace/rpm.mbn.zip -d $workspace"
adb shell "unzip -n $workspace/emmc_appsboot.mbn.zip -d $workspace"
adb shell "unzip -n $workspace/boot.img.zip -d $workspace"
#adb shell "unzip -n $workspace/system.img.zip -d $workspace"
adb shell "unzip -n $workspace/sha1-ota.zip META-INF/com/google/android/updater-script -d $workspace"

adb -s $dev_serial wait-for-device

echo
echo "***** 4. dd device partition *****"
pathname="/dev/block/bootdevice/by-name/"
partition="tz"
adb shell "dd if=$pathname/$partition of=$workspace/tz.mbn.dev count=1 bs=$tz_size"
adb shell "dd if=/dev/block/bootdevice/by-name/rpm of=$workspace/rpm.mbn.dev count=1 bs=$rpm_size"
adb shell "dd if=/dev/block/bootdevice/by-name/aboot of=$workspace/emmc_appsboot.mbn.dev count=1 bs=$aboot_size"
adb shell "dd if=/dev/block/bootdevice/by-name/boot of=$workspace/boot.img.dev count=1 bs=$boot_size"
#adb shell "dd if=/dev/block/bootdevice/by-name/system of=$workspace/system.img.dev count=512 bs=$system_size"

adb remount
sleep 1 
adb push ~/bin/knife/comp.sh /system/bin/
adb push ~/bin/knife/compsys.sh /system/bin/
adb shell "chmod 777 /system/bin/comp.sh"

echo
echo "***** 5. compare file *****"
adb shell "bash comp.sh $workspace/tz.mbn $workspace/tz.mbn.dev"
adb shell "bash comp.sh $workspace/rpm.mbn $workspace/rpm.mbn.dev"
adb shell "bash comp.sh $workspace/emmc_appsboot.mbn $workspace/emmc_appsboot.mbn.dev"
adb shell "bash comp.sh $workspace/boot.img $workspace/boot.img.dev"
#adb shell "bash comp.sh $workspace/system.img $workspace/system.img.dev"
adb shell "bash comp.sh $workspace/updater-script"

echo "----------- Catching end!!! ----------"
