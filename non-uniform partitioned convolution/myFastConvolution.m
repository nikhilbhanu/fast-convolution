%Non-uniform partition convolution
%Somesh Ganesh and Nikhil Bhanu
function y = myFastConvolution(x, h)

len_of_sig = length(x);
len_of_ir = length(h);

y = zeros(len_of_sig + len_of_ir - 1, 1);

%%
%Blocking impulse response
[~, ublocked_ir] = generateBlocks(h, 44100, 128, 128);
num_128h_blocks = size(ublocked_ir, 2);

num_hblocks = 0;
%%
%Computing number of non-uniform blocks in impulse response
for i = 1 : 0.5 : num_128h_blocks
    if num_hblocks >= num_128h_blocks
        num_hblocks = ((i - 0.5) / 0.5) - 1;
        break;
    else
        num_hblocks = num_hblocks + (2 ^ (floor(i) - 1));
    end
end

%Zero padding the impulse response
n = (2 ^ floor(num_hblocks / 2)) * 128;
h = [h;zeros(n, 1)];

blocked_fft_ir = cell(num_hblocks, 1);

%Generating ftt of impulse response blocks 
start_hidx = 1;
for i = 1 : 0.5 : (num_hblocks / 2) + 0.5
    blocked_temp_ir = zeros(128 * (2 ^ (floor(i) - 1)), 1);
    blocked_temp_ir = h(start_hidx : start_hidx - 1 + 128 * (2 ^ (floor(i) - 1)));
    blocked_fft_ir{(i - 0.5) / 0.5, 1} = fft(blocked_temp_ir, length(blocked_temp_ir) + 128 - 1);
    start_hidx = start_hidx + (128 + (2 ^ (floor(i) - 1))); 
end
%%
%Blocking input signal
[~, blocked_signal] = generateBlocks([x;zeros(length(h) - 1, 1)], 44100, 128, 128);
%%
%Convolution and overlap & add 
num_blocks = size(blocked_signal, 2);


for i = 1 : num_blocks
   
    for j = 1 : num_hblocks
        
        if (i - j + 1) < 1
            break;
        end
        temp_y = cell(1);
        blocked_fft = fft(blocked_signal(:, i - j + 1), length(blocked_fft_ir{j}));
        temp_fft = blocked_fft .* blocked_fft_ir{j};
        temp_y{1} = ifft(temp_fft);
        
        start_idx = ((i - 1) * 128) + 1;
        
        end_idx = min(start_idx + length(temp_y{1}) - 1, length(y));
        
        %Output Buffer of length (x + h - 1)
        y(start_idx : end_idx, 1) = y(start_idx : end_idx, 1) + temp_y{1}(1 : (end_idx - start_idx + 1), 1);
        
        %Output block (128 samples)
        output = zeros(end_idx - start_idx + 1, 1);
        output(:, 1) = y((start_idx : end_idx), 1);
        
    end
    
end

end  