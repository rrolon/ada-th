function [e, Err] = ctest(c, rlab)
% compute the classificantion error

c = squeeze(c);
Err = zeros(size(c,1), 1);
for j = 1:size(rlab,1)
    r1 = rlab(j,1); r2 = rlab(j,2);
    Err(r1:r2) = c(r1:r2,j)<1;
    % modificar como se calcula el error del weak classifier
end
e = sum(Err)/size(c,1);
