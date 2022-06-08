#!/bin/bash
num=`grep "createReadStream" ./js/upload.js |wc -l`  #批量上传个数
js="./js/upload.js" #工作js

while true
do
    echo "------------------------------------------------------------"
    time1=`date +%s`
    sed -i 12c"\ \ const FILE_NAME = '$time1'" js/upload.js    #替换上传文件名
    echo -e "`date +"%Y-%m-%d %H:%M:%S"`  \033[34m开始上传\033[0m    文件数: $num"

    #上传
    /usr/local/bin/node $js >./log/upload_tmp.log
    cat ./log/upload_tmp.log |tee -a ./log/pay.log ./log/mint.log

    if [ `grep success ./log/upload_tmp.log|wc -l` = "$num" ];then
        time2=`date +%s`
        seconds=$(($time2 - $time1))
        hour=$(( $seconds/3600 ))
        min=$(( ($seconds-${hour}*3600)/60 ))
        sec=$(( $seconds-${hour}*3600-${min}*60 ))
        HMS=`echo ${hour}.${min}.${sec}`



        echo -e "`date +"%Y-%m-%d %H:%M:%S"`  \033[34m上传完毕\033[0m    成功数：`grep success ./log/upload_tmp.log|wc -l` 耗时：$HMS 日志：./log/pay.log " 
        echo -e "`date +"%Y-%m-%d %H:%M:%S"`  \033[34m等待 3秒\033[0m    "
        sleep 3
    else
        echo -e "`date +"%Y-%m-%d %H:%M:%S"`  \033[31m上传失败\033[0m    成功数：`grep success ./log/upload_tmp.log|wc -l` 等待30秒开始下一轮上传"
        sleep 30
    fi

done

