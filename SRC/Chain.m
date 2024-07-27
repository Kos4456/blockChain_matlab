classdef Chain < handle
properties
    chain(:,1) Block
end

methods
    function obj = Chain(initialAmount,firstWallet,varargin)
        obj.chain = [Block("", Transaction(initialAmount,'genesis',firstWallet.publicKey))];

        %construct global chain here ?
        if nargin<=2
            global mainChain;
            mainChain = Chain(initialAmount,firstWallet,false);
        end
    end
    
    function lastBlock = getLastBlock(this)
        lastBlock = this.chain(end);
    end

    function addBlock(this,transaction,payerPublicKey,signature)
        Modulus =  getModulus(payerPublicKey);
        publicExponent =  getExponent(payerPublicKey);
        decryptedHash = char(Decrypt(Modulus, publicExponent, str2double(split(signature))'));
        isValid = strcmp(transaction.hash,decryptedHash);
        %&&this.checkExistencePk(payerPublicKey)&&this.checkExistencePk(transaction.payeePublicKey)
        %abandoned so far the checkExistence=> not very enlighting/useful here and
        %question about how to record a new publicKey in the blockChain
        %outside of any transaction (and transaction need existence of
        %publicKey..) => maybe in the block?
        if isValid&&this.checkBalance(payerPublicKey)>=transaction.amount
            newBlock = Block(this.getLastBlock.hash,transaction);
            %HERE mining should go: so far just signature has been set, and
            %nobody is forced to use it (you can modify code isValid=True
            %to send any blocs to the chain)
            this.chain(end+1) = newBlock;

        end

    end
    function publicKeyExist = checkExistencePk(this,Pk)
        transactions =[this.chain(:).transaction];
        publicKeyList = unique([transactions.payerPublicKey transactions.payeePublicKey]);
        publicKeyExist = ismember(Pk,publicKeyList);
    end

    function balance = checkBalance(this,Pk)
        transactions =[this.chain(:).transaction];
        balance = sum([transactions.amount].*(Pk==[transactions.payeePublicKey]))-...
            sum([transactions.amount].*(Pk==[transactions.payerPublicKey]));
    end

    function isTransLegit = checkExistenceAndBalance(this,publicKey,amount)
        doesWalletExist=false;
        balance=0;
        for k=1:length(this.chain)
            if strcmp(publicKey,this.chain(k).transaction.payerPublicKey)
                doesWalletExist=true;
                balance = balance-this.chain(k).transaction.amount;
            end
            if strcmp(publicKey,this.chain(k).transaction.payeePublicKey)
                doesWalletExist=true;
                balance = balance+this.chain(k).transaction.amount;
            end
        end
        isTransLegit = (balance>=amount)*doesWalletExist;
    end
    end
end








% class Chain {
%   public static instance =new Chain();
% 
%   chain: Block[];
% 
%   constructor() {
%     this.chain = [new Block("", new Transaction(100,'genesis','satoshi'))];
%   }
%   get lastBlock() {
%     return this.chain[this.chain.length -1];
%   }
% 
%   addBlock(transaction: Transaction, senderPublicKey: string, signature: Buffer) {
%     // const newBlock = new Block(this.lastBlock.hash, transaction);
%     // this.chain.push(newBlock);
% 
%     const verifier = crypto.createVerify('SHA256');
%     verifier.update(transaction.toString());
% 
%     const isValid = verifier.verify(senderPublicKey,signature);
% 
%     if(isValid) {
%       const newBlock= new Block(this.lastBlock.hash,transaction);
%       this.mine(newBlock.nonce);
%       this.chain.push(newBlock);
%     }
% 
%   }
% 
%   mine(nonce: number) {
%     let solution = 1;
%     console.log('mining...')
% 
%     while(true) {
%       const hash = crypto.createHash('MD5');
%       hash.update((nonce + solution).toString()).end();
% 
%       const attempt = hash.digest('hex');
% 
%       if(attempt.substr(0,4)==='0000'){
%         console.log(`Solved: ${solution}`);
%         return solution;
%       }
% 
%       solution +=1;
%     }
%   }
% }
% 