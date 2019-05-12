%%
num=10000;%�����ϲ�����
n=6;%�ž۸���
data=D0;%δ�ž۵�����
BinWidth=0.005;
delta=0.001;
x=0:delta:0.45;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear b ytt
parmhat = lognfit(data);
b=lognrnd(parmhat(1),parmhat(2),num,n);
% b=lognrnd(0.1*2,0.1*6,num,n);%�����ֲ����ɵ�ʾ��

y = lognpdf(x,parmhat(1),parmhat(2))*BinWidth;%�������ֲ�����

for i=2:n
    b(:,i)=b(:,i)+b(:,i-1);
end
figure;
hold on
for i=1:n
%     yt(:,i)=interp1(x*i,y/i,x);%�ֲ������������
    t=histogram(b(:,i));
    t.Normalization = 'probability';
    t.BinWidth = BinWidth;
    parmhat(i,:) = lognfit(b(:,i));
%     ytt(:,i) = lognpdf(x,parmhat(i,1),parmhat(i,2))*BinWidth;%���ž۷ֲ�
    ytt(:,i) = lognpdf(x,parmhat(i,1),parmhat(i,2));%���ž۷ֲ�
end
hold off
% plot(x,ytt);
plot(x,ytt/sum(ytt(:,1)));

%%

sample=D1;%�ž۵�����
nBins=10;%������
%%%%%%%%%%%%%%%
figure
h=histogram(sample,nBins);
hold on
xq=(h.BinLimits(1)+h.BinWidth/2:h.BinWidth:h.BinLimits(2))';%��ɢ�����x
target=(h.Values)'/sum(h.Values);
xq1=xq(1)-h.BinWidth;
while xq1>0
    xq=[xq1;xq];
    xq1=xq(1)-h.BinWidth;
end
target=[zeros(length(xq)-length(target),1);target];
clear vv v yttD
for i=1:n
    temp=interp1(x,ytt(:,i),xq);
    yttD(:,i)=temp/sum(temp);
end
percentage=lsqnonneg(yttD,target);
percentage=percentage/sum(percentage);


figure
sv=zeros(size(y));
for i=1:n
    vv(:,i)=ytt(:,i)*percentage(i);
end
sv=sum(vv,2);
vv=vv/sum(sv)*h.BinWidth/delta;
sv=sv/sum(sv)*h.BinWidth/delta;
%%
plot(x,vv,'LineWidth',2);
hold on
plot(x,sv,'LineWidth',2);
xlabel('Intensity(a.u.)')
ylabel('Probability')
legend({'SNP fit','2 NPs fit','3 NPs fit','4 NPs fit','5 NPs fit','6 NPs fit','Aggregation NPs'},'FontSize',15);
hold off
set(gca,'xlim',[0 h.BinLimits(2)+h.BinWidth]);
set(gca,'FontSize',20,'LineWidth',1);


figure
t=histogram(sample,nBins);
t.Normalization = 'probability';
hold on
plot(x,sv,'LineWidth',2);
xlabel('Intensity(a.u.)')
ylabel('Probability')
legend('NPs','Fitting')
% plot(f1(:,1),sv/max(sv)*max(h.Values));
hold off
set(gca,'xlim',[0 h.BinLimits(2)+h.BinWidth]);
set(gca,'FontSize',20,'LineWidth',1);


figure
bar(percentage)
xlabel('Number')
ylabel('Probability')
set(gca,'FontSize',20,'LineWidth',1);