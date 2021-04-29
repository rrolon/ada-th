function coef = MP_Matrix(x, F, natom, frac)
% MP_Matrix -- Matching Pursuit with direct matrix-on-vector operations
%		for any dictionary
%  Usage
%	coef = MP_Matrix(x, F[, natom, frac])
%  Input
%	x	1-d signal; n-by-1 column vector
%	F	dictionary matrix; each columns corresponds to each atom
%	natom   max # of atoms desired, default = n
%	frac    min fraction total signal energy to enter, default=1e-2
%  Outputs
%	coef	coef of the MP representation; column vector
%  Description
%	1. natom controls the maximum number of atoms MP can select
%	2. Selected atoms must have coefficients greater than a certain
%	   fraction of total signal energy, defined by the parameter
%	   frac, in order to be enter.
%  See Also
%	MP, OMP, OMP_Matrix
%

x = x(:);
n = length(x);
N = size(F);
N = N(2);
res = [];
nrm = norm(x);
amp = nrm;

residule = x;
index = [];
if nargin < 3
	natom = N;
	frac = 1e-2;
end
k = 0;
coef=[];
% fprintf('\nMP_Matrix:\n');
while (amp > frac*nrm) && (k < natom)
	P = abs(residule' * F);
	[amp, i] = max(P);
	i = i(1);
	index = [index i];
	coefnew = residule' * F(:, i);
	coef = [coef coefnew];
	residule = residule - coefnew .* F(:, i);
	k = k + 1;
% 	disp(sprintf('Step%4g:  select = %5g     coef = %10.2e',k,i,coefnew));
end

h = length(coef);
coefbest = zeros(N, 1);
for i = 1:h
	coefbest(index(i)) = coefbest(index(i)) + coef(i);
end
coef = coefbest;
xrec = F * coefbest;


