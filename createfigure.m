function createfigure(data1, X1, Y1)
%CREATEFIGURE(DATA1, X1, Y1)
%  DATA1:  histogram data
%  X1:  x ���ݵ�ʸ��
%  Y1:  y ���ݵ�ʸ��

%  �� MATLAB �� 24-Aug-2018 16:01:59 �Զ�����

% ���� figure
figure;

% ���� axes
axes1 = axes;
hold(axes1,'on');

% ���� histogram
histogram(data1,'DisplayName','SNP','Normalization','probability',...
    'BinWidth',0.0043);

% ���� plot
plot(X1,Y1,'DisplayName','Lognormal Fitting','LineWidth',3);

% ���� xlabel
xlabel('Intensity(a.u.)');

% ���� ylabel
ylabel('Probability');

% ȡ�������е�ע���Ա���������� X ��Χ
% xlim(axes1,[0 0.05]);
box(axes1,'on');
% ������������������
set(axes1,'FontSize',30);
% ���� legend
legend(axes1,'show');

