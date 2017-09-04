#!/bin/bash

####################################################################
#
#  File Name  : emmc test shell  
#  Description: test emmc on cellphone with n count
#
####################################################################
#
# please change the 
# FNAME value in following line
#

defdir="xls";

if [ "$#" -lt 1 -o "$#" -gt 2 -o "$1" = "-h" ]
then
    echo "Please input like this:"
    echo "    ./test 12345678 dir"
else
    if [ "$#" -eq 2 ]
    then
        dir=$2
    else
        dir=${defdir}
    fi
    
    if [ -d ${dir} ]; then echo "Directroy ${dir} is existed. Go on!"; else mkdir ${dir}; fi
    count=10; 

    for ((i=0; i<=count; i++)) 
    do 
    	echo "---------------------The No $i emmc  test ------------------------------------"
    	
    	echo "root phone"
    	adb -s $1 wait-for-device
    	adb -s  $1 root
    	sleep 2
        adb -s $1 shell stop
    	adb -s $1 wait-for-device
    	#adb -s $1 remount
        #adb -s $1 wait-for-device
        adb -s $1 push iozone /data/
        adb -s $1 shell chmod 777  /data/iozone
        echo "step 2: enter iozone test"
        adb -s $1 shell /data/iozone -a -n 512m -g 4g -i 0 -i 1 -i 5  -f /sdcard/ramdump.zip  -Rb /sdcard/iozone.xls
    	echo "wait 1 seconds, iozone test done"
    	sleep 1
        adb -s $1 pull /sdcard/iozone.xls  ./${dir}/iozone$i.xls
            echo "get iozone results done"
    done
fi
adb -s $1 shell start
