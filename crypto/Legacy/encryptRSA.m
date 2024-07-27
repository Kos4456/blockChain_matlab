function encryptedMsg = encryptRSA(msg,publicKey)
m1=msg-0;
over=length(m1);
o=1;
while(o<=over);
    m=m1(o);
    diff=0;
    if(m>n);
        diff=m-n+1;
    end
    m=m-diff;
        
qm=dec2bin(e);
len=length(qm);
c=1;
xz=1;
while(xz<=len)  
    if(qm(xz)=='1')
      c=mod(mod((c^2),n)*m,n);
    elseif(qm(xz)=='0')
        c=(mod(c^2,n));
    end
    xz=xz+1;
end
c1(o)=c;

qm1=dec2bin(d);
len1=length(qm1);
nm=1;
xy=1;
while(xy<=len1)    
    if(qm1(xy)=='1')
       nm=mod(mod((nm^2),n)*c,n);
    elseif(qm1(xy)=='0')
        nm=(mod(nm^2,n));
    end
     xy=xy+1;    
end
nm=nm+diff;
nm1(o)=char(nm);
o=o+1;

o=1;
fprintf('\nThe encrypted message is \n');
encryptedMsg = [];
while(o<=over)
   fprintf('\t%d',c1(o)); 
   encryptedMsg = [encryptedMsg char(c1(o))];
   o=o+1;
end


end
