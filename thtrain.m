function h=thtrain(pp,ran,idx,N);
% Train the weak classifier
%
%   pp:  all the patterns sorted by classes
%   ran: ranges for the classes
%   idx: idexes of the patterns to use in the training
%   N:   number of parameters for the classiffier
%   h:   selected dimensions to classify each class
%
% DDD 20071123
%

h = [];%zeros(size(ran,1)*N,1);
for j = 1:size(ran,1)
    idxj = idx( find( (idx>=ran(j,1)).*(idx<=ran(j,2)) ) ); % bsampled patterns in class j
    u = abs(pp(idxj,:))>0.99;  % activations for sampled all patterns in class j
    p = sum(u,1);                 % activations profile
    h = thtrain3(p,h,N); % h = thtrain3(p,h,N);
end;


% choose the highest activated dimension (N must be 1)
function h = thtrain1(p,h,N);
[mx,ipk] = max(p);
h=[h ipk];

% choose a pick at random
function h = thtrain2(p,h,N);
pks = find(p>sum(p)*0.01);
ipk = ceil(rand*length(pks));
if ipk>0, 
    h=[h pks(ipk)]; 
else % thtrain1 
    [mx,ipk] = max(p);
    h=[h ipk];
end;

% method 3: choose N picks
function h = thtrain3(p,h,N)
ipk=zeros(1,N);
for pk=1:N,
    [mx,ipk(pk)] = max(p);
    p(ipk(pk)) = 0;
    %plot([p zeros(1,88)]); pause
end;
h=[h ipk];


% mejora discriminativa: elegir el que más veces se activa para una clase 
% pero verificando que a la vez no se active (o se active poco) para las 
% otras

% mejora en relación a otros clasificadores del ensamble: se podrían pasar 
% como parámetro las dimensiones prohibidas, es decir las que ya fueron 
% usadas por otros clasificadores (en realidad esto no debería ser 
% necesario porque los patrones bien clasificados ya tendrían que aparecer
% menos por el boostrap)
