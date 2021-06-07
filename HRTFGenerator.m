function [HRTF] = HRTFGenerator(hrir_l,hrir_r);
%HRTFGENERATOR Converts CIPIC HRIR arrays to single 3D array of HRTF pairs
%   The resulting array stores 1250 two channel HRIR 200 sample arrays
%   HRIRs ascend from elevation -45 to 231 and across -80 to 80 azimuths. 
%   "hrir_l", "hrir_r" and "name" are arrays passed from the relevant
%   hrir_final.mat file.
%   Open the hrir_final.mat file for the required subject and run
%   ImpulseGenerator with the required arguments.
azimuths=[-80 -65 -55 -45:5:45 55 65 80];
elevations=-45+5.625*(0:49);
HRTFCount=1;

for ele = 1:50
    for azi = 1:25
        for s = 1:200
            HRTF(1,s,HRTFCount)=hrir_l(azi,ele,s);
            HRTF(2,s,HRTFCount)=hrir_r(azi,ele,s);
        end
        HRTFCount=HRTFCount+1;
    end
end

end