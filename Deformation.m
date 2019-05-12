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
% clear subData;  %������ͼƬ�������ݣ��ͷ��ڴ�

%%%%% ͼƬ������Ԫ��������ʽ���ڣ�image %%%%%
image = cell(imNum,1);  %����ͼƬ���еİ�Ԫ����
for ii = 1:imNum;
    image{ii} = squeeze(filtData(ii,:,:));
end

% ��ʾͼ������
figure(1),showSlide(subData),figure(2),showSlide(filtData)

% ����ͼƬ
for ii = 1:size(filtData,1)
    temp = squeeze(filtData(ii,:,:));
    temp1 = uint16(temp);
    imwrite(temp1,'fitDatafft.tif','WriteMode','append','Resolution',96)
end