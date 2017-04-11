x = ones(50, 1);
h = ones(10, 1);

piano = audioread('piano.wav');
impulse_response = audioread('impulse-response.wav');

y = myFastConvolution(x, h);

y_ref = conv(x, h);

plot(y);
hold on;
plot(y_ref);

[m, mabs, stdev, time] = compareConv(piano, impulse_response);
