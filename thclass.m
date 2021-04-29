function cc = thclass(h, pp, N)
    % for each pattern returns a vector with ones in the activated classes
    % each pattern must be normalized to max=1

    Nc = length(h)/N;
    cc = zeros(size(pp,1), Nc);
    for i=1:size(pp,1)
        th = 0.99; 
        cx = [];
        while sum(cx)<1 && th>0
            u = abs(pp(i,:))>th; % compute activations
            cx = u(h); % pre-classify
            th = th-0.1; % update threshold
        end
        cc(i,:) = thclass2(cx,Nc,N)';
    end
    
end