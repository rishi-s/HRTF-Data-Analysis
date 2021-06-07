function [ITDs, ITDMatrix, X, Y] = LISTEN_ITDCalculator(leftEarMatrix,rightEarMatrix,cutoff)
%ITDCalculation - ITD calculator
%Calculates ITD values for all IRCAM LISTEN format HRIRs
ITDMatrix = NaN(10,24);
X = 0+15*(0:23)
Y = 90-15*(0:9)
frequency = cutoff/44100*2*pi %calculate and return normalised frequency
[b,a] = butter(10,frequency); %create the filter coefficients
left = filter(b,a,leftEarMatrix,[],2); %filter the left signal
right = filter(b,a,rightEarMatrix,[],2); %filter the right signal
ITDs = transpose(finddelay(transpose(left),transpose(right))/0.0441); %calc ITD
aziCol = 1; % azimulth/column counter
eleRow = 10; % elevation/row counter
%loop through the ITD matrix to assign values to the correct cells
for i=1:187
    %Calculate positions for 7 elevation point azimuths
    if eleRow >=4 && eleRow <= 10
        ITDMatrix(eleRow,aziCol)=ITDs(i,1);
        if aziCol >=24
            eleRow=eleRow-1;
            aziCol=1;
        else
            aziCol=aziCol+1;
        end
    %Calculate positions for 8 elevation point azimuths
    elseif eleRow ==3
        ITDMatrix(eleRow,aziCol)=ITDs(i,1);
        if aziCol >=23
            eleRow=eleRow-1;
            aziCol=1;
        else
            aziCol=aziCol+2;
        end
    %Calculate positions for 9 elevation point azimuths
    elseif eleRow ==2
        ITDMatrix(eleRow,aziCol)=ITDs(i,1);
        if aziCol >=21
            eleRow=eleRow-1;
            aziCol=1;
        else
            aziCol=aziCol+4;
        end
    %Calculate positions for 10 elevation point azimuths
    elseif eleRow ==1
        ITDMatrix(eleRow,aziCol)=ITDs(i,1);
    end
end
%Plot output.
heatmap(X,Y,ITDMatrix,'Title','LISTEN 1013 HRTF Set ITDs (microseconds)','XLabel','Azimuth (º)','YLabel','Elevation (º)','FontSize',16);

