input = 30;
conv1 = conv_calc(input, 3, 1, 7, true);
pool1 = conv1/2;
pool2 = pool1/2;
fc3_conv = conv_calc(pool2, 5, 1, 0, true);
upsamp = conv_calc(fc3_conv, 8, 4, 0, false);
disp(sprintf('input is: %d, upsamp is: %d', input, upsamp));