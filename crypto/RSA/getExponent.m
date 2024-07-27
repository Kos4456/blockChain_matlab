function Exponent = getExponent(keyStr)
if isstring(keyStr);keyStr=char(keyStr);end
idxSep = strfind(keyStr,'|');
Exponent = int32(str2double(keyStr(idxSep+1:end)));
end
