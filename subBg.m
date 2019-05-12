function [ subData ] = subBg( data,bgRange )
% subBg �Ե�baRange��Ϊ�����۳�,bgRange������һ����Χ����bgRange = 1:500;
% ��ȡѡȡ����ͼƬ���з�Χ���жϣ��Է��Ϸ�Χ����mean��ƽ����Ȼ����repmat���Ƶ�����ά�ȣ������
% data  ͼƬ���е���ά����
% bgRange    ��Ҫ����ı���ͼƬ���з�Χ
% subData   �۳��������ͼƬ���е���ά����

% Hai-Bo Chen �޸���2019/3/27
imNum = size(data,1);   %��Ӧdata�ĵ�һά������
if 0 < min(bgRange) && max(bgRange) <= imNum
    if length(bgRange) == 1
        backData = repmat(data(bgRange,:,:),imNum,1,1);   %����ͼƬ�����ظ�imNum�Σ���data����ά��һ�£�
    else
%         temp = mean(eval(['data(' num2str(min(bgRange)) ':' num2str(max(bgRange)) ',:,:)']));  %����ͼƬ������ƽ��
%         expression = ['mean','(data(bgRange,:,:))'];
%         temp = eval(expression);
        temp = mean(data(bgRange,:,:));     %����ͼƬ������ƽ��
        backData = repmat(temp,imNum,1,1);   %����ͼƬ�����ظ�imNum�Σ���data����ά��һ�£�
    end
    subData = data-backData;    %������ͼ��������ά����
else
    disp('��������ѡ�����');
    subData = [];
end
end