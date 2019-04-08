function r = randsample(v, n);

inds = randperm( numel(v) );

r = v( inds(1:n) );

end