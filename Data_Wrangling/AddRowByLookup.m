function AddRowByLookup(range,source,mapName,refColName,newColNum)
%ADDROWBYLOOKUP Summary of this function goes here
%   Detailed explanation goes here
for i = 1:cast(range,'int32')
    source{i,newColNum} = mapName(char(refColName(i)));
end
end

