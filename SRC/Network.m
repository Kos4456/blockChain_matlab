classdef Network < handle%represent all the chains in the network 
    % WARNING - just a representation, the sendMoney command from wallet
    % class send to every chains via internet, not through a centralised
    % network intermediary
    % could add fraudulent chain/user here to model their impact
    properties
        network(:,1) Chain
        t(1,1) double %keep track of timeline
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
            this.network = arrayfun(@(localChain) localChain.addBlock(transaction,senderPublicKey,signature),this.network);
        end

        function computeStep(this)
            for k=1:length(this.network)
                this.network(k) = this.network(k).computeStep(this.t);
                if this.network(k).blockValidated
                    this.network(k).isMining = false;
                    idxChainConnected = setdiff(1:length(this.network),k);%to be replace with a rndom properties
                    for n=idxChainConnected%pas très beau, dans le future on peux modéliser des fork en ne modifiant pas toutes les chaînes
                        this.network(n).chain=this.network(k).chain;
                        this.network(n).isMining = false;%here: choice of behavior, reset when another one has mined the block
                    end
                    this.network(k).blockValidated=false;
                    fprintf(['Chains ' repmat('%i ',1,length(idxChainConnected)) 'copied %i...\n'],idxChainConnected,k);
                    break
                end
            end
            % this.network = arrayfun(@(localChain) localChain.computeStep(this.t),this.network);
            this.t = this.t+1;
        end
    end


end