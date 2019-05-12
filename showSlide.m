function [fig,option] = showSlide(varargin)
% showSlide.m     %显示图片序列的图像及强度随时间的变化
% varargin        %函数中输入的可选参数

% Hai-Bo Chen 修改于2019-3-6
option.func = @imagesc;       %函数句柄
option.cType = 0;
option.showInts = 1;
option.plotInOne = 1;
option.xaxis = nan;
option.yaxis = nan;
option.isGetMovie = 0;
try
    option.figPosition = get(gcf,'position');
catch
end
[fig] = showSlideCore(option,varargin);
end

%%
function [fig] = showSlideCore(option,varargin)
% showSlideCore.m   点击图片位置，显示该位置上对应的图片序列的强度随时间的变化
% showInts 1, click to get intensities;0, only show data
% if show Ints, right click on the bottom fig to show the data with the intensity you clicked.
% plotInOne 1,plot Ints in one figure; 0, plot in corresponded figures
% cType    0, max not fixed;-1, fix max with the max of the data; n, fix max with n
% func function to draw

% Hai-Bo Chen 修改于2019-3-10
fig = figure;

try
    set(fig,'position',option.figPosition);
catch
end
data = varargin{1};
option.subM = option.showInts+1;     %subplot中的行数
option.subN = length(data);         %subplot中的张数
option.listData = 1;
for ii = 1:length(data)
    temp = squeeze(data(ii,:,:));
    siz(ii,:) = size(temp);  %data是胞元数组？    
end
for ii = 1:length(data)
    if sum(abs(siz(ii,:)-siz(1,:))) ~= 0
        disp('Size mismatch');
        disp(num2str(siz));
        option.showInts = 0;
        break;
    end
end
if length(option.cType) == 1
    if option.cType == -1
        for ii = 1:length(data)
            option.cType(ii) = max(max(max(data{ii})));
        end
    else
        option.cType = option.cType*ones(1,length(data));
    end
end
if isnan(option.xaxis)
    option.yaxis = 1:size(data{1},2);% y轴即dim2；而dim3是x轴
    option.xaxis = 1:size(data{1},3);
end

global px py slide 
px = 1;
py = 1;
slide = 1;
drawAll(data,option);
% num = size(data{1},1);
% obj = uicontrol('units','normalized','Style','slider','pos',[0 0 1 .05],...
%     'min',1,'max',num,'value',1,...
%     'sliderstep',[1/num,1/num],...
%     'callback',@(obj,x,event)uiCallback(round(get(obj,'value')),data,option));
% option.obj = obj;
set(gcf,'WindowButtonDownFcn',{@buttonDownFcn,data,option});
set(gcf,'WindowScrollWheelFcn',{@scrollWheelFcn,data,option});
if  option.isGetMovie == 1
    getMovie(data,option);
end
end

% function uiCallback(i,data,option)
% global slide
% slide=i;
% drawAll(data,option);
% end

function scrollWheelFcn(src,event,data,option)
global slide
slide = event.VerticalScrollCount + slide;
if slide < 1
    slide = 1;
elseif slide > size(data{1},1);
    slide = size(data{1},1);
end
try
    drawAll(data,option);
    drawPlot(data,option);
catch
    disp('Position Error, or right/left click?');
end
end

function buttonDownFcn(src,event,data,option)
% [y,x,button] = ginput(1);
pt = get(gca,'CurrentPoint');    %获取当前点坐标
x = pt(1,1);
y = pt(1,2);
x = round(x);y = round(y);
if strcmp(get(gcf,'SelectionType'),'alt')
    button = 3;% right click
elseif strcmp(get(gcf,'SelectionType'),'normal')
    button = 1;%left click
end
global px py slide
% try
    if button == 1
        [~,py] = min(abs(option.yaxis-y*ones(size(option.yaxis))));
        [~,px] = min(abs(option.xaxis-x*ones(size(option.xaxis))));
    elseif button == 3
        slide = x;
    end
    drawAll(data,option);
    drawPlot(data,option);
% catch
%     disp('Position Error, or right/left click?');
% end
end

function drawPlot(data,option)
if option.showInts == 0
    return
end
global px py slide
showData = zeros(size(data{1},1),option.subN);
for ii = 1:option.subN
    showData(:,ii) = data{ii}(:,py,px);
end
if option.listData==1
    disp(['%%%%%%%%%%%%% Point ',num2str(option.yaxis(py)),'/',num2str(option.xaxis(px))]);
%     disp(num2str(showData));
    set(gcf,'userdata',showData);
end
if option.plotInOne
    subplot(option.subM,option.subN,[option.subN+1:2*option.subN]);
    plot(showData);
    legend('show');
    hold on
    plot(slide*ones(size(showData,2),1),showData(slide,:)','ko');
    hold off
    title(['Slide ',num2str(slide),' x: ',num2str(option.xaxis(px)),' y: ',num2str(option.yaxis(py))]);
else
    for ii = 1:option.subN
        subplot(option.subM,option.subN,option.subN+ii);
        plot(showData(:,ii));
        hold on
        plot(slide,showData(slide,ii),'ko');
        hold off
        title(['Slide ',num2str(slide),' x: ',num2str(option.xaxis(px)),' y: ',num2str(option.yaxis(py))]);
    end
end
end

function drawAll(data,option)
for n = 1:length(data)
    ax(n) = subplot(option.subM,option.subN,n);
    drawOne(data{n},option,n);
end
linkaxes (ax,'xy');   %链接所有ax的xy坐标，使其同步使用指定的二维坐标区的范围
end

function drawOne(data,option,subP)
global px py slide
temp = squeeze(data(slide,:,:));
cType = option.cType(subP);
x = option.xaxis;
y = option.yaxis;
if cType == 0
    option.func(x,y,temp);
else
    try
        option.func(x,y,temp,'clim',[0,cType]);
    catch
        try
            v = 0:cType/50:cType;
            option.func(x,y,temp,v);
        catch
            option.func(x,y,temp);
        end
    end
end
title(['Ints ',num2str(round(min(temp(:)))),' to ',num2str(round(max(temp(:)))),' (',num2str(data(slide,py,px)),')']);

%         viscircles(h,[py,px], 5,'EdgeColor','r');
hold on
plot(option.xaxis(px),option.yaxis(py),'ro');
hold off

end

function getMovie(data,option)
option.listData = 0;
if strcmp(option.getMovie.type,'gif')
    try
        delayTime = option.getMovie.delayTime;
    catch
        delayTime = 0.1;
    end
else
    myObj = VideoWriter(option.getMovie.fileName,option.getMovie.type);
    try
        writerObj.FrameRate = option.getMovie.FrameRate;
    catch
        writerObj.FrameRate = 30;
    end
    open(myObj);
end

global px py slide
for ii = 1:length(option.getMovie.slide)
    slide = option.getMovie.slide(ii);
    px = option.getMovie.px(ii);
    py = option.getMovie.py(ii);
    drawAll(data,option);
    drawPlot(data,option);
    frame = getframe(gcf);
    if strcmp(option.getMovie.type,'gif')
        im = frame2im(frame);
        [I,map] = rgb2ind(im,256);
        if ii == 1
            imwrite(I,map,[option.getMovie.fileName,'.gif'],'gif','Loopcount',Inf,'DelayTime',delayTime);
        else
            imwrite(I,map,[option.getMovie.fileName,'.gif'],'gif','WriteMode','append','DelayTime',delayTime);  
        end
    else
        writeVideo(myObj,frame);
    end
end
if ~strcmp(option.getMovie.type,'gif')
    close(myObj);
end
end

