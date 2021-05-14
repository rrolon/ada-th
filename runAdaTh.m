% main script
% The aim of this script is to select the most representative elements of a
% big dictionary.
% By using kmeans clustering, the script selects different number of
% centroids by phoneme class, and by means of the adaboost determines the
% performance of the reduced dictionary. The performance is measured over
% the TEST(2500x5) TIMIT set.

iters = 68;
filenumber = 1;
filename=['kmeans_eval' num2str(filenumber) '.mat'];

disp('Loading dictionaries...');
% loading dictionaries
load 'train-FIXED/dict_b-256x256-A-logE-norm.mat';
load 'train-FIXED/dict_d-256x256-A-logE-norm.mat';
load 'train-FIXED/dict_eh-256x256-A-logE-norm.mat';
load 'train-FIXED/dict_ih-256x256-A-logE-norm.mat';
load 'train-FIXED/dict_jh-256x256-A-logE-norm.mat';

kppt = 2500; % total number of patterns (training and testing)
kpp = 1*kppt; % total number of training data (80%)
MPiters = 10; % sparsity level (MP)
adaiters = 150; % number of iterations (Adaboost)
rmax = 1; % 5; % number of repetitions (kmeans)

% initializations
ens_err_trn = ones(rmax,length(MPiters))*10000;
ens_err_tst = ones(rmax,length(MPiters))*10000;
mean_err = zeros(length(iters),length(MPiters));
max_err = zeros(length(iters),length(MPiters));
min_err = zeros(length(iters),length(MPiters));
big_dict = cell(1,rmax);
global_min = zeros(1,2);
global_min(1) = 10000;
best_dict = [];
good_dicts=[];

% loading phonemes
disp('Loading training data...');
load 'TIMIT_data/2500patterns/trn_data_b.mat';
load 'TIMIT_data/2500patterns/trn_data_d.mat';
load 'TIMIT_data/2500patterns/trn_data_eh.mat';
load 'TIMIT_data/2500patterns/trn_data_ih.mat';
load 'TIMIT_data/2500patterns/trn_data_jh.mat';
disp('Loading testing data...');
load 'TIMIT_data/2500patterns/tst_data_b.mat';
load 'TIMIT_data/2500patterns/tst_data_d.mat';
load 'TIMIT_data/2500patterns/tst_data_eh.mat';
load 'TIMIT_data/2500patterns/tst_data_ih.mat';
load 'TIMIT_data/2500patterns/tst_data_jh.mat';

% training data
trn_data_b=trn_data_b(:,1:kpp);
trn_data_d=trn_data_d(:,1:kpp);
trn_data_eh=trn_data_eh(:,1:kpp);
trn_data_ih=trn_data_ih(:,1:kpp);
trn_data_jh=trn_data_jh(:,1:kpp);

% validation data
%val_data_b=trn_data_b(:,:kpp);
%val_data_d=trn_data_d(:,1:kpp);
%val_data_eh=trn_data_eh(:,1:kpp);
%val_data_ih=trn_data_ih(:,1:kpp);
%val_data_jh=trn_data_jh(:,1:kpp);

% testing data
tst_data_b=tst_data_b(:,1:kpp);
tst_data_d=tst_data_d(:,1:kpp);
tst_data_eh=tst_data_eh(:,1:kpp);
tst_data_ih=tst_data_ih(:,1:kpp);
tst_data_jh=tst_data_jh(:,1:kpp);

range=zeros(5,2);
for i=1:5
    range(i,:)=[1+(i-1)*kpp i*kpp];
end;

disp('Starting the test...');

iter = 0;
% tic;

for c = iters
    disp(['Kmeans centroids = ' num2str(c)]);
    iter = iter+1;
    for r = 1:rmax

        disp(['Repetition = ' num2str(r)]);
        
        [~, centr] = kmeans(dict_b', c);  
        centr_b = replace_atoms(dict_b, centr');
       
        [~, centr] = kmeans(dict_d', c);   
        centr_d = replace_atoms(dict_d, centr');

        [~, centr] = kmeans(dict_eh', c);  
        centr_eh = replace_atoms(dict_eh, centr');

        [~, centr] = kmeans(dict_ih',c);    
        centr_ih = replace_atoms(dict_ih,centr');

        [~, centr] = kmeans(dict_jh', c);    
        centr_jh = replace_atoms(dict_jh, centr');

        big_dict{r} = [centr_b centr_d centr_eh centr_ih centr_jh];

        %%% Find the activations %%%
        % Activations for TRAIN
        mpiter=0;
        for MP_coeff = MPiters
            mpiter=mpiter+1;
            disp(['MP coefficients = ' num2str(MPiters(mpiter))]);            
            % pp_trn = find_activations(big_dict{r},trn_data_b,trn_data_d,trn_data_eh,trn_data_ih,trn_data_jh,MP_coeff,'trn','adatree');
            pp_trn = find_activations(big_dict{r},trn_data_b,trn_data_d,trn_data_eh,trn_data_ih,trn_data_jh,MP_coeff,'trn','adath');
            % Activations for TEST
            % pp_tst=find_activations(big_dict{r},tst_data_b,tst_data_d,tst_data_eh,tst_data_ih,tst_data_jh,MP_coeff,'tst','adatree');
            pp_tst=find_activations(big_dict{r},tst_data_b,tst_data_d,tst_data_eh,tst_data_ih,tst_data_jh,MP_coeff,'tst','adath');
            
            %% prueba con MLP
            
            % train_mlp()
            
            % prueba con arbol de desiciones
            
            % train_tree()
            
            %% prueba con random forest
            
            % train_random_forest()
            
            %%
            
            [trnErr,tstErr] = adath(adaiters,0,pp_trn,range,pp_tst,range,1);
            % [trnErr,tstErr] = adatree(adaiters,0,pp_trn,range,pp_tst,range,1);
            
            disp(['Train error ' num2str(trnErr(end)*100) ' %']);
            disp(['Test error ' num2str(tstErr(end)*100) ' %']);            
            
            ens_err_tst(r,mpiter)=tstErr*100;
            ens_err_trn(r,mpiter)=trnErr(end)*100;
            
        end
    end

    mean_err_trn(iter,:) = mean(ens_err_trn);
    max_err_trn(iter,:) = max(ens_err_trn);
    min_err_trn(iter,:) = min(ens_err_trn);

    mean_err_tst(iter,:) = mean(ens_err_tst);
    max_err_tst(iter,:) = max(ens_err_tst);
    min_err_tst(iter,:) = min(ens_err_tst);

    [Min,idx_min] = min(ens_err_trn);
    [Min,idx_min2] = min(min(ens_err_trn));
    good_dicts{iter} = big_dict{idx_min(idx_min2)};

    % disp(['saving partial results...']);
    % eval(['save ' filename ' mean_err' ' max_err' ' min_err' ' good_dicts']);

end



% save the results
% save(filename,'mean_err','max_err','min_err','good_dicts','best_dict');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save('kmeans_eval2.mat','mean_err','max_err','min_err','good_dicts','best_dict','iters');
% disp(['saving results...']);
% disp(' ');
% eval(['save ' filename ' mean_err' ' max_err' ' min_err' ' best_dict' ' iters']);
% filename=['full_' filename ];
% eval(['save ' filename ' mean_err' ' max_err' ' min_err' ' good_dicts' ' best_dict' ' iters']);

figure()
subplot(2,1,1)    
plot(iters,max_err_trn,'r',iters,mean_err_trn,'k',iters,min_err_trn,'b');
xlabel('k-means centroids');
ylabel('Training error');
subplot(2,1,2)    
plot(iters,max_err_tst,'r',iters,mean_err_tst,'k',iters,min_err_tst,'b');
xlabel('k-means centroids');
ylabel('Testing error');

