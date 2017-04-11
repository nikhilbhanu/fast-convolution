function y = myFastConvolution(x, h)

    len_of_sig = length(x);
    len_of_ir = length(h);
    conv_size = (2 * len_of_ir) - 1;
    
    y = zeros(len_of_sig + len_of_ir - 1, 1);
    
    [~, blocked_signal] = generateBlocks(x, 44100, len_of_ir, len_of_ir);
    
    num_blocks = size(blocked_signal, 2);
    
    temp_y = zeros(conv_size, num_blocks);
    
    y(1 : conv_size) = myFreqConv(blocked_signal(:, 1), h);
    temp_y(:, 1) = y(1 : conv_size);
    
    for i = 2 : num_blocks
        
        temp_y(:, i) = myFreqConv(blocked_signal(:, i), h);
        
        start_of_overlap = ((i - 1) * len_of_ir + 1);
        end_of_overlap = start_of_overlap + (conv_size - len_of_ir) - 1;
        
        start_of_block = ((i - 1) * len_of_ir) + 1;
        end_of_block = ((i - 1) * len_of_ir) + conv_size;
        
        overlap = y(start_of_overlap : end_of_overlap) + temp_y(1 : conv_size - len_of_ir, i);

        y( start_of_block : end_of_block) = [overlap ; temp_y(conv_size - len_of_ir + 1 : end, i)];
        
    end
end  