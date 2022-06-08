#!/bin/bash
js="./js/mint.js" #mint工作js
mint_plan="./log/mint_plan.log"
mint_log="./log/mint.log"
echo "------------------------------------------------------------"


while true
do  
    #检查./log/mint.log文件是否存在
    while true 
    do
    if [ -f "$mint_log" ];then
        break
    else
        echo -e "`date +"%Y-%m-%d %H:%M:%S"`  No files were uploaded. wait 30 seconds "
        sleep 30
    fi
    done

    echo -e "`date +"%Y-%m-%d %H:%M:%S"`  Start querying unmint files....."

    #检查是否有未mint的订单
    while true 
    do
        grep source_file_upload_id $mint_log|grep -v mintok >$mint_plan
        num=`cat $mint_plan|wc -l`
        if [ $num -eq 0 ]
        then
            sleep 30
        else
            break
        fi
    done
    
    echo -e "`date +"%Y-%m-%d %H:%M:%S"`  Successfully found unmint files. Start mint  Quantity: $num"

    #mint主体
    n=1
    while read line
    do
        w_cid=`grep -A 4 "$line" $mint_log |tail -1|tr -d ",|'"|awk '{print $NF}'`
        source_file_upload_id=`echo $line|awk '{print $2}'|tr -d ","`
        ipfs_url=`grep -A 2 "$line" $mint_log |tail -1|tr -d ",|'"|awk '{print $NF}'`
        echo -ne "`date +"%Y-%m-%d %H:%M:%S"`  File \033[34m$n\033[0m    $line  status:  "
        sed -i 21c"\ \ const SOURCE_FILE_UPLOAD_ID = $source_file_upload_id" $js
        sed -i 22c"\ \ const IPFS_URL = '$ipfs_url'" $js
        #如果mint成功,则在./log/mint.log对应source_file_upload_id行末尾加上mintok
        /usr/local/bin/node $js > ./log/mint_status.log 2>&1
        if [ `cat ./log/mint_status.log|wc -l` -eq 1 ] ;then
            echo -e "\033[34mSUCCESS\033[0m"
            sed -i "/$line/{s/$/ mintok/}" $mint_log
        else
            echo -e "\033[31mFAILED\033[0m"
        fi
        n=$(( $n + 1 ))
    done<$mint_plan
    echo -e "`date +"%Y-%m-%d %H:%M:%S"`  mint completed, Query again after waiting for 3 seconds"
    echo "------------------------------------------------------------"
    sleep 3


done

