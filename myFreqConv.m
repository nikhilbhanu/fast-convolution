% Music DSP Assignment 1
% By Nikhil Bhanu
% Function - myFreqConv(x, h)

function [y] = myFreqConv(x, h)
    n = length(x);
    m = length(h);
    numSamples = m + n - 1;
    xFft = fft(x, numSamples);
    hFft = fft(h, numSamples);
    yFft = xFft .* hFft;
    y = ifft(yFft);
end

