function Pie(source,labels,explode)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
figure               
set(gca,'FontSize',30)
p = pie(source,explode)
legend(labels)
ax=gca;
ax.FontSize=16;
colormap([1,1,1;0.75,0.75,0.75;0.75,0.75,0.75;0.5,0.5,0.5;0.5,0.5,0.5;0.25,0.25,0.25;0.25,0.25,0.25])
set(findobj(p,'type','text'),'fontsize',18)
end

