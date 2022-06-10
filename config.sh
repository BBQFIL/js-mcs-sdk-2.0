#!/bin/bash
env="./file/.env"
mint="./js/mint.js"
pay="./js/pay.js"
paymint="./js/paymint.js"
upload="./js/upload.js"
log="./log/"

#输入PRIVATE_KEY和RPC_URL


echo "PRIVATE_KEY=<PRIVATE_KEY>" > $env    #使用你的metamask钱包私钥替换<PRIVATE_KEY>
echo "RPC_URL=<RPC_URL>" >> $env           #使用注册的Polygon Mumbai Testnet RPC替换<RPC_URL>

#清空历史记录  ------慎用
for i in `ls $log` ;do > $log$i ; done

#清空残留痕迹

sed -i "/.*const W_CID*/c\\ \ const W_CID = ''" $paymint
sed -i "/.*const SOURCE_FILE_UPLOAD_ID*/c\\ \ const SOURCE_FILE_UPLOAD_ID = " $paymint
sed -i "/.*const IPFS_URL*/c\\ \ const IPFS_URL = ''" $paymint

sed -i "/.*const W_CID*/c\\ \ const W_CID = ''" $pay

sed -i "/.*const SOURCE_FILE_UPLOAD_ID*/c\\ \ const SOURCE_FILE_UPLOAD_ID = " $mint
sed -i "/.*const IPFS_URL*/c\\ \ const IPFS_URL = ''" $mint

sed -i "/.*const FILE_NAME =*/c\\ \ const FILE_NAME = ''" $upload


