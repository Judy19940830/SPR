%% Import image sequence
%%%%% 选择并读取单个多张的图片序列 %%%%%
clear;clc
[file,path] = uigetfile('*.tif');   %默认当前文件夹打开文件选择对话框（只包含tif文件）
fileName = fullfile(path,file);    %图片序列的完整名称，包含路径
data = readTifSequence(fileName);  %读取单个的多张图片序列数据,[imNum,row,column]
info = imfinfo(fileName);   %返回图片序列的结构体
imNum = size(info,1);   %图片张数（构架数）
row = info(1).Height;   %第一张图片的高度（行数）
column = info(1).Width; %第一张图片的宽度（列数）
clear info; %删除有关图片序列文件的信息

%% Differential images (subtract the first image and then wiener2 filtering)
%%%%% 图片序列以三维数组形式存在：filtData %%%%%
bgRange = 1; %选取需要差减的背景图片序列范围（多张比单选取第一张的效果好）
subData = subBg(data,bgRange);  %差减掉背景，data第一维是图片张数
subData(1,:,:) = subData(2,:,:);  %使差减掉的第一张图片不为0，便于后面计算处理
clear data; %清除原始图片序列数据，释放内存
% 对图片序列去噪
filtData = zeros(imNum,row,column);
for ii = 1:imNum
    temp = squeeze(subData(ii,:,:)); 
    temp = wiener2(temp,[5,5]); %维纳滤波(适合去除高斯噪声）
    temp = adpmedian(temp,7);  %自适应中值滤波
    filtData(ii,:,:) = temp;
end
% clear subData;  %清除差减图片序列数据，释放内存

%%%%% 图片序列以元胞数组形式存在：image %%%%%
image = cell(imNum,1);  %构建图片序列的胞元数组
for ii = 1:imNum;
    image{ii} = squeeze(filtData(ii,:,:));
end

% 显示图像序列
figure(1),showSlide(subData),figure(2),showSlide(filtData)

% 保存图片
for ii = 1:size(filtData,1)
    temp = squeeze(filtData(ii,:,:));
    temp1 = uint16(temp);
    imwrite(temp1,'fitDatafft.tif','WriteMode','append','Resolution',96)
end