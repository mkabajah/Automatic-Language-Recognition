function  train_gmm_GI %(wm_dir, no_mixtures)

wm_dir = 'C:\CallFriend DB\CF DevSet\UBM_Combined\';
no_mixtures = 512;

if no_mixtures < 1
  error('Number of mixture components must be greater than zero')
end

n1 =1; n2 =12;
%%%%%%%%%%%%%%%%%%%%%%%%%
if no_mixtures < 256
   ndiv = 1;
elseif no_mixtures <=256
    ndiv = 2;
elseif no_mixtures <=512
   ndiv = 3;
elseif no_mixtures <= 1024
   ndiv = 4;
elseif no_mixtures <= 2048
  ndiv = 16;
else
ndiv = 16;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
%gmm.mixtures = no_mixtures;
max_em = 4;%10;
max_inc =  0.0085;
MIN_COVAR = 0.01; %0.001 ;%eps;	% Minimum singular value of covariance matrix
m = no_mixtures;
%pk = zeros(m);
%xpk = zeros(m,d);
%xxpk = zeros(m,d);
%once = 1;
N = 0;
[dir_in, dir_out, in_files] =  db_info_ds1();
no_files = 0;
nums = zeros(1,12);
for id = n1:n2 %12 
 fp = fopen([dir_out{id},in_files{id}],'r');
 fname = fscanf(fp,'%s\n', 3); %9 
 while strcmp(fname,'') ~= 1   
    no_files = no_files +1;
    nums(id) = nums(id)+1;    
    fname = fscanf(fp,'%s\n', 3);  %9  
 end
 fclose(fp);
end
fprintf('Start training GMM of %d mixtures\n',m);
% Initialise GMM parameters by usinmg K-means algorithm
%gmm = read_gmm(wm_dir, 'kmeans_64_nomap.gmm');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[gmm,esq] = gkmeans_GI(wm_dir, no_mixtures);
fprintf('Initializing GMM by using Kmeans algorithm is finished\n');
%init_covars = gmm.covars;

fprintf('Start EM algorith ...\n');
for em = 1:max_em

 pk = zeros(1,gmm.mixtures);
 xpk = zeros(m,gmm.dim);
 xxpk = zeros(m,gmm.dim);
 err= 0;

for id = n1:n2  %12   
   fp = fopen([dir_out{id},in_files{id}], 'r'); 
 for j = 1:nums(id)
   fname = fscanf(fp,'%s\n', 3);    
   %fprintf('E-M Iteration No %d: progress %4.2f ... ',em,id/no_files*100);
   fname = [fname(1:13),' ',fname(14:18),' ',fname(19:end)];   
   fin = fopen(fname, 'r');
   if fin ==-1
       stp = 1;
   end
   nd = fread(fin, 2, 'int');  
   x = fread(fin,[nd(1),nd(2)],'float');
   fclose(fin);
   %%%%%%%%%%%%%%%%%CMS%%%%%%%%%%%%%
   %x = (x - ones(nd(1),1)* mean(x))./(ones(nd(1),1)* std(x));
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if em == 1
      N = N + nd(1); %compute total number of vectors
   end
   
   %n1 = floor(nd(1)/2);
   Start = 1;
   End = 0;
   for p =1:(ndiv-1)
    End = End + floor(nd(1)/ndiv);  
    % Calculate posteriors based on old parameters
    %[post,e] = gmmpost(gmm, x(Start:End,:)); 
    [post] = gaussian_posteriors(x(Start:End,:)',gmm.centres', gmm.covars', gmm.priors');
     e = 1e-10;
    post = post';
    err = err + e;  
    % Adjust the new estimates for the parameters
    pk = pk+ sum(post, 1);
    xpk = xpk+ post'* x(Start:End,:);
    xxpk = xxpk + post'*(x(Start:End,:).^2);
    clear post;
    Start = 1 + End;
   end
  %[post,e] = gmmpost(gmm, x(Start:nd(1),:)); 
  [post] = gaussian_posteriors(x(Start:nd(1),:)',gmm.centres', gmm.covars', gmm.priors');
  e = 1e-10;
  post = post';
  err = err + e;  
   % Adjust the new estimates for the parameters
  pk = pk+ sum(post, 1);
  xpk = xpk+ post'* x(Start:nd(1),:);
  xxpk = xxpk + post'*(x(Start:nd(1),:).^2); %*x(Start:nd(1),:)); 
  clear x; clear post;
 end % j files
fclose(fp);

end
% Now move new estimates to old parameter vectors
gmm.centres = xpk ./ (pk' * ones(1, gmm.dim));
gmm.covars = (xxpk ./(pk'*ones(1,gmm.dim))) - (gmm.centres.^2);
gmm.priors = pk ./ N;

% Ensure that no covariance is too small
  for j = 1:gmm.mixtures
     %if min(gmm.covars(j,:)) < MIN_COVAR
      %  gmm.covars(j,:) = init_covars(j,:);
     %end
     a = gmm.covars(j,:);
     a(a<=MIN_COVAR)= MIN_COVAR;
     gmm.covars(j,:) = a;
  end
  
fprintf('EM iteration No %d finished with Error %11.6f.\n',em,err);
filename = ['world_',int2str(gmm.mixtures),'_gi.gmm'];
save_gmm(wm_dir,gmm, filename);

if (em > 1 && abs(err - eold) < max_inc*N)        
        break;
else
    if em > 1
        fprintf('diff err = %f.    threshold=%f\n', abs(err - eold),max_inc*N);
    end
    eold = err;
    
end

end %max e-m iterations

fprintf('End of training process');