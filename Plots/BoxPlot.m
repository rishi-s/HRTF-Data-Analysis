function BoxPlot(parameter,groups,lowerOutlier,upperOutlier,graphLabel,xLabel,yLabel)
%BOXPLOTSTIME Summary of this function goes here
%   Detailed explanation goes here
figure;
boxplot(parameter,groups,'Notch','off','DataLim',[lowerOutlier,upperOutlier],'ExtremeMode','compress');
title(graphLabel,'FontSize',16);
xlabel(xLabel,'FontSize',14)
ylabel(yLabel,'FontSize',14)
end

