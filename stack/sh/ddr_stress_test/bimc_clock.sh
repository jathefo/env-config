#!/system/bin/sh

STARTTIME=$(date +%s)

bimc_freq_switch() {
  ## don't turn off thermal-engine, otherwise thermal reset will be triggered easily. #stop thermal-engine
  for REQ_KHZ in ${FREQ_LIST}; do
    echo 1 > /d/msm-bus-dbg/shell-client/mas
    echo 512 > /d/msm-bus-dbg/shell-client/slv
    echo "active clk2 0 1 max ${REQ_KHZ}" > /d/rpm_send_msg/message

    ## if clearing vote, set max to 0 otherwise vote for a extra large freq value
    if [ "${REQ_KHZ}" = "0" ]; then
      echo "clearing override votes"
      echo 0 > /d/msm-bus-dbg/shell-client/ib
    else
      echo "BIMC req_freq: ${REQ_KHZ}"
      # echo 7200000000 > /d/msm-bus-dbg/shell-client/ib
      # echo $((8000*900000)) > /d/msm-bus-dbg/shell-client/ib
      echo $((7200000000)) > /d/msm-bus-dbg/shell-client/ib
    fi

    echo 1 > /d/msm-bus-dbg/shell-client/update_request

    echo "BIMC cur_freq: " $(< /d/clk/bimc_clk/measure)
    sleep $interval
  done
}

loop_bimc_freq_switch() {
  while [ 1 ] ; do
    bimc_freq_switch
  done
}

random_bimc_freq_switch() {
   # Seed random generator
   RANDOM=$$$(date +%s)
   # randomly select the frequency from the list
   FREQ_LIST=${bimc_scaling_freq_list[$RANDOM % ${#bimc_scaling_freq_list[@]}]}
   bimc_freq_switch
}

loop_random_bimc_freq_switch() {
  while [ 1 ] ; do
    random_bimc_freq_switch
  done
}


## entry ###

## get the interval
opt=$1
if [ "$opt" = "-i" ]; then
  shift
  interval=$1
  shift
  opt=$1
  echo "switching interval set to $interval"
else
  interval=3
  echo "switching interval set to default 3 sec"
fi

## opt: -d  : display the scaling frequency list
if [ "$opt" = "-d" ]; then
  echo "bimc cur_freq: " $(< /d/clk/bimc_clk/measure)
  exit
fi

shift

bimc_scaling_freq_string=$@
shift
bimc_scaling_freq_list=(${bimc_scaling_freq_string// / })

if [ "$opt" = "-h" ]; then
  echo "sh <path>/bimc_clock.sh [-h] [-i <interval>] [-unlock] [-d] [-r] [-o] [-s] <freq_list> "
  exit
fi

## some targets require an enable message to be send before starting clock switching
if [ -f /d/rpm_send_msg/enable ]; then
  echo 3735928559  > /d/rpm_send_msg/enable
  echo 0 > /d/msm-bus-dbg/shell-client/update_request
  echo "enabled rpm messages"
fi

## random - randomly loop and pick freq from  scaling_available_frequencies
if [ "$opt" = "-r" ]; then
  loop_random_bimc_freq_switch

## ordered - loop in order through frequency list
elif [ "$opt" = "-o" ]; then
  FREQ_LIST=$bimc_scaling_freq_string
  loop_bimc_freq_switch

## set - switch to a specific frequency (or through frequency list)
elif [ "$opt" = "-s" ]; then
  FREQ_LIST=${bimc_scaling_freq_list[0]}
  bimc_freq_switch
  exit
fi

echo "Bad Argument"
echo "sh <path>/bimc_clock.sh [-h] [-i <interval>] [-unlock] [-d] [-r] [-o] [-s] <freq_list> "
exit
