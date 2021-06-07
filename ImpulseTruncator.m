function [data,Fs] = ImpulseTruncator()
%IMPULSEGENERATOR Shortens an HRTF set stored as 512s stereo .wav files to 
% 256s (using 10 sample fade-out).
attenuator = [0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1,0.0]; %trunc fade scalar
myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'**/*.wav')); %gets all .wav files into struct
folders = unique({myFiles.folder})
for j =1:length(folders)
    mkdir(strcat(folders{j},'_trunc'))
end


% Loop through all files found and log their name and path
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  directory = myFiles(k).folder;
  fullFileName = fullfile(directory, baseFileName);
  [data,Fs] = audioread(fullFileName);

  % Fade the last 10 samples
  for l = 1:10
      data(246+l,1)=data(246+l,1)*attenuator(l);
      data(246+l,2)=data(246+l,2)*attenuator(l);
  truncated  = data(1:256,:);
  end
  

    
  %Write the files
  audiowrite(fullfile(strcat(directory,'_trunc'),baseFileName),truncated,Fs);

end



