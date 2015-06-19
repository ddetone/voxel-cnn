function H = upsample_filt(size)

    factor = floor((size + 1) / 2);
    if mod(size,2) == 1
        center = factor - 1;
    else
        center = factor - 0.5;
    end
    [ogx, ogy, ogz] = meshgrid(0:size-1, 0:size-1, 0:size-1);
    H = (1 - abs(ogx - center) / factor) .* ...
        (1 - abs(ogy - center) / factor) .* ...
        (1 - abs(ogz - center) / factor);
%     
% %     H = H ./ sum(sum(sum(H)));
% %     H = H - mean(mean(mean(H)))/2;


%     factor = floor((size + 1) / 2);
%     if mod(size,2) == 1
%         center = factor - 1;
%     else
%         center = factor - 0.5;
%     end
%     [ogx, ogy] = meshgrid(0:size-1, 0:size-1);
%     H = (1 - abs(ogx - center) / factor) .* ...
%         (1 - abs(ogy - center) / factor);
    
%     H = H ./ sum(sum(H));
end