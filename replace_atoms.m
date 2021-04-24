%-------------------------------------------------------
function [kdict,ind]=replace_atoms(dict,kdict)


ind=zeros(1,size(kdict,2));
dict_aux=dict;
for i=1:size(kdict,2)
    for j=1:size(dict,2)
        pint(j)=dot(kdict(:,i),dict_aux(:,j));
    end;
    [m,ind(i)]=max(pint);
    dict_aux(:,ind(i))=0;
end;

for i=1:size(kdict,2)
    kdict(:,i)=dict(:,ind(i));
end;
