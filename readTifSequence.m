function [ data ] = readTifSequence( fileName )
% readTifSequence   ��ȡ�������ŵ�tifͼƬ���У�����imfinfo�õ�ͼƬ�ļ���Ϣ����imreadѭ����ȡͼƬ�������ݣ�
% fileName  ��������tifͼƬ��ͼƬ�����ļ���
% data      ��ȡ��ͼƬ���е�����

% Hai-Bo Chen ������2019/3/26
%fileName = 'Result of 1508_pike_100fps_120mA_50mMKNO3_Ag40nm_dilution200_it0.6V_5.tif-1.tif';%����tifͼƬ����
info = imfinfo(fileName);   %����ͼƬ���еĽṹ��
imNum = size(info,1);   %ͼƬ��������������
row = info(1).Height;   %��һ��ͼƬ�ĸ߶ȣ�������
column = info(1).Width; %��һ��ͼƬ�Ŀ�ȣ�������
data = zeros(imNum,row,column);  %Ԥ��ͼƬ������ά����
for ii = 1:imNum
    temp = imread(fileName,ii);  %��ȡ��ii��ͼƬ������
    data(ii,:,:) = temp;
end

end