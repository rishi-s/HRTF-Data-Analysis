function [ErrorStats, X, Y] = Unsigned_Error_Perc(HRIRValues,HRIRMatrix,SystemValues,SystemMatrix,title)
%Calculates unsigned error for ITD or ILD comparison.
ErrorMatrix = NaN(10,24);
X = 0+15*(0:23);
Y = 90-15*(0:9);

%loop throught ITD values to calculate mean error
for n=1:187
      error=(SystemValues(n,1)+1)-(HRIRValues(n,1)+1);
      if error ==0
          unsignedError(n,1)=0;
      else
          unsignedError(n,1)=error/(HRIRValues(n,1)+1)*-100;
      end
      if unsignedError(n,1) < 0
          unsignedError(n,1)=unsignedError(n,1)*-1;
      end
end


%loop through the ITD matrix to assign values to the correct cells
for i=1:10
    for j=1:24
      value=(SystemMatrix(i,j)+1)-(HRIRMatrix(i,j)+1);
      if value==0;
          ErrorMatrix(i,j)=0;
      else
          ErrorMatrix(i,j)=value/(HRIRMatrix(i,j)+1)*-100;
      end
      if ErrorMatrix(i,j) < 0
          ErrorMatrix(i,j)=ErrorMatrix(i,j)*-1;
      end
      
    end
end

heatmap(X,Y,ErrorMatrix,'Title',title,'XLabel','Azimuth (º)','YLabel','Elevation (º)','FontSize',16,'Colormap',cool,'ColorLimits',[0,300]);
ErrorStats(1,1)=mean(unsignedError)

ErrorStats(1,2)=std(unsignedError)


