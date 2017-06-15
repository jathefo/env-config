#adb root
#adb shell "cat /sys/class/power_supply/battery/capacity"
#adb remount
#adb shell 'echo "BIMC cur_freq: " $(< /d/clk/bimc_clk/measure)'
#adb push  bimc_clock.sh /data/
#
#adb root
#adb shell sh /data/bimc_clock.sh -s 844800 
#
#echo
#echo
#echo

adb push QMESA_64 /data/local/tmp/
adb shell "chmod 777 /data/local/tmp/QMESA_64"
adb shell "/data/local/tmp/QMESA_64  -startSize 2M -endSize 32M -totalsize 256M -errorCheck T -numThreads 6 -secs 86400 2>&1"

echo
echo
echo 

adb push memtester /data/local/tmp/
adb shell "chmod 777 /data/local/tmp/memtester"
adb shell "/data/local/tmp/memtester 2048M 20 2>&1"
