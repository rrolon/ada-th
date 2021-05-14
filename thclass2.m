function c = thclass2(cx, Nc, N)
    
    c = zeros(Nc, 1);
    px = [];
    for j = 1:Nc
        px(j) = sum(cx((j-1)*N+1:j*N)); 
    end
    % selecciona la clase
       
    ind_px = find(px==max(px));
    % ind_perm = ind_px(randperm(length(ind_px)));
    %c(ind_perm(1)) = 1;
    c(ind_px) = 1;
end