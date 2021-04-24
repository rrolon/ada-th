function [pp]=find_activations(dict,data_b,data_d,data_eh,data_ih,data_jh,MP_coeff,set,method)


act_b=timit2act_1L(dict,data_b,'b',MP_coeff,set);
act_d=timit2act_1L(dict,data_d,'d',MP_coeff,set);
act_eh=timit2act_1L(dict,data_eh,'eh',MP_coeff,set);
act_ih=timit2act_1L(dict,data_ih,'ih',MP_coeff,set);
act_jh=timit2act_1L(dict,data_jh,'jh',MP_coeff,set);


if strcmp(method,'adath') | strcmp(method,'nnet')  | strcmp(method,'adann') | strcmp(method,'adaknn')
    %% Normalize the activations %%%
    max_b=max(abs(act_b));
    max_d=max(abs(act_d));
    max_eh=max(abs(act_eh));
    max_ih=max(abs(act_ih));
    max_jh=max(abs(act_jh));

    L=size(act_b);
    L=L(2);
    for pp=1:L
        act_b(:,pp)=act_b(:,pp)/max_b(pp);
        act_d(:,pp)=act_d(:,pp)/max_d(pp);
        act_eh(:,pp)=act_eh(:,pp)/max_eh(pp);
        act_ih(:,pp)=act_ih(:,pp)/max_ih(pp);
        act_jh(:,pp)=act_jh(:,pp)/max_jh(pp);
    end;
end;

pp=[act_b act_d act_eh act_ih act_jh]';
