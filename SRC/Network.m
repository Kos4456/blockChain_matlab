classdef Network < handle%represent all the chains in the network 
    % WARNING - just a representation, the sendMoney command from wallet
    % class send to every chains via internet, not through a centralised
    % network intermediary
    % could add fraudulent chain/user here to model their impact
    properties
        network(:,1) Chain %miner
        users(:,1) Wallet %user
        t(1,1) double %keep track of timeline
    end
    methods 
        function obj = Network(N_miner,N_wallet,initialAmount,firstWallet,varargin) %N number of chain in network
            obj.network = arrayfun(@(id) Chain(initialAmount,firstWallet,id),1:N_miner);
            obj.users = [firstWallet arrayfun(@(id) Wallet(id),1:N_wallet)];
        if nargin<5 %construct one global instance of Network (there should be only one, accessible by everyone)
            global mainNetwork;
            mainNetwork = Network(N_miner,N_wallet,initialAmount,firstWallet,false);
        end
        end
        
        function newTransaction(this,transaction,senderPublicKey,signature)
            arrayfun(@(localChain) localChain.recieveTransaction(transaction,senderPublicKey,signature),this.network);
        end

        function computeStep(this)
            for k=1:length(this.network)
                this.network(k).computeStep(this.t);

                if this.network(k).blockValidated
                    idxChainConnected = setdiff(1:length(this.network),k);%to be replace with a rndom properties
                    for n=idxChainConnected%pas très beau, dans le future on peux modéliser des fork en ne modifiant pas toutes les chaînes
                        this.network(n).recieveNewBlock(this.network(k).chain);
                        this.network(n).resetChain();
                    end
                    this.network(k).resetChain();
                    fprintf(['Chains ' repmat('%i ',1,length(idxChainConnected)) 'copied %i...\n'],idxChainConnected,k);
                    break
                end
            end
            % this.network = arrayfun(@(localChain) localChain.computeStep(this.t),this.network);
            this.t = this.t+1;
        end

        function randomLegalTransaction(this)
            % idxPayer = randi(length(this.users));%Payer
            [~,idxPayer]=max([this.users.balance]);
            possibleIdxPayee = setdiff(randperm(length(this.users)),idxPayer);%Payee
            idxPayee = possibleIdxPayee(randi(length(this.users)-1));
            
            amount = this.users(idxPayer).balance*rand(); %amount

            this.users(idxPayer).sendMoney(amount, this.users(idxPayee).publicKey)

        end

        function totalAmount = getAllMoney(this)
            sum([this.users(:).balance])
        end
    end


end