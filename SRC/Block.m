classdef Block
properties
    nonce(1,1) uint32
    prevHash(1,1) string
    transaction(:,1) Transaction
    ts(1,1) datetime
    hash(1,1) string
end

methods
    function obj = Block(prevHash,transaction)
        if nargin>1
            obj.nonce = round(100*rand());
            obj.prevHash = prevHash;
            obj.transaction = transaction;
            obj.ts = datetime('now');
        end
    end

    function hash = get.hash(this)
        % if strcmp(this.hash,"")
        %     hash = string(sha256(char(toString(this))));
        % else
        %     hash = this.hash;
        % end  
        hash = string(DataHash(char(toString(this)), 'HEX','SHA-256'));
    end

    function stringBlock = toString(this)
        stringBlock = join([num2str(this.nonce),this.prevHash,this.transaction.hash,string(this.ts)],'');
    end

    
end

end
