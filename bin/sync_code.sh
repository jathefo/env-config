#!/bin/sh

#---------- u3 rom code ----------
#cd /media/yemingzhu/842445ef-bf43-40f5-b38e-b6122554eb5e/smartisan/code/u3/1.2/rom
#echo "`date +%Y-%m-%d-%H:%M:%S` Start to sync u3 rom code..."
#repo sync -cdj2
#echo "`date +%Y-%m-%d-%H:%M:%S` End of syncing u3 rom code."
#---------- u3 oem code ----------
#cd /media/yemingzhu/842445ef-bf43-40f5-b38e-b6122554eb5e/smartisan/code/u3/1.2/oem
#echo "`date +%Y-%m-%d-%H:%M:%S` Start to sync u3 oem code..."
#repo sync -cdj2
#echo "`date +%Y-%m-%d-%H:%M:%S` End of syncing u3 oem code."
##---------- u3 smadroid code ----------
#cd /media/yemingzhu/842445ef-bf43-40f5-b38e-b6122554eb5e/smartisan/code/u3/1.2/smandroid
#echo "`date +%Y-%m-%d-%H:%M:%S` Start to sync u3 samndroid code..."
#repo sync -cdj2
#echo "`date +%Y-%m-%d-%H:%M:%S` End of syncing u3 smandroid code."

cd /media/yemingzhu/842445ef-bf43-40f5-b38e-b6122554eb5e/smartisan/code/u3/1.2/rom
echo "`date +%Y-%m-%d-%H:%M:%S` Start to sync u3 rom code..."
repo sync -cdj2
echo "`date +%Y-%m-%d-%H:%M:%S` End of syncing u3 rom code."


#---------- t3 rom code ----------
cd /home/yemingzhu/smartisan/code/t3/rom-r01253
echo "`date +%Y-%m-%d-%H:%M:%S` Start to sync t3 rom code..."
repo sync -cdj2
echo "`date +%Y-%m-%d-%H:%M:%S` End of syncing t3 rom code."

#---------- t3 oem code ----------
cd /home/yemingzhu/smartisan/code/t3/oem-r01253
echo "`date +%Y-%m-%d-%H:%M:%S` Start to sync t3 oem code..."
repo sync -cdj2
echo "`date +%Y-%m-%d-%H:%M:%S` End of syncing t3 oem code."

