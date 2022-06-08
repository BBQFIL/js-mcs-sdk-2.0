require('dotenv').config('./file/.env')
const fs = require('fs')
const { mcsSdk } = require('js-mcs-sdk')
const mcs = new mcsSdk({
  privateKey: process.env.PRIVATE_KEY,
  rpcUrl: process.env.RPC_URL,
})

//console.log(mcs.publicKey)

async function main() {


  const W_CID = 'aabe985a-47e7-4608-8648-ee58ccafed0eQmf3xowGNM6vJwTTJrgrfxn31G87vYss6kk6FtG1H93Vpy'
  const FILE_SIZE = '5120000'
  const MIN_AMOUNT = '0.5'

  const tx = await mcs.makePayment(W_CID, MIN_AMOUNT, FILE_SIZE)
  console.log('pay_statue: ' + tx.status) 
/* 
  const SOURCE_FILE_UPLOAD_ID = 141306
  const IPFS_URL = 'https://calibration-ipfs.filswan.com/ipfs/Qmf3xowGNM6vJwTTJrgrfxn31G87vYss6kk6FtG1H93Vpy'
  const NFT = {
    name: 'aaaa',
    description: 'aaaa',
    image: IPFS_URL,
    attributes: [],
  }

  const mintResponse =  mcs.mintAsset(SOURCE_FILE_UPLOAD_ID, NFT)
  console.log(mintResponse)
  

  const SOURCE_FILE_UPLOAD_ID = '141303'
  console.log(await mcs.getFileDetails(SOURCE_FILE_UPLOAD_ID))
*/
}

main()
