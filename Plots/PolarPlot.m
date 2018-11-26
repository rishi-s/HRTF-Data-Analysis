function PolarPlot(VBAPincrements,VBAPvalues,FOAincrements,FOAvalues)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
polarplot(VBAPincrements,VBAPvalues,'ob','MarkerSize',25)
ax=gca;
ax.FontSize=16;
ax.ThetaZeroLocation = 'top';
ax.RLim=[-90,90];
%ax.RTick=[-90 -75 -60 -45 -30 -15 0 15 30 45 60 75 90];
ax.RTick=[-90 -45 0 45 90];
ax.RDir='reverse';
ax.RAxis.FontSize=18;
ax.RAxis.Label.String='Elevation (º)';
ax.RAxis.Label.Position=[-25 -25];
ax.RAxis.Label.FontWeight='bold';
ax.RAxis.Label.FontSize=24;
ax.RAxis.Label.Rotation=75;
ax.ThetaAxis.FontSize=24;
ax.ThetaAxis.Label.String='Azimuth (º)';
ax.ThetaAxis.Label.Position=[15 -110];
ax.ThetaAxis.Label.FontWeight='bold';
hold on
polarplot(FOAincrements,FOAvalues,'xr','MarkerSize',25)
hold off
end

