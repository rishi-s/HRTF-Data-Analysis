function fourVarCount(indepVar,depVar,matrix,a,b,c,d)
%GENRERATES Summary of this function goes here
%   Detailed explanation goes here
aT = 0;
aF = 0;
bT = 0;
bF = 0;
cT = 0;
cF = 0;
dT = 0;
dF = 0;
for r=1:701
    if indepVar(r) == a && depVar(r)== 'True'
        aT=aT+1;
    elseif indepVar(r) == a && depVar(r)== 'False'
        aF=aF+1;
    elseif indepVar(r) == b && depVar(r)== 'True'
        bT=bT+1;
    elseif indepVar(r) == b && depVar(r)== 'False'
        bF=bF+1;
    elseif indepVar(r) == c && depVar(r)== 'True'
        cT=cT+1;
    elseif indepVar(r) == c && depVar(r)== 'False'
        cF=cF+1;
    elseif indepVar(r) == d && depVar(r)== 'True'
        dT=dT+1;
    elseif indepVar(r) == d && depVar(r)== 'False'
        dF=dF+1;
    end
    
    
end
results=[aT,aF; bT,bF; cT,cF; dT,dF]
assignin('caller',matrix,results)
end