%initiate global chain
clear all
Satoshi = Wallet(); %First wallet flag to not record a transaction on a chain that do not exist yet.
Chain(100,Satoshi); 

global mainChain;
mainChain.chain

Alice = Wallet();
Bob = Wallet();

Satoshi.balance
Alice.balance
Bob.balance

Satoshi.sendMoney(40,Alice.publicKey)
Bob.sendMoney(30,Alice.publicKey)
Alice.sendMoney(5,Bob.publicKey)

