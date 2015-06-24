% My net
input = 100;
conv1 = conv_calc(input, 3, 1, 7, true);
pool1 = conv1/2;
pool2 = pool1/2;
fc3_conv = conv_calc(pool2, 5, 1, 0, true);
upsamp = conv_calc(fc3_conv, 8, 4, 0, false);
disp(sprintf('input is: %d, upsamp is: %d', input, upsamp));

% % BLVC
% input = 500;
% conv1 = conv_calc(input, 3, 1, 81, true);
% pool = conv1/32;
% fc7_conv = conv_calc(pool, 7, 1, 0, true);
% upsamp = conv_calc(fc7_conv, 64, 32, 0, false);
% disp(sprintf('input is: %d, upsamp is: %d', input, upsamp));