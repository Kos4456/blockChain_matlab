classdef Block
properties
    nonce(1,1) uint32
    prevHash(1,1) string
    transaction(1,1) Transaction
    ts(1,1) datetime
    hash(1,1) string
end

methods
    function obj = Block(prevHash,transaction)
        if nargin>1
            obj.nonce = 1+round(1*rand());
            obj.prevHash = prevHash;
            obj.transaction = transaction;
            obj.ts = datetime('now');
        end
    end

    function hash = get.hash(this)
        hash = string(sha256(char(toString(this))));
        
    end

    function stringBlock = toString(this)
        stringBlock = join([num2str(this.nonce),this.prevHash,this.transaction.hash,string(this.ts)],'');
    end

    
end

end
