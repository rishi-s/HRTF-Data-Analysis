function [ErrorStats, ErrorLabels, X, Y] = Unsigned_Error_Calc(HRIRMatrix,SystemMatrix,title)
%Calculates unsigned error for ITD or ILD comparison.
ErrorMatrix = NaN(10,24);
X = 0+15*(0:23);
Y = 90-15*(0:9);
positionCounter=1;
unsignedErrors=zeros(187,1);

%loop through the ITD matrix to assign values to the correct cells
for i=1:10
    for j=1:24
      %Find the difference between the system and the HRIR positions
      value=SystemMatrix(i,j)-HRIRMatrix(i,j);
      if value >= 0
          ErrorMatrix(i,j)=value;
      %Convert negative values to unsigned
      else
          ErrorMatrix(i,j)=value*-1;
      end
    %Log unsigned error to array
    unsignedErrors(positionCounter,1)=ErrorMatrix(i,j)
    positionCounter=positionCounter+1;
    end
end


figure
heatmap(X,Y,ErrorMatrix,'XLabel','Azimuth (°)','YLabel','Elevation (°)','FontSize',16,'Colormap',cool,'ColorLimits',[0,550]);
ErrorLabels=strings(1,3);
ErrorLabels(1,1)='All_Locs_Mean';
ErrorLabels(1,2)='All_Locs_StD';
ErrorLabels(1,3)='Front_Mean';
ErrorLabels(1,4)='Front_StD';
ErrorLabels(1,5)='Lower_Mean';
ErrorLabels(1,6)='Lower_StD';
ErrorLabels(1,7)='Mid_Mean';
ErrorLabels(1,8)='Mid_StD';
ErrorLabels(1,9)='Upper_Mean';
ErrorLabels(1,10)='Upper_StD';
ErrorStats(1,1)=mean(unsignedErrors,'omitnan');
ErrorStats(1,2)=std(unsignedErrors,'omitnan');
frontalZone(1:41,1)=unsignedErrors(1:41,1);
frontalZone(42:73,1)=unsignedErrors(156:187,1);
ErrorStats(1,3)=mean(frontalZone,'omitnan');
ErrorStats(1,4)=std(frontalZone,'omitnan');
ErrorStats(1,5)=mean(ErrorMatrix(10,1:24));
ErrorStats(1,6)=std(ErrorMatrix(10,1:24));
ErrorStats(1,7)=mean(ErrorMatrix(7,1:24));
ErrorStats(1,8)=std(ErrorMatrix(7,1:24));
ErrorStats(1,9)=mean(ErrorMatrix(4,1:24));
ErrorStats(1,10)=std(ErrorMatrix(4,1:24));