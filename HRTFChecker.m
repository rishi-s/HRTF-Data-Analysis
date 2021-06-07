function [collatedValue,originalValue] = HRTFChecker(channel,sample,HRIR,subject,hrir_l,hrir_r)
%HRTFCHECKER Verifies the structure of a CIPIC HRTFGenerator output.
%   Takes four compulsory inputs (channel, sample, HRIR, subject).
collatedValue = subject(channel,sample,HRIR)
if channel==1
    ear=hrir_l;
else ear=hrir_r;
end
if mod(HRIR,25)==0
    azi=25;
else azi=mod(HRIR,25);
end
originalValue = ear(azi,ceil(HRIR/25),sample)
end