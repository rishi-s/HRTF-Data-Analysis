function ImpulseGenerator(name,HRTF_L,HRTF_R,ImpulsesMatrix)
%IMPULSEGENERATOR Creates required HRIRs in mono .wav pairs from CIPIC
%format. Takes three compulsory arguments (name, hrir_l, hrir_r and ImpulsesMatrix).


length=size(HRTF_L,3);                      %define length of IRs
azimuths=[-80 -65 -55 -45:5:45 55 65 80]   %measured azimuths
elevations=-45 + 5.625*(0:49)              %measured elevations
collection='CIPIC';                         %collection name
subject=name;                               %get subject ID
impulseNumber=ImpulsesMatrix(:,1);          %IDs of required HRIRs
azi=ImpulsesMatrix(:,4);                    %azimuths of required HRIRs
ele=ImpulsesMatrix(:,5);                    %elevations of required HRIRs
impulses=size(ImpulsesMatrix,1);            %number of HRIRs required
aziLabel=ImpulsesMatrix(:,2);               %SOFA standard azi for HRIRs
eleLabel=ImpulsesMatrix(:,3);               %SOFA standard ele for HRIRs

% Create name for collection
folderName=strcat(int2str(length),'s_Set_(',collection,'_',subject,')');

% Make directory for collection
mkdir(folderName)

for i=1:impulses
    %Find spherical co-ordinate indices
    aziIndex=find(azimuths==azi(i))
    eleIndex=find(round(elevations)==ele(i))
    %Create the arrays
    hrir_l(1:length)=single(HRTF_L(aziIndex,eleIndex,1:length));
    hrir_r(1:length)=single(HRTF_R(aziIndex,eleIndex,1:length));
    %Write the files
    audiowrite(strcat(folderName,'/','impulse',int2str(impulseNumber(i)),...
        '_L_',int2str(aziLabel(i)),'_', int2str(eleLabel(i)),'.wav'),...
        hrir_l,44100);
    audiowrite(strcat(folderName,'/','impulse',int2str(impulseNumber(i)),...
        '_R_',int2str(aziLabel(i)),'_', int2str(eleLabel(i)),'.wav'),...
        hrir_r,44100);
end

