#!/bin/bash
  token1="0x9EBd24bE4f1F4dA3c4389bB8B67a6F69448d6B93"
  token2="0x2c2Cabf9DCbFa824a9199A28e84ec2B9E7fB28D1"
  token3="0xc40Bfa0254eC6EA081CD48919BFE688f5661e5fa"
matic(){
  for i in {$token1,$token2,$token3}
  do
  curl 'https://api.faucet.matic.network/transferTokens'   -H 'authority: api.faucet.matic.network'   -H 'accept: application/json, text/plain, */*'   -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36'   -H 'content-type: application/json;charset=UTF-8'   -H 'origin: https://faucet.polygon.technology'   -H 'sec-fetch-site: cross-site'   -H 'sec-fetch-mode: cors'   -H 'sec-fetch-dest: empty'   -H 'referer: https://faucet.polygon.technology/'   -H 'accept-language: zh-CN,zh;q=0.9'   --data-binary '{"network":"mumbai","address":"'$i'","token":"maticToken"}'   --compressed
  echo 
  sleep 30
  done
  }


check(){
  curl 'https://api-testnet.polygonscan.com/api?module=account&action=balancemulti&address='$token1','$token2','$token3'&tag=latest&apikey=YourApiKeyToken' -s |jq
  echo 
}
while true
do
matic
check
sleep 300
done
