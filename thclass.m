function cc = thclass(h,pp,N)
% for each pattern returns a vector with ones in the activated classes
% each pattern must be normalized to max=1

Nc=length(h)/N;
cc = zeros(size(pp,1),Nc);
for i=1:size(pp,1)
    th = 0.99; 
    cx = [];
    while (sum(cx)<1) && (th>0)
        u=abs(pp(i,:))>th;      % compute activations
        cx=u(h);                % pre-classify
        th=th-0.1;              % update threshold
    end;
    cc(i,:) = thclass2(cx,Nc,N)';
end;


% all the voted classes
function c = thclass1(cx,Nc,N)
c = zeros(Nc,1);
for j = 1:Nc
    c(j) = sum(cx((j-1)*N+1:j*N))>0;
end;

% the highest voted class
function c = thclass2(cx,Nc,N)
c = zeros(Nc,1);
px = [];
for j = 1:Nc
    px(j) = sum(cx((j-1)*N+1:j*N));
end;
[mmx,imx] = max(px);
c(imx) = 1;

% classification method 3: each dimension with a weight and WMV
