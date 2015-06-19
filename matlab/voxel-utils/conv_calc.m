function d_out = conv_calc( d_in, kernel, stride, pad, conv )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    if conv == true
        d_out = (d_in - kernel + 2*pad)/stride + 1;
    else
        d_out = stride*(d_in - 1) + kernel - 2*pad;
    end
end

