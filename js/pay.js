require('dotenv').config('./file/.env')
const fs = require('fs')
const Web3 = require('web3')
const { mcsSdk } = require('js-mcs-sdk')
const mcs = new mcsSdk({
  privateKey: process.env.PRIVATE_KEY,
  rpcUrl: process.env.RPC_URL,
})

//console.log(mcs.publicKey)

async function main() {
 
  const W_CID = ''
  const FILE_SIZE = '5120000'
  const MIN_AMOUNT = '0.5'

  const tx = await mcs.makePayment(W_CID, MIN_AMOUNT, FILE_SIZE)
  tx 
/* 
  const SOURCE_FILE_UPLOAD_ID = 
  const IPFS_URL = ''
  const NFT = {
    name: 'aaaa',
    description: 'aaaa',
    image: IPFS_URL,
    attributes: [],
  }

  const mintResponse =  mcs.mintAsset(SOURCE_FILE_UPLOAD_ID, NFT)
  mintResponse
  

  const SOURCE_FILE_UPLOAD_ID = '141303'
  console.log(await mcs.getFileDetails(SOURCE_FILE_UPLOAD_ID))
*/
}

main()
