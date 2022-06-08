#!/bin/bash
js="./js/paymint.js" #支付工作js
mintjs="./js/mint.js"
pay_log="./log/pay.log"
mint_log="./log/mint.log"
paymint_plan="./log/paymint_plan.log"
echo "------------------------------------------------------------"


while true
do
    #检查./log/pay.log文件是否存在
    while true 
    do
    if [ -f "$pay_log" ];then
        :
    else
        echo -e "`date +"%Y-%m-%d %H:%M:%S"`  $pay_log  not found. wait 30 seconds "
        sleep 10
    fi
    

    if [ -f "$mint_log" ];then
        break
    else
        echo -e "`date +"%Y-%m-%d %H:%M:%S"`  $mint_log  not found. wait 30 seconds "
        sleep 10
    fi
    done

    echo -e "`date +"%Y-%m-%d %H:%M:%S"`  Start querying unpaymint files....."

    #检查是否有未支付的订单
    while true 
    do
        grep source_file_upload_id $pay_log $mint_log |grep -vE "payok| mintok"|awk '{print $2,$3}'|sort -n -k2| uniq >$paymint_plan
        num=`cat $paymint_plan|wc -l`
        if [ $num -eq 0 ]
        then
            sleep 10
        else
            break
        fi
    done

    echo -e "`date +"%Y-%m-%d %H:%M:%S"`  Successfully found unpaid files. Start paymint  Quantity: $num"

    #支付主体
    n=1
    while read line
    do
        w_cid=`grep -A 4 "$line" $mint_log |tail -1|tr -d ",|'"|awk '{print $NF}'`
        source_file_upload_id=`echo $line|awk '{print $2}'|tr -d ","`
        ipfs_url=`grep -A 2 "$line" $mint_log |tail -1|tr -d ",|'"|awk '{print $NF}'`

        echo -ne "`date +"%Y-%m-%d %H:%M:%S"`  File \033[34m$n\033[0m    $line  status:  "
        sed -i 14c"\ \ const W_CID = '$w_cid'" $js
        sed -i 21c"\ \ const SOURCE_FILE_UPLOAD_ID = $source_file_upload_id" $js
        sed -i 22c"\ \ const IPFS_URL = '$ipfs_url'" $js

        #如果支付成功,则在./log/pay.log对应source_file_upload_id行末尾加上payok
        /usr/local/bin/node $js > ./log/paymint_status.log 2>&1
        if [ `grep -E "transactionHash|pay_statue: true" ./log/paymint_status.log|wc -l` -gt 0 ] ;then
            echo -ne "\033[34mpayOK\033[0m"
            sed -i "/$line/{s/$/ payok/}" $pay_log
        else
            echo -ne "\033[31mpayFAILED\033[0m"
            exit
        fi
        if [ `grep  "transactionHash" ./log/paymint_status.log|wc -l` -gt 0 ] ;then
            sed -i 21c"\ \ const SOURCE_FILE_UPLOAD_ID = $source_file_upload_id" $mintjs
            sed -i 22c"\ \ const IPFS_URL = '$ipfs_url'" $mintjs            
            /usr/local/bin/node $mintjs >> ./log/paymint_status.log 2>&1
        else
            :
        fi

        if [ "`tail -n1 ./log/paymint_status.log`" = "Promise { <pending> }" ] ;then
            echo -e "\033[34m mintOK\033[0m"
            sed -i "/$line/{s/$/ mintok/}" $mint_log
        else
            echo -e "\033[31m mintFAILED\033[0m"
            exit
        fi

        n=$(( $n + 1 ))
    done<$paymint_plan
    echo -e "`date +"%Y-%m-%d %H:%M:%S"`  PayMint completed, Query again after waiting for 3 seconds"
    echo "------------------------------------------------------------"
    sleep 3


done

