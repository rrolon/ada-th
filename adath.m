function [trnErr, tstErr] = adath(maxW, minE, pp_trn,ran_trn,pp_tst,ran_tst, test)
% AdaTh: AdaBoost.M1 for sparse codes
%
%  Finalization conditions
%    maxW: maximum number of weak-learners in the ensemble
%    minE: minimum classification error for the training set (in %)
%
%  Outputs
%    trnErr: training error
%    tstErr: testing error 
%

N = 10; % number of discriminative atoms (column size of each sub-dictionary)

[Np,~] = size(pp_trn); % Np: all patterns;
Nc = size(ran_trn,1); % number of classes
D = ones(Np,1)/Np; % sampling distribution
Ntrn = 1000; % training patterns for each sampling

nErr = zeros(maxW,1);
eErr = ones(maxW,1);
h = zeros(maxW,Nc*N);
c = zeros(maxW,Np,Nc);

k = 0;
maxE = 1;

while k<maxW
    drawnow;
    disp('----------------');
    k = k+1;
    disp(k);
    ktrn = bootsmp(D,Ntrn); % call to mex-bootstrap sampling
    h(k,:) = thtrain(pp_trn,ran_trn,ktrn,N);
    % compute the weighted error for the weak-classifier
    c(k,:,:) = thclass(h(k,:),pp_tst,N);
    % testing classifier
    [e, Err] = ctest(c(k,:,:), ran_tst);
    werr = sum(Err.*D);                      
    disp(['ClsErr ' num2str(e*100)]);
    nErr(k) = werr/(1-werr); % normalize error
    iErr = find(1-Err);
    D(iErr) = D(iErr)*nErr(k);
    D = D/sum(D); % distribution update
    % 
%     tic;
%     disp('ensemble error...');    
    ec(k,:,:) = eclass(h(1:k,:),nErr(1:k),pp_trn,N,c(1:k,:,:));
    [trnErr(k),Err] = ctest(ec(k,:,:),ran_trn);  
    disp(['EnsErr ' num2str(trnErr(k)*100)]); % ensemble-classification error

end

% Test ensemble with testing patterns
if test==1
    disp('Testing...');
    ectst = eclass(h(1:k,:),nErr(1:k),pp_tst,N);
    [tstErr,Err] = ctest(ectst,ran_tst); 
    disp(tstErr*100);
end
