% ------------------------------------------------------------------------
function print_params(p)
% ------------------------------------------------------------------------\
layers = fieldnames(p);
for i = 1:size(layers,1)
    fprintf('%s weights are ', layers{i});
    fprintf('( %d, %d, %d, %d )', size(p.(layers{i}){1}));
    fprintf(' and biases are ');
    fprintf('( %d, %d, %d, %d )\n', size(p.(layers{i}){2}));    
end


end