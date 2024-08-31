classdef Wallet
    properties
        publicKey(1,1) string
        privateKey(1,1) string
        balance(1,1) double
        id(1,1) int32 %to keep track of thing
    end

    methods
        function obj = Wallet(varargin)
            [Modulus, PublicExponent, PrivateExponent] = GenerateKeyPair;
            obj.publicKey=[num2str(Modulus), '|' num2str(PublicExponent)];
            obj.privateKey=[num2str(Modulus), '|' num2str(PrivateExponent)];
            
            if nargin>0
                obj.id = varargin{1};
            end
            % %inscription on the mainChain (to record publicKey) =>
            % abandonned, see comment in chain.addBlock method
            % if nargin==0
            %     obj.sendMoney(0,obj.publicKey)
            % end
        end

        function sendMoney(this,number, payeePublicKey)
            transaction = Transaction(number,this.publicKey,payeePublicKey);
            Modulus =  getModulus(this.privateKey);
            Exponent =  getExponent(this.privateKey);
            signature = join(num2str(Encrypt(Modulus,Exponent,char(transaction.hash))),' ');
            global mainNetwork;
            mainNetwork.newTransaction(transaction,this.publicKey,signature)
        end
        
        function balance = get.balance(this)
            global mainNetwork;
            balance = mainNetwork.network(2).checkBalance(mainNetwork.network(2).chain,this.publicKey); %very bad x)
        end
    end

end





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