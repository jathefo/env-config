
if [ $# -lt 2 ]
then
    #compare system image
    count=0
    while read line
    do
        count=$[$count+1]
        if [ "${line:0:17}" = "apply_patch_check" ]
        then
            OLD_IFS="$IFS"
            IFS='"'
            strarray=($line)
            IFS="$OLD_IFS"
            file_path=${strarray[1]}
            sha1sum_build=${strarray[3]}
        else
            continue
        fi
        sha1sum_dev=`sha1sum $file_path | awk '{print $1}'`
        if [ "$sha1sum_dev" != "$sha1sum_build" ]
        then
            echo "Fail checking sha1sum of $file_path"
            echo "    sha1sum of build is $sha1sum_build"
            echo "    sha1sum of device is $sha1sum_dev"
        else
            if [ $[$count%100] -eq 0 ]
            then
                echo "Sha1sum is OK of $count files."
            fi
        fi
    done < $1
else
    value_md5=`md5sum $1 | awk '{print $1}'`
    value_md5_dev=`md5sum $2 | awk '{print $1}'`
   
    if [ $value_md5 != $value_md5_dev ];
    then
        echo "Fail to check $1 and $2!!!"
    else
        echo "Success to check of $1 and $2."
    fi
fi
