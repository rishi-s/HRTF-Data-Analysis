function Histogram(source,graphLabel,xLabel,yLabel,numberBins)
%BOXPLOTSTIME Summary of this function goes here
%   Detailed explanation goes here
figure;
if numberBins >= 1 histogram(source,numberBins); 
    title(graphLabel,'FontSize',16);
    xlabel(xLabel,'FontSize',14)
    ylabel(yLabel,'FontSize',14)
else histogram(source);
    title(graphLabel,'FontSize',16);
    xlabel(xLabel,'FontSize',14)
    ylabel(yLabel,'FontSize',14)
end

