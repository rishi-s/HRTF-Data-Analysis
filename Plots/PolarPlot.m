function PolarPlot(speakers,music,speech,labels)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
figure
set(gca,'FontSize',30)
legend(labels)
polarplot(deg2rad(speakers(:,1)-70),speakers(:,2),'ob','MarkerSize',23,'LineWidth',2)
ax=gca;
ax.FontSize=16;

ax.LineWidth = 2;
ax.GridAlpha = 0.25;
ax.ThetaZeroLocation = 'top';
ax.RLim=[-45,90];
ax.RTick=[-90 -75 -60 -45 -30 -15 0 15 30 45 60 75 90];
ax.RTick=[-90 -45 0 45 90];
ax.RDir='reverse';
ax.RAxis.FontSize=18;
ax.RAxisLocation = 315
ax.RAxis.Label.String='Elevation (º)';
ax.RAxis.Label.Position=[330 1];

ax.RAxis.Label.FontWeight='bold';
ax.RAxis.Label.FontSize=24;
ax.RAxis.Label.Rotation=60;
ax.ThetaAxis.FontSize=18;
ax.ThetaAxis.Label.String='Azimuth (º)';
ax.ThetaAxis.Label.Position=[20 -55];
ax.ThetaAxis.Label.FontWeight='bold';
ax.ThetaAxis.Label.Margin=200;
hold on
polarplot(deg2rad(music(:,1)),music(:,2),'*r','MarkerSize',20,'LineWidth',2)
for i=1:5
    polarplot(deg2rad(speech(i,1)),speech(i,2),'Marker','+','Color',[1 i/5-0.2 i/5-0.2],'MarkerSize',(20),'LineWidth',2)
end


hold off
end

