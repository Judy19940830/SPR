function [ data ] = readTifSequence( fileName )
% readTifSequence   读取单个多张的tif图片序列（利用imfinfo得到图片文件信息，用imread循环读取图片序列数据）
% fileName  包含多张tif图片的图片序列文件名
% data      读取的图片序列的数据

% Hai-Bo Chen 创建于2019/3/26
%fileName = 'Result of 1508_pike_100fps_120mA_50mMKNO3_Ag40nm_dilution200_it0.6V_5.tif-1.tif';%单个tif图片序列
info = imfinfo(fileName);   %返回图片序列的结构体
imNum = size(info,1);   %图片张数（构架数）
row = info(1).Height;   %第一张图片的高度（行数）
column = info(1).Width; %第一张图片的宽度（列数）
data = zeros(imNum,row,column);  %预设图片序列三维数组
for ii = 1:imNum
    temp = imread(fileName,ii);  %读取第ii张图片的数据
    data(ii,:,:) = temp;
end

end