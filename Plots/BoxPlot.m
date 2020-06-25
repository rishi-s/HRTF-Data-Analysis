function BoxPlot(parameter,groups,lowerLimit,upperLimit,graphLabel,group1Label,group2Label,xDirection)
%BOXPLOTSTIME Box plot with defined lines and colours
%   Detailed explanation goes here
purple=[0.412, 0.094, 0.247]
orange=[0.929, 0.400, 0.168]
blue=[0.001, 0.634, 1.000]
grey=[0.350, 0.350, 0.350]
figure('OuterPosition', [0 0 700 700],'Resize','on','Renderer','painters','RendererMode','manual','Color','w');
thisPlot = boxplot(parameter,groups,'Notch','off','ExtremeMode','compress','OutlierSize',12);
title(graphLabel,'FontSize',37);
set(thisPlot,'LineWidth',1.75);
set(findobj(gcf,'tag','Median'), 'Color', orange, 'LineWidth',3);
set(findobj(gcf,'tag','Box'), 'Color', purple, 'LineWidth', 2);
set(findobj(gcf,'tag','Upper Whisker'), 'Color', blue, 'LineWidth', 3);
set(findobj(gcf,'tag','Upper Adjacent Value'), 'Color', blue, 'LineWidth', 3);
set(findobj(gcf,'tag','Lower Whisker'), 'Color', blue, 'LineWidth', 3);
set(findobj(gcf,'tag','Lower Adjacent Value'), 'Color', blue, 'LineWidth', 3);
set(findobj(gcf,'tag','Outliers'), 'Color', orange);
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

