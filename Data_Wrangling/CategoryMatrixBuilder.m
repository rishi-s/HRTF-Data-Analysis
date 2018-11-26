

for i=1:22
    y = i * ones(1,6);
    plot(MatrixChart(i,1:6),y, 'k*', 'MarkerSize', 15, 'LineWidth', 3);
end



% Set up axes.
xlim([0.5, 6.5]);
ylim([0, 23]);
ax = gca;
ax.YTick = [1:22];
ax.XTick = [1,2,3,4,5,6];
ax.XTickLabels = {'LISTEN 1014','LISTEN 1022','LISTEN 1028','CIPIC 12','CIPIC 15','CIPIC 58'};
grid off;
hold on;