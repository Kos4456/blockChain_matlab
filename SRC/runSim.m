%initiate global chain
clear all
Satoshi = Wallet(); %First wallet flag to not record a transaction on a chain that do not exist yet.
Network(100,100,1000,Satoshi); 

global mainNetwork;

Alice = Wallet();
Bob = Wallet();

Satoshi.balance
Alice.balance
Bob.balance

% Satoshi.sendMoney(20,Alice.publicKey)
% Bob.sendMoney(30,Alice.publicKey)%here problem for incorrect bloc
% Alice.sendMoney(5,Bob.publicKey)

nStep=1000;
for k=1:nStep
    mainNetwork.randomLegalTransaction()
    % if k==10
    %     %event
    %     Satoshi.sendMoney(50,Alice.publicKey)
    % end
    % 
    % if k==20
    %     %event
    %     Satoshi.sendMoney(30,Bob.publicKey)
    % end
    % 
    % if k==30
    %     %event
    %     Bob.sendMoney(40,Alice.publicKey)
    % end

    mainNetwork.computeStep()
end

mainNetwork.getAllMoney()





%Every miner=>localChain
% Protocol:
%User (Wallet)
% 1) envoie une transaction aux mineurs auxquels il est connecté
%Mineur
% 1) mineur reçoit un bloc avec un transaction qu'il vérifie
% 2) le bloc est ajouté à sa chaîne après un minage
% 3) sa chaine est propagé dans le réseau

%dans le bitcoin, validation et mining sont fait par des noeuds différents
%



