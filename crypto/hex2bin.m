function s= hex2bin(h,N)
%HEX2BIN Convert hexdecimal string to a binary string.
%   HEX2BIN(h) returns the binary representation of h as a string.
%   
%   Author :Tamir Suliman
%   Revision of the matlab functions
%   HEX2BIN(h,n) produces a binary representation with at least
%   N bits.
%
%   Example
%      hex2bin('f') returns '1111'
%      hex2bin('fa') returns '1111 1010'
%      hex2bin(['f' 'a'],4) returns 
%      0010 1111
%   See also BIN2DEC, DEC2HEX, DEC2BASE.

%   
%   This function implemented with the help  of  hex2dec and dec2bin
%
% Input checking
%
h=h(:);  % Make sure h is a column vector.
if iscellstr(h), h = char(h); end
if isempty(h), s = []; return, end
% Work in upper case.
h = upper(h);
[m,n]=size(h);
% Right justify strings and form 2-D character array.
if ~isempty(find((h==' ' | h==0),1))
  h = strjust(h);
  % Replace any leading blanks and nulls by 0.
  h(cumsum(h ~= ' ' & h ~= 0,2) == 0) = '0';
else
  h = reshape(h,m,n);
end
% Check for out of range values
if any(any(~((h>='0' & h<='9') | (h>='A'&h<='F'))))
   error('MATLAB:hex2bin:IllegalHexadecimal',...
      'Input string found with characters other than 0-9, a-f, or A-F.');
end
sixteen = 16;
p = fliplr(cumprod([1 sixteen(ones(1,n-1))]));
p = p(ones(m,1),:);
s = h <= 64; % Numbers
h(s) = h(s) - 48;
s =  h > 64; % Letters
h(s) = h(s) - 55;
s = sum(h.*p,2);
% Decimal  to Binary 
d = s;
if nargin<2
    N = 2; % Default value of N is 2.
else
    if ~(isnumeric(N) || ischar(N)) || ~isscalar(N) || N<0
        error('MATLAB:hex2bin:InvalidBitArg','N must be a positive scalar numeric.');
    end
    N = round(double(N)); % Make sure N is an integer.
end;
% Actual algorithm
[f,e] = log2(max(d)); % How many digits do we need to represent the numbers?
N = max(N, e); % Use the larger of N and e.
s = char(rem(floor(d*pow2(1-N:0)),2)+'0');

s = reshape(s',1,numel(s));