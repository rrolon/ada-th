function c = thclass2(cx, Nc, N)
    
    c = zeros(Nc, 1);
    px = [];
    for j = 1:Nc
        px(j) = sum(cx((j-1)*N+1:j*N));
    end
    [~, imx] = max(px);
    c(imx) = 1;
    
end