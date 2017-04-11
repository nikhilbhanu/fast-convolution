% Function - generateBlocks(x, sample_rate_Hz, block_size, hop_size)
% By Nikhil Bhanu

function [t, X] = generateBlocks(x, sample_rate_Hz, block_size, hop_size)

    x = x';
    num_samples = length(x);
    % zero padding
    x = [x, zeros(block_size, 1)'];
    % number of blocks
    num_blocks = ceil(num_samples / hop_size);
    X = zeros(block_size, num_blocks);
    
    t = 0 : hop_size : num_blocks * hop_size - 1;
    first_sample_of_blocks = t + 1;
    t = t ./ sample_rate_Hz;
    t = t';
    
    count = 1;
    for i = 1 : hop_size : first_sample_of_blocks(end)
        X(:, count) = x(i : i + block_size - 1)';
        count = count + 1;
    end
end

