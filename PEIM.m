lh = findall(gca, 'type', 'line');
yc = get(lh, 'ydata');
xc = get(lh, 'xdata');

data(:, 1)=yc{3, 1};
data(:, 2)=yc{2, 1};
data(:, 3)=yc{1, 1};
t(:, 1)=xc{1,1};

Fs = 100;
begin = triggerTimer(data, t, Fs);

L = 1024;
y = Y(begin.frame:begin.frame+L-1, 1);
x = data(begin.CS1:(begin.CS1 + ceil(L/Fs*10000) -1), 3);

% [~, Ph] = freqrespmeasure(x, y);
Ph = phdiffmeasure(x, y);