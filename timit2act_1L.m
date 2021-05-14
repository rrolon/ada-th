function [SS]=timit2act_1L(A,data,ph,coeff,set)
% function timit2act_1L(A,data,ph,coeff,set)
%
% This function loads a dictionary trained previously genereated,
% and by means of Matching Pursuit finds the activations for the patterns.

%% Initial configurations
if nargin < 1

%     set='all';
        set='trn';
%        set='tst';
    coeff=10;

    load best_dict.mat;
    A=best_dict;
    clear best_dict;
%     load /home/maxi/Doctorado/Cortical/train-FIXED/Trained05bis/big_dict-norm.mat
%     A=big_dict;
%     clear big_dict;


    %%% The filename where the patterns are saved %%%
    filename_trn=['patrones/trn_500pp_1L.txt'];
    filename_tst=['patrones/tst_500pp_1L.txt'];

else
    %%% The filename where the patterns are saved %%%
    filename_trn=['patrones/trn_500pp_1L' ph '.txt'];
    filename_tst=['patrones/tst_500pp_1L' ph '.txt'];
end;


%% Obtain the activations for the training patterns
if (strcmp(set,'all')||strcmp(set,'trn'))

    if nargin < 1
        fid=fopen(filename_trn,'w');
        %%% Load the patterns whose activations are to be finded %%%
        load TIMIT_data/500patterns/trn_data_all.mat;
%         load TIMIT_data/DR1/trn_data_all.mat;        
        data=trn_data_all;
        clear trn_data_all;
    end;

    %%% Matching Pursuit %%%
    cols=size(data);
    cols=cols(2);

    sa=size(A);
    SS=zeros(sa(2),cols);
    S=zeros(sa(2));
    for k=1:cols
%                S=MP_Matrix(data(:,k),A);
                S=MP_Matrix(data(:,k),A,coeff,0);
%                S=OMP_Matrix(data(:,k),A,coeff,0);
%                S=BP_Simplex(data(:,k),A);
%          S=solveBP(A,data(:,k),size(A,2));
        SS(:,k)=S;
        if nargin < 1
            fprintf(fid,'%s\n',char(label(k,:)));
            fprintf(fid,'%f ',S);
            fprintf(fid,'\n');
        end;
    end;

    if nargin < 1
        fprintf(fid,'nPatrones: %d\n',cols);
        fclose(fid);
    end;
end;

%% obtain the activations for the testing patterns
if (strcmp(set,'all')|strcmp(set,'tst'))
    if nargin < 1
        fid=fopen(filename_tst,'w');
        %%% Load the patterns whose activations are to be finded %%%
        load TIMIT_data/500patterns/tst_data_all.mat;
        data=tst_data_all;
        clear tst_data_all;
    end;

    %%% Matching Pursuit %%%
    cols=size(data);
    cols=cols(2);

    sa=size(A);
    SS=zeros(sa(2),cols);
    for k=1:cols
%                S=MP_Matrix(data(:,k),A);
               S=MP_Matrix(data(:,k),A,coeff,0);
%                 S=OMP_Matrix(data(:,k),A,coeff,0);
%                S=BP_Simplex(data(:,k),A);
%          S=solveBP(A,data(:,k),size(A,2));

        SS(:,k)=S;
        SS(:,k)=S;
        if nargin < 1
            fprintf(fid,'%s\n',char(label(k,:)));
            fprintf(fid,'%f ',S);
            fprintf(fid,'\n');
        end;
    end;

    if nargin < 1
        fprintf(fid,'nPatrones: %d\n',cols);
        fclose(fid);
    end;
end;
%%

% beep;
% close all;










