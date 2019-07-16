function [Output]=TableToPercentages(input)
%ADDROWBYLOOKUP Summary of this function goes here
%   Detailed explanation goes here
dimensions = size(input)
for i = 1:dimensions(1)
    for j = 1:dimensions(2)
        Output(i,j)=input(i,j)/sum(input(i,:))*100;
        end
end
end