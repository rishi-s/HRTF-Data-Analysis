function count(indepVar,value,depVar,outcome,parameter)
%COUNT Counts instances of a specific context and outcome
%   Detailed explanation goes here
counter=0;
for r=1:size(indepVar,1)
    if indepVar(r)==value && depVar(r)==outcome;
        counter = counter+1
    end
end
assignin('caller', parameter, counter)
end


