%initiate global chain
clear all
Satoshi = Wallet(); %First wallet flag to not record a transaction on a chain that do not exist yet.
Network(2,100,Satoshi); 

global mainNetwork;

Alice = Wallet();
Bob = Wallet();

Satoshi.balance
Alice.balance
Bob.balance

Satoshi.sendMoney(20,Alice.publicKey)
Bob.sendMoney(30,Alice.publicKey)%here problem for incorrect bloc
Alice.sendMoney(5,Bob.publicKey)


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



