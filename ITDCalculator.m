function [ITDs, ITDMatrix, X, Y] = ITDCalculator(leftEarMatrix,rightEarMatrix,cutoff,title)
%ITDCalculation - ITD calculator
%Takes the test signal outputs of a binaural rendering system and 
%calculates ITD values for all test locations (IRCAM LISTEN format)
ITDMatrix = NaN(10,24);
X = 0+15*(0:23)
Y = 90-15*(0:9)
frequency = cutoff/44100*2*pi %calculate and return normalised frequency
[b,a] = butter(10,frequency); %create the filter coefficients
left = filter(b,a,leftEarMatrix,[],2); %filter the left signal
right = filter(b,a,rightEarMatrix,[],2); %filter the right signal
ITDs = transpose(finddelay(transpose(left),transpose(right))/0.0441); %calc
aziCol = 1; % azimulth/column counter
eleRow = 10; % elevation/row counter
%Loop through the ITD matrix to assign values to the correct cells.
for i=1:187
    %Calculate positions for 10 elevation point azimuths
    if aziCol ==1 && eleRow <= 10
        ITDMatrix(eleRow,aziCol)=ITDs(i,1);
        if eleRow ==1
            aziCol=aziCol+1;
            eleRow=10;
        else
            eleRow=eleRow-1;            
        end
    %Calculate positions for 7 elevation point azimuths    
    elseif mod(aziCol,2)==0 && eleRow >= 4
        ITDMatrix(eleRow,aziCol)=ITDs(i,1);
        if eleRow ==4
            aziCol=aziCol+1;
            eleRow=10;
        else
            eleRow=eleRow-1;
        end
    %Calculate positions for 9 elevation point azimuths
    elseif mod(aziCol-1,4)==0 && eleRow >= 2
        ITDMatrix(eleRow,aziCol)=ITDs(i,1);
        if eleRow ==2
            aziCol=aziCol+1;
            eleRow=10;
        else
            eleRow=eleRow-1;
        end
    %Calculate positions for 8 elevation point azimuths
    elseif mod(aziCol-3,4)==0 && eleRow >= 3
        ITDMatrix(eleRow,aziCol)=ITDs(i,1);
        if eleRow ==3
            aziCol=aziCol+1;
            eleRow=10;
        else
            eleRow=eleRow-1;
        end
    end    
end
%Plot output.
heatmap(X,Y,ITDMatrix,'Title',strcat(title, ' HRTF Set ITDs (microseconds)'),'XLabel','Azimuth (º)','YLabel','Elevation (º)','FontSize',16);

