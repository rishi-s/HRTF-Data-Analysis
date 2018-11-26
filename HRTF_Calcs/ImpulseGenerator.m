function ImpulseGenerator(number,azi,ele,hrir_l,hrir_r,name)
%IMPULSEGENERATOR Creates required CIPIC HRIRs in stereo .wav form
% Takes six compulsory arguments.
% "number", "azi" and "ele" are user-defined.
% "hrir_l", "hrir_r" and "name" are arrays passed from the relevant
% hrir_final.mat file.
% Open the hrir_final.mat file for the required subject and run
% ImpulseGenerator with the required arguments.
azimuths=[-80 -65 -55 -45:5:45 55 65 80];
elevations=-45 + 5.625*(0:49);
hrir(1,1:200)=hrir_l(find(azimuths==azi),find(round(elevations)==ele),1:200);
hrir(2,1:200)=hrir_r(find(azimuths==azi),find(round(elevations)==ele),1:200);
audiowrite(strcat(name,'_impulse',int2str(number),'_',int2str(azi),'_',int2str(ele),'.wav'),hrir,44100,'BitsPerSample',64);
end

