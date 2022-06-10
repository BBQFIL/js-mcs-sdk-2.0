require('dotenv').config('./file/.env')
const fs = require('fs')
const { mcsSdk } = require('js-mcs-sdk')
const mcs = new mcsSdk({
  privateKey: process.env.PRIVATE_KEY,
  rpcUrl: process.env.RPC_URL,
})

//console.log(mcs.publicKey)

async function main() {
  const FILE_NAME = ''
  const FILE_PATH = './file/data'

  const fileArray = [
    { fileName: FILE_NAME, file: fs.createReadStream(FILE_PATH) },
    { fileName: FILE_NAME, file: fs.createReadStream(FILE_PATH) },

  ]

  const uploadResponse = await mcs.upload(fileArray)
  console.log(uploadResponse)
}

main()

