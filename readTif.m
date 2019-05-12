function [dataSet]=readTif(fileName)
%readTIF 
%detailed explanation goes here 
imNum=size(imfinfo(fileName),1);
siz=size(imread(fileName,1));
dataSet=zeros(imNum,siz(1),siz(2));
  for i=1:imNum
      data=imread(fileName,i);
      dataSet(i,:,:)=data;
  end
end