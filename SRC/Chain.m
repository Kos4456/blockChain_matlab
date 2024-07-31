classdef Chain
properties
    chain(:,1) Block
    id(1,1) int32 %temporary, to keep track of thing
    blockValidated(1,1) double %To communicate with network
    isMining(1,1) double
end
properties(Access=private)
    blockToMine(1,1) Block
end

methods
    function obj = Chain(initialAmount,firstWallet,id)
        obj.chain = [Block("", Transaction(initialAmount,'genesis',firstWallet.publicKey))];
        obj.id = id;

        %private properties linked to iterative modeling of user behavior
        % obj.isMining = false;
        % obj.blockToMine = Block("", Transaction(initialAmount,'genesis',firstWallet.publicKey));%Bloc not relevant, just need to be one
        % obj.blockValidated=false;
    end
    
    function lastBlock = getLastBlock(this)
        lastBlock = this.chain(end);
    end

    function this = addBlock(this,transaction,payerPublicKey,signature)
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
            this.blockValidated=false;
            this.isMining=true;
            this.blockToMine = Block(this.getLastBlock.hash,transaction); %not representative: block is recreated each time but that is not relevant
            %HERE mining should go: so far just signature has been set, and
            %nobody is forced to use it (you can modify code isValid=True
            %to send any blocs to the chain)
        end

    end
    
    function this = computeStep(this,t)
        if this.isMining
            this = this.mine(t);
        end
    end

    function this = mine(this,t)%primitive mining function
        this.blockValidated=false;
        currentTestedBock = this.blockToMine;
        currentTestedBock.nonce = currentTestedBock.nonce+t;
        blockHash_bin = hex2bin(char(currentTestedBock.hash));
        if strcmp(blockHash_bin(1:3),'000') %HERE: complexity param
            fprintf("chain %i validated block %s...\n",this.id,currentTestedBock.hash)
            this.blockValidated=true;
            this.chain(end+1) = currentTestedBock;
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

    function verifyChain(newChain)


    end
    end
end




% EXPLICATION Acceptation block ou pas
% s'il y a fraude sur une transaction, on peux s'en rendre compte avec des
% check complet de la Database de la chaîne, même si celui ci est déjà
% validé.
% Quand un bloc validé frauduleux est émis, un autre mineur peux
% l'accepter et miner par dessus, mais il est quasiment sûr que le reste du
% réseau va le refuser et il aura miner pour rien, ou bien le rejeter
% l'auteur du bloc faux mais validé en premier va l'émettre à tout le
% monde, les utilisateurs vont potentiellement l'accepter pendant un temps
% mais ensuite les autres mineurs vont produire une autre chaîne parallèle
% qui va finir par dépasser forcément la chaîne du tricheur du fait de la
% différence de puissance de calcul, avec la règle de la chaîne la plus
% longue on finit par retomber sur le consensus majoritaire
% est-ce qu'on faire un bloc et cashout ? dans le bitcoin, il ya un
% settlement interval de 10mn (paramètre par défault mis en place par
% satoshi). Pendant cet interval plusieurs blocs sont minés, il peux y
% avoir des fork mais on considère que tout doit être settle en 10mn. Du
% coup c'est les mineurs de la chaîne gagnante qui sont récompensés (je
% pense) EN FAIT NON
%https://bitcoin.stackexchange.com/questions/95504/do-miners-validate-each-others-blocks
%"only blocks that end up being a part of the best chain get paid out"
% https://developer.bitcoin.org/devguide/block_chain.html
% "The UTXO of a coinbase transaction has the special condition 
% that it cannot be spent (used as an input) for at least 100 blocks. 
% This temporarily prevents a miner from spending the transaction fees 
% and block reward from a block that may later be determined to be stale 
% (and therefore the coinbase transaction destroyed) after a block chain
% fork."
%https://learnmeabitcoin.com/technical/mining/coinbase-transaction/#coinbase-maturity
%Comment on s'assure que le mineur ne fasse pas ceci: 
%1) miner n'importe quel bloc, réussir une fois
%2) continuer la chaîne pendant 100 blocs sans se soucier de partir en
%branche
%3) toucher la récompense
%=> en fait la règle des 100blocs c'est une règle network, donc après
%100blocs il faudra l'inscrire comme une transaction classique un moment
%pour la dépenser => le réseau verra que les règles n'ont pas été
%respectées et le refusera.

%Ce n'est plus tout à fait la chaine la plus longue mais la plus grande
%quantité de travail

% Le miner choisi les transactions en fonction des fees, mais du coup il
% peux y avoir des transactions justes mais fausses quand on regarde la
% database parce qu'elles dépendent d'une auter transaction non prise en
% compte => c'est au mineur de trouver un bloc qui marche


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