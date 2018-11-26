function [ILDs, ILDMatrix, X, Y] = LISTEN_ILDCalculator(leftEarMatrix,rightEarMatrix,cutoff)
%ITDCalculation - ITD calculator
%Calculates ITD values for all IRCAM LISTEN format HRIRs
ILDMatrix = NaN(10,24);
X = 0+15*(0:23)
Y = 90-15*(0:9)
frequency = cutoff/44100*2*pi %calculate and return normalised frequency
[b,a] = butter(5,frequency,'high'); %create the filter coefficients
left = filter(b,a,leftEarMatrix,[],2); %filter the left signal
right = filter(b,a,rightEarMatrix,[],2); %filter the right signal
ILDs = zeros(187,1); %create array for ILD values
% calculate each position's ILD
for n=1:187
    ILDs(n,1) = (meansqr(left(n,:))) / (meansqr(right(n,:)))
end
ILDs=10*log10(ILDs) %convert to dB
aziCol = 1; % azimulth/column counter
eleRow = 10; % elevation/row counter
%loop through the ITD matrix to assign values to the correct cells
for i=1:187
    
    if eleRow >=4 && eleRow <= 10
        %Calculate positions for 7 elevation point azimuths
        ILDMatrix(eleRow,aziCol)=ILDs(i,1);
        if aziCol >=24
            eleRow=eleRow-1;
            aziCol=1;
        else
            aziCol=aziCol+1;
        end
    %Calculate positions for 8 elevation point azimuths
    elseif eleRow ==3
        ILDMatrix(eleRow,aziCol)=ILDs(i,1);
        if aziCol >=23
            eleRow=eleRow-1;
            aziCol=1;
        else
            aziCol=aziCol+2;
        end
    %Calculate positions for 9 elevation point azimuths
    elseif eleRow ==2
        ILDMatrix(eleRow,aziCol)=ILDs(i,1);
        if aziCol >=21
            eleRow=eleRow-1;
            aziCol=1;
        else
            aziCol=aziCol+4;
        end
    %Calculate positions for 10 elevation point azimuths
    elseif eleRow ==1
        ILDMatrix(eleRow,aziCol)=ILDs(i,1);
    end
end
%Plot output.
heatmap(X,Y,ILDMatrix,'Title','LISTEN 1013 HRTF Set ILDs (dB)','XLabel','Azimuth (º)','YLabel','Elevation (º)','FontSize',16,'Colormap',summer);

