function ComboPlot(parameter,groups,lowerLimit,upperLimit,graphLabel)
%COMBOPLOT Combination plot of bar and line for two data points
%   Detailed explanation goes here
figure('OuterPosition', [0 0 700 700],'Resize','on','Renderer','painters','RendererMode','manual','Color','w');
thisPlot = bar(re);
title(graphLabel,'FontSize',37);
set(thisPlot,'LineWidth',1.75);
set(gca,'FontSize',24,'FontName', 'Helvetica')
ax=gca;
ax.LineWidth = 1.25;
set(ax,'xticklabel',{group1Label,group2Label})
ax.Box = 'off'
ax.Color = 'w'
ax.XColor = 'k'
ax.XColorMode = 'manual'
ax.YColor = 'k'
ax.YColorMode = 'manual'
ax.XDir = xDirection
ax.YLim = [lowerLimit upperLimit]
ax.YGrid = 'on'
ax.YAxis.LineWidth=2.5
ax.XAxis.LineWidth=2.5
ax.XAxis.Label.String = 'First Language';
ax.XAxis.Label.FontWeight = 'bold';
ax.YAxis.Label.String = 'Responses given (out of 6)';
ax.YAxis.Label.FontWeight = 'bold';
end

