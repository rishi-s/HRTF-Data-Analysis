function Bar(categories,outcomes,type,graphLabel,xLabel,yLabel,legLoc,outcome1,outcome2,outcome3)
%BOXPLOTSTIME Summary of this function goes here
%   Detailed explanation goes here
figure;
bar(categories,outcomes,type);
title(graphLabel,'FontSize',16);
xlabel(xLabel,'FontSize',14)
ylabel(yLabel,'FontSize',14)
legend({outcome1,outcome2,outcome3},'Location',legLoc,'FontSize',12)
end