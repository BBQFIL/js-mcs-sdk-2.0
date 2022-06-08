# 使用方法

本工具配合 filswan发布的 js-mcs-sdk v2.0.0 可以自动化实现以下功能：

 1. 文件上传（单文件上传、批量上传）
 2. 支付+铸造 （以文件为单位，顺序执行）
 3. 单支付（以文件为单位，只支付不铸造）
 4. 单铸造（以文件为单位，只铸造不支付）

以上四个功能均为独立模块，可视网络情况搭配使用

# 依赖
[Node.js](https://nodejs.org/en/) - v16​​.13.0 (npm v8.1.0)
Polygon Mumbai Testnet Wallet - [Metamask 教程](https://docs.filswan.com/getting-started/beginner-walkthrough/public-testnet/setup-metamask)  
Polygon Mumbai Testnet RPC -[通过 Alchemy 注册](https://www.alchemy.com/)

您还需要 Testnet USDC 和 MATIC 代币才能使用此 SDK。[水龙头教程](https://docs.filswan.com/development-resource/swan-token-contract/acquire-testnet-usdc-and-matic-tokens)

## 用法

使用 npm 安装包

    npm install js-mcs-sdk

配置.env

> .env文件位于file目录下

    PRIVATE_KEY=<PRIVATE_KEY>  #使用你的metamask钱包私钥替换<PRIVATE_KEY>
    RPC_URL=<RPC_URL>   #使用注册的Polygon Mumbai Testnet RPC替换<RPC_URL>


文件上传 

> 	js/upload.js文件中的{ fileName: FILE_NAME, file: fs.createReadStream(FILE_PATH) },行数决定了一次上传一个文件

    async function main() {
      const FILE_NAME = 'file_name'
      const FILE_PATH = './file/aaaa'
    
      const fileArray = [
        { fileName: FILE_NAME, file: fs.createReadStream(FILE_PATH) },
        { fileName: FILE_NAME, file: fs.createReadStream(FILE_PATH) }, //两行代表上传两个文件
    
      ]
    
      const uploadResponse = await mcs.upload(fileArray)
      console.log(uploadResponse)
    }
确定好上传几个文件后，开始运行upload.sh脚本来执行上传

    bash upload.sh



支付+铸造

    bash paymint.sh

单支付

    bash pay.sh

单铸造

    bash mint.sh


上述所有脚本均可随时通过Ctrl+C终止,不会影响下次执行.

> 注意：受制于EVM的参数nonce影响，支付+铸造、单支付、单铸造同一时间只可以运行其中一个。

