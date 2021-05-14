function ec = eclass(hh,w,pp,N,v)

    % for each pattern returns a vector with ones in the activated classes
    % each pattern must be normalized to max=1

    ec = zeros(size(pp,1),size(hh,2));

    if nargin < 5
        Nc = length(hh(1,:))/N;
        v = zeros(length(w),size(pp,1), Nc);
        for k = 1:length(w)
            v(k,:,:) = thclass(hh(k,:), pp, N);
        end
    end

    for i = 1:size(pp,1)
        vote = voting_th(v(:,i,:), w);
        ec(i,vote) = 1;
    end

end
