data=[];  %随时间强度变化数据
J=[];  %电流密度
a= 2.25*10^(-6) ; %硅球粒子半径(m)
f=20; %振动频率（Hz）
e= 76*10^(-4) ; %电导率(S/m)
E0=max(J)*2*10^4/e ;%电场强度
y= 9*10^(-4); %溶液粘度
% I1=I0*e^(-X1/100);
% I2=I0*e^(-X2/100);
% X3=log(I1/I2)*100;  %计算振幅差（X2-X1）
for n=1:139
    I(n)= max(data(100*n-99:100*n))-min(data(100*n-99:100*n));
end
I0=400;     %不加电时的强度
x=-log((I0-I)/I0)*100;   %振动幅度(nm)
q=x*10^(-9)*12*(pi)^2*y*a*f/E0;
q1=q/(1.6*10^(-19));
t=linspace(0,139,139);
subplot(1,2,1)
plot(t,q,'.')
ylabel('Amount of charge (C)')
xlabel('Time (s)')
subplot(1,2,2)
plot(t,q1,'r.')
ylabel('Number of electrons (e)')
xlabel('Time (s)')
