function [x] = ImpulseGeneratorCompact(ImpulsesMatrix)
%
% function [x] = readhrtf(elev,azim,select)
%
% elev is elevation from -40 to 90 degrees
% azim is azimuth from 0 to 180 degrees
% select is:
%	'L' use full data from left pinna
%	'R' use full data from right pinna
%	'H' use compact data
% Returns stereo symmetrical hrtf in first two rows of
% x such that left is first row, right is second row.
%
% Bill Gardner
% Copyright 1995 MIT Media Lab. All rights reserved.
%

%
% Root directory for Macintosh or UNIX. Put your own in here.
%
	root = '..';
	dir_ch = '/';
%
% check arguments
%
%azim = round(azim);
%if ((azim < 0) | (azim > 180))
%	error('azimuth must be between 0 and 180 degrees');
%end
%if ((elev < -40) | (elev > 90))
%	error('elevation must be between -40 and 90 degrees');
%end

collection='MIT_Kemar';                     %collection name
subject='normal pinnae';                    %get subject ID
impulseNumber=ImpulsesMatrix(:,1);          %IDs of required HRIRs
azi=ImpulsesMatrix(:,4);                    %azimuths of required HRIRs
ele=ImpulsesMatrix(:,5);                    %elevations of required HRIRs
impulses=size(ImpulsesMatrix,1);            %number of HRIRs required
aziLabel=ImpulsesMatrix(:,2);               %SOFA standard azi for HRIRs
eleLabel=ImpulsesMatrix(:,3);               %SOFA standard ele for HRIRs

% Create name for collection
folderName=strcat(int2str(128),'s_Set_(',collection,'_',subject,')');

% Make directory for collection
mkdir(folderName)



for i=1:impulses
    
    %define azimuth flip
    flip_azim = 360 - azi(i);
    if (flip_azim == 360)
        flip_azim = 0;
    end
    
    ext = '.dat';
    if (azi <=180)
        pathname = hrtfpath(root,dir_ch,'compact','H',ext,ele(i),azi(i));
        tmp = readraw(pathname);
        x(1,:) = single(tmp(1:2:length(tmp)));
        x(2,:) = single(tmp(2:2:length(tmp)));
    elseif (azi>180)
        pathname = hrtfpath(root,dir_ch,'compact','H',ext,ele(i),flip_azim);
        tmp = readraw(pathname);
        x(1,:) = single(tmp(2:2:length(tmp)));
        x(2,:) = single(tmp(1:2:length(tmp)));    
    end
end

%Write the files
audiowrite(strcat(folderName,'/','impulse',int2str(impulseNumber(i)),...
    '_L_',int2str(azi(i)),'_', int2str(ele(i)),'.wav'),x(1,:),44100);
audiowrite(strcat(folderName,'/','impulse',int2str(impulseNumber(i)),...
    '_R_',int2str(azi(i)),'_', int2str(ele(i)),'.wav'),x(2,:)hrir_r,44100);
