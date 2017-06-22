% Uniform partitioned convolution
% Somesh Ganesh, Nikhil Bhanu
function y = myFastConvolution(x, h)

len_of_sig = length(x);
len_of_ir = length(h);

y = zeros(len_of_sig + len_of_ir - 1, 1);

%%
%Blocking input signal and impulse response
[~, ublocked_ir] = generateBlocks(h, 44100, 128, 128);
[~, blocked_signal] = generateBlocks([x;zeros(length(h) - 1, 1)], 44100, 128, 128);

len_x = length(x);

%Calculating number of blocks
num_x_blocks = size(blocked_signal, 2);
num_h_blocks = size(ublocked_ir, 2);

%Storing fft of impulse response blocks
blocked_fft_ir = cell(num_h_blocks, 1);
start_h_idx = 1;
blocked_temp_ir = zeros(128,1);
for i = 1 : num_h_blocks
    blocked_temp_ir = ublocked_ir(:,i);
    blocked_fft_ir{i} = fft(blocked_temp_ir, 255);
    start_h_idx = start_h_idx + 128;
end

temp_y = cell(1);

%Loop for convolution and overlap and add
for i = 1 : num_x_blocks

    for j = 1 : num_h_blocks
        
        if (i - j + 1) < 1
            break;
        end
                
        blocked_fft = fft(blocked_signal(:, i - j + 1), 255);
        
        temp_fft = blocked_fft .* blocked_fft_ir{j};
        temp_y{1} = ifft(temp_fft);
        
        start_idx = ((i - 1) * 128) + 1;
        end_idx = min(start_idx + length(temp_y{1}) - 1, length(y));
        
        %Output buffer of length (x + h - 1)
        y(start_idx : end_idx, 1) = y(start_idx : end_idx, 1) + temp_y{1}(1 : (end_idx - start_idx + 1), 1);
        
        %Output block (128 samples)
        output = zeros(end_idx - start_idx + 1, 1);
        output(:, 1) = y((start_idx : end_idx), 1);
    end
    
end

end