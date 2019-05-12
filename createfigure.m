function createfigure(data1, X1, Y1)
%CREATEFIGURE(DATA1, X1, Y1)
%  DATA1:  histogram data
%  X1:  x 数据的矢量
%  Y1:  y 数据的矢量

%  由 MATLAB 于 24-Aug-2018 16:01:59 自动生成

% 创建 figure
figure;

% 创建 axes
axes1 = axes;
hold(axes1,'on');

% 创建 histogram
histogram(data1,'DisplayName','SNP','Normalization','probability',...
    'BinWidth',0.0043);

% 创建 plot
plot(X1,Y1,'DisplayName','Lognormal Fitting','LineWidth',3);

% 创建 xlabel
xlabel('Intensity(a.u.)');

% 创建 ylabel
ylabel('Probability');

% 取消以下行的注释以保留坐标轴的 X 范围
% xlim(axes1,[0 0.05]);
box(axes1,'on');
% 设置其余坐标轴属性
set(axes1,'FontSize',30);
% 创建 legend
legend(axes1,'show');

