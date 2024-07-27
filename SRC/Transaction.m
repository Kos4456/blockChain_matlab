classdef Transaction
    properties
        amount(1,1) double
        payerPublicKey(1,1) string
        payeePublicKey(1,1) string
        %HERE: ajouter une propriété qui permet de rendre la transaction
        %unique (randi + date) => pas besoin tout de suite ça se fait côté bloc MAIS
        %parcequ'il y a une transaction = un block 
        nonce(1,1) uint32
        ts(1,1) datetime
        hash(1,1) string

    end
    methods
        function obj = Transaction(amount,payerPublicKey,payeePublicKey)
            if nargin>1
                obj.amount = amount;
                obj.payeePublicKey = payeePublicKey;
                obj.payerPublicKey = payerPublicKey;
                obj.ts = datetime('now');
                obj.nonce = round(1e9*rand());
            end
        end

        function stringTransaction = toString(this)
            stringTransaction = join([num2str(this.amount) this.payeePublicKey this.payerPublicKey string(this.ts) num2str(this.nonce)],'');
        end

        function hash = get.hash(this)
            hash = string(sha256(char(toString(this))));
        end

    end
end


%bien lister les interfaces avec l'extérieur pour comprendre le mécanisme



%   constructor(
%     public amount: number,
%     public payer: string, //public key
%     public payee: string
%   ) {}
% 
%   toString() {
%     return JSON.stringify(this);
%   }
% }
% 
% class Block {
%   public nonce = Math.round(Math.random() * 999999999);
%   constructor(
%     public prevHash: string,
%     public transaction: Transaction,
%     public ts = Date.now()
%   ) {}
% 
%   get hash() {
%     const str = JSON.stringify(this);
%     const hash = crypto.createHash('SHA256');
%     hash.update(str).end();
%     return hash.digest('hex');
%   } //getter
% }
% 
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
% class Wallet {
%   public publicKey: string;
%   public privateKey: string;
% 
%   constructor() {
%     const keypair = crypto.generateKeyPairSync('rsa', {
%       modulusLength:2048,
%       publicKeyEncoding: {type: 'spki',format:'pem'},
%       privateKeyEncoding: {type: 'pkcs8', format: 'pem'}});
% 
%       this.privateKey = keypair.privateKey;
%       this.publicKey = keypair.publicKey;
%     }
% 
%   sendMoney(amount: number, payeePublicKey: string) {
%       const transaction = new Transaction(amount,this.publicKey,payeePublicKey)
%       const sign = crypto.createSign('SHA256');
%       sign.update(transaction.toString()).end();
% 
%       const signature = sign.sign(this.privateKey);
%       Chain.instance.addBlock(transaction,this.publicKey,signature);
% 
%     } 
% }
% 
% // Example usage
% 
% const satoshi = new Wallet();
% const bob = new Wallet();
% const alice = new Wallet();
% 
% satoshi.sendMoney(50, bob.publicKey);
% bob.sendMoney(23, alice.publicKey);
% alice.sendMoney(5, bob.publicKey);
% 
% console.log(Chain.instance)