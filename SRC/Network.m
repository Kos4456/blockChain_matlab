classdef Network < handle%represent all the chains in the network 
    % WARNING - just a representation, the sendMoney command from wallet
    % class send to every chains via internet, not through a centralised
    % network intermediary
    % could add fraudulent chain/user here to model their impact
    properties
        network(:,1) Chain
    end
    methods 
        function obj = Network(N,initialAmount,firstWallet,varargin) %N number of chain in network
            obj.network = arrayfun(@(id) Chain(initialAmount,firstWallet,id),1:N);

        if nargin<4 %construct one global instance of Network (there should be only one, accessible by everyone)
            global mainNetwork;
            mainNetwork = Network(N,initialAmount,firstWallet,false);
        end
        end
        
        function distributeTransaction(this,transaction,senderPublicKey,signature)
            %ici par représentatif mais: on attends que le bloc soit validé
            %sur chaque chaîne, et on sort le classement de qui l'a validé
            %en premier
            initialChainLength = min(cellfun(@length ,{this.network(:).chain}));%arbitraire mais ok tant que les run de blocks sont sync
            %et on sort le classement
            while any(cellfun(@length ,{this.network(:).chain})~=initialChainLength+1)%tant que le bloc n'a pas été validé sur toutes les chaînes
                idxChainNotFinished = find(cellfun(@length ,{this.network(:).chain})==initialChainLength);
                this.network(idxChainNotFinished) = arrayfun(@(localChain) localChain.addBlock(transaction,senderPublicKey,signature),...
                    this.network(idxChainNotFinished));
            end
        end
    end


end