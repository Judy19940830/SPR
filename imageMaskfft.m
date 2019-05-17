% Functions needed��
% Import image sequence:1.readTifSequence.m; 2.readMulTif.m; 
% Differential images��1.subBg.m; 2.adpmedian.m
% Import image mask or create mask: 1.showSlide.m
% Method 1: Amplitude spectrum of sampling area vs. bg area (using mask): 1.ROIMean.m

%% Import image sequence
%%%%% ѡ�񲢶�ȡ�������ŵ�ͼƬ���� %%%%%
clear;clc
[file,path] = uigetfile('*.tif');   %Ĭ�ϵ�ǰ�ļ��д��ļ�ѡ��Ի���ֻ����tif�ļ���
fileName = fullfile(path,file);    %ͼƬ���е��������ƣ�����·��
data = readTifSequence(fileName);  %��ȡ�����Ķ���ͼƬ��������,[imNum,row,column]
info = imfinfo(fileName);   %����ͼƬ���еĽṹ��
imNum = size(info,1);   %ͼƬ��������������
row = info(1).Height;   %��һ��ͼƬ�ĸ߶ȣ�������
column = info(1).Width; %��һ��ͼƬ�Ŀ�ȣ�������
clear info; %ɾ���й�ͼƬ�����ļ�����Ϣ

%%%%% ѡ�񲢶�ȡһ���ļ����µĶ���ͼƬ %%%%%%
% [file,path] = uigetfile('*.tif'); %Ĭ�ϵ�ǰ�ļ��д��ļ�ѡ��Ի���ֻ����tif�ļ���,��Ҫ�ǻ�ȡͼƬ�����ļ��е�·��
% myfolder = dir(fullfile(path,'*.tif'));  %����ͼƬ�����ļ����µ�tif����
% data = readMulTif(myfolder);  %��ȡһ���ļ����¶���ͼƬ

%% Differential images (subtract the first image and then wiener2 filtering)
%%%%% ͼƬ��������ά������ʽ���ڣ�filtData %%%%%
bgRange = 1; %ѡȡ��Ҫ����ı���ͼƬ���з�Χ�����űȵ�ѡȡ��һ�ŵ�Ч���ã�
subData = subBg(data,bgRange);  %�����������data��һά��ͼƬ����
subData(1,:,:) = subData(2,:,:);  %ʹ������ĵ�һ��ͼƬ��Ϊ0�����ں�����㴦��
clear data; %���ԭʼͼƬ�������ݣ��ͷ��ڴ�
% ��ͼƬ����ȥ��
filtData = zeros(imNum,row,column);
for ii = 1:imNum
    temp = squeeze(subData(ii,:,:)); 
    temp = wiener2(temp,[5,5]); %ά���˲�(�ʺ�ȥ����˹������
    temp = adpmedian(temp,7);  %����Ӧ��ֵ�˲�
    filtData(ii,:,:) = temp;
end
clear subData;  %������ͼƬ�������ݣ��ͷ��ڴ�

%%%%% ͼƬ������Ԫ��������ʽ���ڣ�image %%%%%
image = cell(imNum,1);  %����ͼƬ���еİ�Ԫ����
for ii = 1:imNum;
    image{ii} = squeeze(filtData(ii,:,:));
end

%% Import image mask or create mask
%%%%% ���ļ��е���imagej�����ɵ�mask %%%%%
% % ��ȡroiMask
% disp('Please choose a mask for sampling area')
% [file,path] = uigetfile('*.tif');   %Ĭ�ϵ�ǰ�ļ��д��ļ�ѡ��Ի���ֻ����tif�ļ���
% fileName = fullfile(path,file);    %maskͼƬ���������ƣ�����·��
% roiMask = logical(imread(fileName));  %��ȡ����maskͼƬ���ݲ�תΪ�߼�����
% % ��ȡbgMask
% disp('Please choose a mask for bg area')
% [file,path] = uigetfile('*.tif');   %Ĭ�ϵ�ǰ�ļ��д��ļ�ѡ��Ի���ֻ����tif�ļ���
% fileName = fullfile(path,file);    %maskͼƬ���������ƣ�����·��
% bgMask = logical(imread(fileName));  %��ȡ����maskͼƬ���ݲ�תΪ�߼�����

%%%%% ���ú�������mask %%%%%
% ��ʾͼ������
showSlide(filtData)

% ��ʾ�п�����ͼ�񲢴���mask
n = 2180;   % ����showSlide�۲쵽�������׿�����ͼƬ���
figure,subplot(3,1,1),imagesc(squeeze(filtData(n,:,:)))
impixelinfo
[roiMask,c1,r1] = roipoly();  %����ʽѡȡ�������ֵ�mask

% ����impixelinfo����Ϣ�����Ʊ���mask������
c2 = c1;   %������
r2 = r1-35;  %������
bgMask = roipoly(row,column,c2,r2);
% bgMask = poly2mask(c2,r2,row,column);
subplot(3,1,2),imagesc(roiMask)
subplot(3,1,3),imagesc(bgMask)

%% Method 1:  Amplitude spectrum of sampling area vs. bg area (using mask)
% ���Ӧmask����ͼƬ��ƽ��ǿ��
imageRoimean = zeros(imNum,1);
imageBgmean = zeros(imNum,1);
 for ii = 1:imNum; 
     imageRoimean(ii,1) = roiMean(image{ii}, roiMask);   %���������Ӧƽ��ǿ��
     imageBgmean(ii,1) = roiMean(image{ii}, bgMask);    %���������Ӧƽ��ǿ��
 end
 
 
 % ����ʱ��仯��ͼƬƽ��ǿ����fft,����Ƶ��ͼ
Nfft = 2048; %ָ��ͼƬƽ��ǿ�ȵ����г��ȣ�2����
Fs = 100; %Sampling frequency
Fn = (0:Nfft-1)/Nfft*Fs; %frequency sequence
y1 = fft(imageRoimean,Nfft);
mag1 = abs(y1);
figure
plot(Fn(1:Nfft/2),mag1(1:Nfft/2)*2/Nfft);  %���������Ӧƽ��ǿ����Ƶ��
xlabel('Frequency/Hz');ylabel('Amplitude');
title('��ѡroi����ƽ��ǿ��Ƶ��ͼ');
hold on
y2 = fft(imageBgmean,Nfft);
mag2 = abs(y2);
plot(Fn(1:Nfft/2),mag2(1:Nfft/2)*2/Nfft);  %���������Ӧƽ��ǿ����Ƶ��      
set(gca, 'linewidth', 1.5)
legend('ROI', 'Background')
hold off

%% Method 1:Phase spectrum of sampling area vs. bg area (using mask)
ph1 = 2*angle(y1(1:Nfft/2));  %����angle�������ÿ����ĽǶ�
ph1 = ph1*180/pi;  %�ɻ���ת���ɽǶ�
plot(Fn(1:Nfft/2),ph1(1:Nfft/2),'r');
xlabel('Ƶ��/hz'),ylabel('���'),title('��λ��');
grid on
hold on
ph2 = 2*angle(y2(1:Nfft/2));  %����angle�������ÿ����ĽǶ�
ph2 = ph2*180/pi;  %�ɻ���ת���ɽǶ�
plot(Fn(1:Nfft/2),ph2(1:Nfft/2),'b');
hold off


%% Method 2: FFT analysis of multiple pixels
% ����άͼƬ������������ͼƬ����������fft
Nfft = 512; %ָ��ͼƬ�����г��ȣ�2����
Fs = 106; %Sampling frequency
Fn = (0:Nfft-1)/Nfft*Fs; %frequency sequence
Y = fft(filtData,Nfft,1);  %����ͼƬ���г��ȷ�����fft
Mag = abs(Y);

%ѡȡ������ص��ƽ��ǿ�Ȼ�Ƶ��ͼ
a = cell(Nfft,1); b1 = zeros(Nfft,1);
m = length(find(roiMask(:)~=0));  %��0���ظ���
for ii = 1:Nfft
    a{ii} = (squeeze(Mag(ii,:,:))).*roiMask;  %ѡ���������ǰ���Ǹߣ������ǿ�
    b1(ii) = sum(a{ii}(:))./m;        %���������ƽ��ǿ��
end
figure
plot(Fn(1:Nfft/2),b1(1:Nfft/2)*2/Nfft);  %��ѡ�����Ӧƽ��ǿ����Ƶ��
xlabel('Frequency/Hz');ylabel('amplitude');
title('��ѡ����ƽ��ǿ��Ƶ��ͼ');