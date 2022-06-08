#!/bin/bash
js="./js/pay.js" #支付工作js
pay_plan="./log/pay_plan.log"
pay_log="./log/pay.log"
echo "------------------------------------------------------------"

while true
do  
    #检查./log/pay.log文件是否存在
    while true 
    do
    if [ -f "$pay_log" ];then
        break
    else
        echo -e "`date +"%Y-%m-%d %H:%M:%S"`  No files were uploaded. wait 30 seconds "
        sleep 30
    fi
    done

    echo -e "`date +"%Y-%m-%d %H:%M:%S"`  Start querying unpaid files....."

    #检查是否有未支付的订单
    while true 
    do
        grep source_file_upload_id $pay_log|grep -v payok >$pay_plan
        num=`cat $pay_plan|wc -l`
        if [ $num -eq 0 ]
        then
            sleep 30
        else
            break
        fi
    done
    
    echo -e "`date +"%Y-%m-%d %H:%M:%S"`  Successfully found unpaid files. Start pay  Quantity: $num"

    #支付主体
    n=1
    while read line
    do
        w_cid=`grep -A 4 "$line" $pay_log |tail -1|tr -d ",|'"|awk '{print $NF}'`
        echo -ne "`date +"%Y-%m-%d %H:%M:%S"`  File \033[34m$n\033[0m    $line  status:  "
        sed -i 14c"\ \ const W_CID = '$w_cid'" $js
        #如果支付成功,则在./log/pay.log对应source_file_upload_id行末尾加上payok
        /usr/local/bin/node $js > ./log/pay_status.log 2>&1
        if [ `grep -E "transactionHash|pay_statue: true" ./log/pay_status.log|wc -l` -gt 0 ] ;then
            echo -e "\033[34mSUCCESS\033[0m"
            sed -i "/$line/{s/$/ payok/}" $pay_log
        else
            echo -e "\033[31mFAILED\033[0m"
        fi
        n=$(( $n + 1 ))
    done<$pay_plan
    echo -e "`date +"%Y-%m-%d %H:%M:%S"`  Payment completed, Query again after waiting for 3 seconds"
    echo "------------------------------------------------------------"
    sleep 3


done

