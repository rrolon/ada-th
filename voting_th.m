function max_j = voting_th(v, w)
% WMVoting: Weighted Majority Voting
%   
%   Obtain total vote for each class and choose the one with highest total vote
%
%  DDD 20071126
%

    v = squeeze(v);
    [~, max_j] = max(sum(diag(-log(w))*v,1));
    
end

%~ for k = 1:length(w)
    %~ logwk = -log(w(k)); %=log(1/w)
    %~ for j = 1:size(v,2)
        %~ wmv(j) = wmv(j)+v(k,j)*logwk; 
    %~ end;
%~ end;

