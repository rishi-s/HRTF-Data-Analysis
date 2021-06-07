function [VBAPSpecErrorL, VBAPSpecErrorR, AmbiSpecErrorL, AmbiSpecErrorR,CFreqs] ...
    = Spectral_Error_Calc(VBAPMeasurementL,VBAPMeasurementR, ...
    AmbiMeasurementL, AmbiMeasurementR, HRIRMeasurementL, HRIRMeasurementR)
%Calculates spectral coherence for system comparison

%Check for peak values across all locations from each input
VBAPPeaks(1,1:2)=[max(max(VBAPMeasurementL)), min(min(VBAPMeasurementL))*-1]
VBAPPeaks(1,3:4)=[max(max(VBAPMeasurementR)), min(min(VBAPMeasurementR))*-1]
AmbiPeaks(1,1:2)=[max(max(AmbiMeasurementL)), min(min(AmbiMeasurementL))*-1]
AmbiPeaks(1,3:4)=[max(max(AmbiMeasurementR)), min(min(AmbiMeasurementR))*-1]
HRIRPeaks(1,1:2)=[max(max(HRIRMeasurementL)), min(min(HRIRMeasurementL))*-1]
HRIRPeaks(1,3:4)=[max(max(HRIRMeasurementR)), min(min(HRIRMeasurementR))*-1]

%Select peak normalisation scalars:
VBAPScalar=1/max(VBAPPeaks)
AmbiScalar=1/max(AmbiPeaks)
HRIRScalar=1/max(HRIRPeaks)
    
%Define reordering sequence for VBAP and Ambisonics system outputs
reorderingIndex = [1,11,18,26,33,42,49,57,64,73,80,88,95,104,111,119,126,... 
    135,142,150,157,166,173,181];

%Loop through the ITD matrix to assign values to the correct cells
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
    %Assign value to new location with peak normalisation scaling
    for j=1:512
        ReorderedVBAPMatrixL(i,j)=VBAPMeasurementL(position,j+512)*VBAPScalar;
        ReorderedVBAPMatrixR(i,j)=VBAPMeasurementR(position,j+512)*VBAPScalar;
        ReorderedAmbiMatrixL(i,j)=AmbiMeasurementL(position,j)*AmbiScalar;
        ReorderedAmbiMatrixR(i,j)=AmbiMeasurementR(position,j)*AmbiScalar;
    end
end

%Define ERB bands
bands=40;
CFreqs= iosr.auditory.makeErbCFs(100,16000,bands);

%Filter the signal for either ear at each location in each system
for n=1:187
    VBAPSpecL(:,:,n) = iosr.auditory.gammatoneFast...
        (ReorderedVBAPMatrixL(n,:),CFreqs,44100);
    VBAPSpecR(:,:,n) = iosr.auditory.gammatoneFast...
        (ReorderedVBAPMatrixR(n,:),CFreqs,44100);
    AmbiSpecL(:,:,n) = iosr.auditory.gammatoneFast...
        (ReorderedAmbiMatrixL(n,:),CFreqs,44100);
    AmbiSpecR(:,:,n) = iosr.auditory.gammatoneFast...
        (ReorderedAmbiMatrixR(n,:),CFreqs,44100);
    HRIRSpecL(:,:,n) = iosr.auditory.gammatoneFast...
        (HRIRMeasurementL(n,:),CFreqs,44100);
    HRIRSpecR(:,:,n) = iosr.auditory.gammatoneFast...
        (HRIRMeasurementR(n,:),CFreqs,44100);
    for m=1:bands
        VBAPSpecErrorL(m,n)=meansqr(VBAPSpecL(m,:,n))/meansqr(HRIRSpecL(m,:,n));
        VBAPSpecErrorL(m,n)=10*log10(VBAPSpecErrorL(m,n));
        if VBAPSpecErrorL(m,n) < 0
            VBAPSpecError_U_L(m,n) = VBAPSpecErrorL(m,n)*-1;
        else
            VBAPSpecError_U_L(m,n) = VBAPSpecErrorL(m,n);
        end
        VBAPSpecErrorR(m,n)=meansqr(VBAPSpecR(m,:,n))/meansqr(HRIRSpecR(m,:,n));
        VBAPSpecErrorR(m,n)=10*log10(VBAPSpecErrorR(m,n));
        if VBAPSpecErrorR(m,n) < 0
            VBAPSpecError_U_R(m,n) = VBAPSpecErrorR(m,n)*-1;
        else
            VBAPSpecError_U_R(m,n) = VBAPSpecErrorR(m,n);
        end
        AmbiSpecErrorL(m,n)=meansqr(AmbiSpecL(m,:,n))/meansqr(HRIRSpecL(m,:,n));
        AmbiSpecErrorL(m,n)=10*log10(AmbiSpecErrorL(m,n));
        if AmbiSpecErrorL(m,n) < 0
            AmbiSpecError_U_L(m,n) = AmbiSpecErrorL(m,n)*-1;
        else
            AmbiSpecError_U_L(m,n) = AmbiSpecErrorL(m,n);
        end
        AmbiSpecErrorR(m,n)=meansqr(AmbiSpecR(m,:,n))/meansqr(HRIRSpecR(m,:,n));
        AmbiSpecErrorR(m,n)=10*log10(AmbiSpecErrorR(m,n));
        if AmbiSpecErrorR(m,n) < 0
            AmbiSpecError_U_R(m,n) = AmbiSpecErrorR(m,n)*-1;
        else
            AmbiSpecError_U_R(m,n) = AmbiSpecErrorR(m,n);
        end

    end
end

AveError(1,:)=mean(transpose(VBAPSpecError_U_L));
AveError(2,:)=mean(transpose(VBAPSpecError_U_R));
AveError(3,:)=mean(transpose(AmbiSpecError_U_L));
AveError(4,:)=mean(transpose(AmbiSpecError_U_R));

figure

subplot(2,1,1)
overviewL=plot(CFreqs,AveError(1,:),'-b',CFreqs,AveError(3,:),'-r');
title('Mean unsigned spectral difference by system and binaural channel output')
ax=gca;
ax.FontSize=16;
ax.XLabel.String='Frequency (Hz)';
ax.XScale = 'log';
ax.XLim = [100,16000];
ax.YLim = [0,8]
ax.YLabel.String='Unsigned difference (dB)';
legend('VBAP system left','Ambisonics system left','Location','southeast');

subplot(2,1,2)
overviewR=plot(CFreqs,AveError(2,:),'--b',CFreqs,AveError(4,:),'--r');
ax=gca;
ax.FontSize=16;
ax.XLabel.String='Frequency (Hz)';
ax.XScale = 'log';
ax.XLim = [100,16000];
ax.YLim = [0,8]
ax.YLabel.String='Unsigned difference (dB)';

legend('VBAP system right', 'Ambisonics system right','Location','southeast');



split=17;
zeroLocation='top';
VBAPstyle='-ob';
Ambistyle='-xr';
titleFontSize=14;
polarFontSize=11;
tickFontSize=10;
polarTitle='Mean unsigned spectral difference (dB)';

%Polar plots
polarPlots=figure
polarPlots.Position=[5 5 500 500]

%-LEFT -45º elevation, lower band
subplot(3,4,1)
polarplot(mean([VBAPSpecError_U_L(1:split,1:24),VBAPSpecError_U_L(1:split,1)]),VBAPstyle)
ax=gca;
ax.FontSize=polarFontSize;
ax.Title.FontSize=titleFontSize;
ax.Title.String=['-45' char(176) ' elevation, lower band (left)'];
ax.ThetaZeroLocation = zeroLocation;
ax.RLim=[0,5];
ax.RAxis.FontSize=tickFontSize;
hold all
polarplot(mean([AmbiSpecError_U_L(1:split,1:24),AmbiSpecError_U_L(1:split,1)]),Ambistyle)

%RIGHT -45º elevation, lower band
subplot(3,4,2)
polarplot(mean([VBAPSpecError_U_R(1:split,1:24),VBAPSpecError_U_R(1:split,1)]),VBAPstyle)
ax=gca;
ax.FontSize=polarFontSize;
ax.Title.FontSize=titleFontSize;
ax.Title.String=['-45' char(176) ' elevation, lower band (right)'];
ax.ThetaZeroLocation = zeroLocation;
ax.RLim=[0,5];
ax.RAxis.FontSize=tickFontSize;
hold all
polarplot(mean([AmbiSpecError_U_R(1:split,1:24),AmbiSpecError_U_R(1:split,1)]),Ambistyle)

%LEFT -45º elevation, upper band
subplot(3,4,3)
polarplot(mean([VBAPSpecError_U_L(split+1:bands,1:24),VBAPSpecError_U_L(split+1:bands,1)]),VBAPstyle)
ax=gca;
ax.FontSize=polarFontSize;
ax.Title.FontSize=titleFontSize;
ax.Title.String=['-45' char(176) ' elevation, upper band (left)'];
ax.ThetaZeroLocation = zeroLocation;
ax.RLim=[0,14];
ax.RAxis.FontSize=tickFontSize;
hold all
polarplot(mean([AmbiSpecError_U_L(split+1:bands,1:24),AmbiSpecError_U_L(split+1:bands,1)]),Ambistyle)

%RIGHT -45º elevation, upper band
subplot(3,4,4)
polarplot(mean([VBAPSpecError_U_R(split+1:bands,1:24),VBAPSpecError_U_R(split+1:bands,1)]),VBAPstyle)
ax=gca;
ax.FontSize=polarFontSize;
ax.Title.FontSize=titleFontSize;
ax.Title.String=['-45' char(176) ' elevation, upper band (right)'];
ax.ThetaZeroLocation = zeroLocation;
ax.RLim=[0,14];
ax.RAxis.FontSize=tickFontSize;
hold all
polarplot(mean([AmbiSpecError_U_R(split+1:bands,1:24),AmbiSpecError_U_R(split+1:bands,1)]),Ambistyle)

%-LEFT 0º elevation, lower band
subplot(3,4,5)
polarplot(mean([VBAPSpecError_U_L(1:split,73:96),VBAPSpecError_U_L(1:split,73)]),VBAPstyle)
ax=gca;
ax.FontSize=polarFontSize;
ax.Title.FontSize=titleFontSize;
ax.Title.String=['0' char(176) ' elevation, lower band (left)'];
ax.ThetaZeroLocation = zeroLocation;
ax.RLim=[0,5];
ax.RAxis.FontSize=tickFontSize;
hold all
polarplot(mean([AmbiSpecError_U_L(1:split,73:96),AmbiSpecError_U_L(1:split,73)]),Ambistyle)

%-RIGHT 0º elevation, lower band
subplot(3,4,6)
polarplot(mean([VBAPSpecError_U_R(1:split,73:96),VBAPSpecError_U_R(1:split,73)]),VBAPstyle)
ax=gca;
ax.FontSize=polarFontSize;
ax.Title.FontSize=titleFontSize;
ax.Title.String=['0' char(176) ' elevation, lower band (right)'];
ax.ThetaZeroLocation = zeroLocation;
ax.RLim=[0,5];
ax.RAxis.FontSize=tickFontSize;
hold all
polarplot(mean([AmbiSpecError_U_R(1:split,73:96),AmbiSpecError_U_R(1:split,73)]),Ambistyle)

%LEFT 0º elevation, upper band
subplot(3,4,7)
polarplot(mean([VBAPSpecError_U_L(split+1:bands,73:96),VBAPSpecError_U_L(split+1:bands,73)]),VBAPstyle)
ax=gca;
ax.FontSize=polarFontSize;
ax.Title.FontSize=titleFontSize;
ax.Title.String=['0' char(176) ' elevation, upper band (left)'];
ax.ThetaZeroLocation = zeroLocation;
ax.RLim=[0,7];
ax.RAxis.FontSize=tickFontSize;
hold all
polarplot(mean([AmbiSpecError_U_L(split+1:bands,73:96),AmbiSpecError_U_L(split+1:bands,73)]),Ambistyle)

%RIGHT 0º elevation, upper band
subplot(3,4,8)
polarplot(mean([VBAPSpecError_U_R(split+1:bands,73:96),VBAPSpecError_U_R(split+1:bands,73)]),VBAPstyle)
ax=gca;
ax.FontSize=polarFontSize;
ax.Title.FontSize=titleFontSize;
ax.Title.String=['0' char(176) ' elevation, upper band (right)'];
ax.ThetaZeroLocation = zeroLocation;
ax.RLim=[0,7];
ax.RAxis.FontSize=tickFontSize;
hold all
polarplot(mean([AmbiSpecError_U_R(split+1:bands,73:96),AmbiSpecError_U_R(split+1:bands,73)]),Ambistyle)

%LEFT 45º elevation, lower band
subplot(3,4,9)
polarplot(mean([VBAPSpecError_U_L(1:split,145:168),VBAPSpecError_U_L(1:split,145)]),VBAPstyle)
ax=gca;
ax.FontSize=polarFontSize;
ax.Title.FontSize=titleFontSize;
ax.Title.String=['45' char(176) ' elevation, lower band (left)'];
ax.ThetaZeroLocation = zeroLocation;
ax.RLim=[0,5];
ax.RAxis.FontSize=tickFontSize;
hold all
polarplot(mean([AmbiSpecError_U_L(1:split,145:168),AmbiSpecError_U_L(1:split,145)]),Ambistyle)

%RIGHT 45º elevation, lower band
subplot(3,4,10)
polarplot(mean([VBAPSpecError_U_R(1:split,145:168),VBAPSpecError_U_R(1:split,145)]),VBAPstyle)
ax=gca;
ax.FontSize=polarFontSize;
ax.Title.FontSize=titleFontSize;
ax.Title.String=['45' char(176) ' elevation, lower band (right)'];
ax.ThetaZeroLocation = zeroLocation;
ax.RLim=[0,5];
ax.RAxis.FontSize=tickFontSize;
hold all
polarplot(mean([AmbiSpecError_U_R(1:split,145:168),AmbiSpecError_U_R(1:split,145)]),Ambistyle)

%LEFT 45º elevation, upper band
subplot(3,4,11)
polarplot(mean([VBAPSpecError_U_L(split+1:bands,145:168),VBAPSpecError_U_L(split+1:bands,145)]),VBAPstyle)
ax=gca;
ax.FontSize=polarFontSize;
ax.Title.FontSize=titleFontSize;
ax.Title.String=['45' char(176) ' elevation, upper band (left)'];
ax.ThetaZeroLocation = zeroLocation;
ax.RLim=[0,7];
ax.RAxis.FontSize=tickFontSize;
hold all
polarplot(mean([AmbiSpecError_U_L(split+1:bands,145:168),AmbiSpecError_U_L(split+1:bands,145)]),Ambistyle)

%RIGHT 45º elevation, upper band
subplot(3,4,12)
polarplot(mean([VBAPSpecError_U_R(split+1:bands,145:168),VBAPSpecError_U_R(split+1:bands,145)]),VBAPstyle)
ax=gca;
ax.FontSize=polarFontSize;
ax.Title.FontSize=titleFontSize;
ax.Title.String=['45' char(176) ' elevation, upper band (right)'];
ax.ThetaZeroLocation = zeroLocation;
ax.RLim=[0,7];
ax.RAxis.FontSize=tickFontSize;
hold all
polarplot(mean([AmbiSpecError_U_R(split+1:bands,145:168),AmbiSpecError_U_R(split+1:bands,145)]),Ambistyle)