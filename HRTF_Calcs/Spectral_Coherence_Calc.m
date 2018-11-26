function [ReorderedVBAPMatrix,ReorderedAmbiMatrix,VBAPCoherence,AmbiCoherence] = Spectral_Coherence_Calc(VBAPMeasurement,AmbiMeasurement,HRIRMeasurement)
%Calculates spectral coherence for system comparison

reorderingIndex = [1,11,18,26,33,42,49,57,64,73,80,88,95,104,111,119,126,135,142,150,157,166,173,181];
%loop through the ITD matrix to assign values to the correct cells
for i=1:187
    elevationIndex = cast(ceil(i/24)-1,'int16');
    azimuthIndex=1;
    if mod(i+24,24) ==0
        azimuthIndex = 24;
    elseif (i<169)
        azimuthIndex = mod(i+24,24);
        position= reorderingIndex(azimuthIndex)+elevationIndex;
    elseif(i>=169 && i<181)
        position= reorderingIndex(((i-168)*2)-1)+7;
    elseif(i>=181 && i<187)
        position= reorderingIndex(((i-180)*4)-3)+8;
    elseif(i==187)
        position=10;
    end
    
        
    for j=1:512
            ReorderedVBAPMatrix(i,j)=VBAPMeasurement(position,j+512);
            ReorderedAmbiMatrix(i,j)=AmbiMeasurement(position,j);
    end
    
end

    for n=1:24
        [VBAPCoherence(:,n), frequencies] = mscohere(HRIRMeasurement(n+144,:),ReorderedVBAPMatrix(n+144,:),[],[],[],44100);
        [AmbiCoherence(:,n), frequencies] = mscohere(HRIRMeasurement(n+144,:),ReorderedAmbiMatrix(n+144,:),[],[],[],44100);
    end
    
    AveCoherence(1,:)=mean(transpose(VBAPCoherence));
    AveCoherence(2,:)=mean(transpose(AmbiCoherence));
    plot(frequencies,AveCoherence,'LineWidth',2);