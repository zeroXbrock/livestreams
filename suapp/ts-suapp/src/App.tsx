import { useState, useEffect } from 'react'
import './App.css'

import { type SuaveWallet, getSuaveProvider, getSuaveWallet, type TransactionRequestSuave, SuaveProvider } from '@flashbots/suave-viem/chains/utils'
import { CustomTransport, Hex, HttpTransport, custom, encodeAbiParameters, encodeFunctionData, http } from '@flashbots/suave-viem'
import Counter from "../../out/Counter.sol/Counter.json"

export type EthereumProvider = { request(...args: unknown[]): Promise<unknown> }

const COUNTER_ADDRESS = "0xd594760B2A36467ec7F0267382564772D7b0b73c"

function App() {
  // the number from onchain:
  const [theNumber, setTheNumber] = useState<number>()
  const [wallet, setWallet] = useState<SuaveWallet<CustomTransport>>()
  const [suaveProvider, setSuaveProvider] = useState<SuaveProvider<HttpTransport>>()
  const [connectedAcccount, setConnectedAccount] = useState<string>()
  // the user's input number:
  const [inputNum, setInputNum] = useState<string>()
  const [status, setStatus] = useState<string>()

  const sendCCR = async (inputNum: Hex) => {
    if (wallet && suaveProvider) {
      const gasPrice = await suaveProvider.getGasPrice()
      const nonce = await suaveProvider.getTransactionCount({ address: wallet.account.address })

      const tx: TransactionRequestSuave = {
        to: COUNTER_ADDRESS,
        data: encodeFunctionData({
          abi: Counter.abi,
          functionName: 'setNumber',
        }),
        confidentialInputs: encodeAbiParameters([
          { type: 'uint256' },
        ], [
          BigInt(inputNum)
        ]),
        kettleAddress: '0xB5fEAfbDD752ad52Afb7e1bD2E40432A485bBB7F',
        gas: 100000n,
        gasPrice,
        nonce,
        type: '0x43',
      }
      const txHash = await wallet.sendTransaction(tx)
      console.log(txHash)

      const receipt = await suaveProvider.getTransactionReceipt({ hash: txHash })
      setStatus(receipt.status)
    }
  }

  useEffect(() => {
    const getNumber = async () => {
      if (suaveProvider) {
        const res = await suaveProvider.call({
          to: COUNTER_ADDRESS,
          data: encodeFunctionData({
            abi: Counter.abi,
            functionName: 'number',
          }),
        })
        console.log(res)
        if (!res.data) {
          throw new Error('No data returned')
        }
        setTheNumber(parseInt(res.data, 16))
      }
    }
    console.log("thenumber", theNumber)
    async function load() {
      if ('ethereum' in window) {
        const eth = window.ethereum as EthereumProvider
        if (!connectedAcccount) {
          const accounts = await eth.request({ method: 'eth_requestAccounts' }) as Hex[];
          if (accounts.length > 0) {
            setConnectedAccount(accounts[0])
          }
        }
        if (!wallet && connectedAcccount) {
          const wallet = getSuaveWallet({
            transport: custom(eth),
            jsonRpcAccount: connectedAcccount as Hex,
          })
          setWallet(wallet)
        }
      } else {
        console.log('No ethereum provider found')
      }
    }
    if (!suaveProvider) {
      setSuaveProvider(
        getSuaveProvider(http('http://localhost:8545'))
      )
    }
    if (theNumber === undefined) {
      getNumber()
    }
    load()
  }, [suaveProvider, connectedAcccount, theNumber, wallet])

  return (
    <>
      <h1>The Number: {theNumber}</h1>
      <input type="number" onChange={(e) => setInputNum(e.target.value)} />
      {inputNum && <button onClick={() => {
        console.log("inputNum", inputNum, typeof inputNum, parseInt(inputNum).toString(16))
        sendCCR(`0x${parseInt(inputNum).toString(16) as Hex}`)
      }}>Set Number</button>}
      {status && <p className="read-the-docs">
        <strong>
          {status === 'success' ? 'Transaction successful' : 'Transaction failed'}
        </strong>
      </p>}
      <p className="read-the-docs">
        Connected Account: {connectedAcccount}
      </p>
      <p className="read-the-docs">
        Contract Address: {COUNTER_ADDRESS}
      </p>
    </>
  )
}

export default App
