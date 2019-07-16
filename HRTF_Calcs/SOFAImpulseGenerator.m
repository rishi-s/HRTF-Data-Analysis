function SOFAImpulseGenerator(SofaFile,ImpulsesMatrix)
%SOFAIMPULSEGENERATOR Creates required HRIRs in mono .wav pairs from SOFA
%format. Takes two compulsory arguments (SOFAFile and ImpulsesMatrix).

hrtf=SofaFile.Data.IR;                      %access IR data
length=size(hrtf,3);                        %define length of IRs
azimuths=SofaFile.SourcePosition(:,1);      %get measured azimuths
elevations=SofaFile.SourcePosition(:,2);    %get measured elevations
collection=SofaFile.GLOBAL_DatabaseName;    %get collection name
subject=SofaFile.GLOBAL_ListenerShortName;  %get subject ID
impulseNumber=ImpulsesMatrix(:,1);          %IDs of required HRIRs
azi=ImpulsesMatrix(:,2);                    %azimuths of required HRIRs
ele=ImpulsesMatrix(:,3);                    %elevations of required HRIRs
impulses=size(ImpulsesMatrix,1);            %number of HRIRs required

% Create name for collection
folderName=strcat(int2str(length),'s_Set_(',collection,'_',subject,')');

% Make directory for collection
mkdir(folderName)

%Loop impulse list to generate HRIRs 
for i=1:impulses
    %Find index by matching rounded azi/ele measurements to required
    %values
    index=find(round(azimuths)==azi(i) & round(elevations)==ele(i))
    %Create the arrays
    hrir_l(1:length)=single(hrtf(index,1,1:length));
    hrir_r(1:length)=single(hrtf(index,2,1:length));
    %Write the files
    audiowrite(strcat(folderName,'/','impulse',int2str(impulseNumber(i)),...
        '_L_',int2str(azi(i)),'_', int2str(ele(i)),'.wav'),hrir_l,44100);
    audiowrite(strcat(folderName,'/','impulse',int2str(impulseNumber(i)),...
        '_R_',int2str(azi(i)),'_', int2str(ele(i)),'.wav'),hrir_r,44100);
    audiowrite(strcat(folderName,'/','impulse',int2str(impulseNumber(i)),...
        '_',int2str(azi(i)),'_', int2str(ele(i)),'.wav'),transpose([hrir_l; hrir_r]),44100);
end
end
