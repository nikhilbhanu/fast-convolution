% Function - compareConv(x, h)
% By Nikhil Bhanu

function [m, mabs, stdev, time] = compareConv(x, h)
    tic;
    y_freq = myFastConvolution(x, h);
    t_freq = toc;
    tic;
    y_conv = conv(x, h);
    t_conv = toc;
    m = mean(y_freq(1 : length(y_conv)) - y_conv);
    mabs = mean(abs(y_freq(1 : length(y_conv)) - y_conv));
    stdev = std(y_freq(1 : length(y_conv))- y_conv);
    time = [t_freq; t_conv];
end

