function Modulus = getModulus(keyStr)
if isstring(keyStr);keyStr=char(keyStr);end
idxSep = strfind(keyStr,'|');
Modulus = str2double(keyStr(1:idxSep-1));
end
