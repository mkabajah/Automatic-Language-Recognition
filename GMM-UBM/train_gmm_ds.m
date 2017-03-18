function gmm = train_gmm_ds(dirr,gendirr, no_mixtures, path_fun, tag )

if no_mixtures < 1
  error('Number of mixture components must be greater than zero')
end
if nargin < 4
 path_fun = 'fir68';
end

if nargin < 5
 tag = 'tag';
end

%%%%%%%%%%%%%%%%%%%%%%%%%
if no_mixtures < 256
   ndiv = 1;
elseif no_mixtures <=256
    ndiv = 2;
elseif no_mixtures <=512
   ndiv =3 ;
elseif no_mixtures <= 1024
   ndiv = 5;
elseif no_mixtures <= 2048
  ndiv = 10;%8;
else
ndiv = 24;
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
[~, dirr_out, in_files] =  LID_db_info('train',path_fun); %feval(path_fun);  %
no_files = 0;
nums = zeros(1,12);
for id = 1:12
 fp = fopen([dirr_out{id},gendirr,in_files{id}],'r');
 fname = fscanf(fp,'%s\n', 1); %9 
 while strcmp(fname,'') ~= 1   
    no_files = no_files +1;
    nums(id) = nums(id)+1;    
    fname = fscanf(fp,'%s\n', 1);  %9  
 end
 fclose(fp);
end
fprintf('Start training GMM of %d mixtures\n',m);
% Initialise GMM parameters by usinmg K-means algorithm
if isequal(gendirr,'male\')&& 0
 gmm = read_gmm([dirr,gendirr], 'kmeans_2048_featsel.gmm');
 max_em = max_em-1;
else
[gmm,esq] = gkmeans_ds(dirr,gendirr, no_mixtures, path_fun, tag);
end
fprintf('Initializing GMM by using Kmeans algorithm is finished\n');
%init_covars = gmm.covars;

fprintf('Start EM algorith ...\n');
for em = 1:max_em

  pk = zeros(1,m);
  xpk = zeros(m,gmm.dim);
  xxpk = zeros(m,gmm.dim);
  err= 0;

for id = 1:12   
   fp = fopen([dirr_out{id},gendirr,in_files{id}], 'r'); 
 for j = 1:nums(id)
   fname = fscanf(fp,'%s\n', 1);    
   %fprintf('E-M Iteration No %d: progress %4.2f ... ',em,id/no_files*100);   
   fin = fopen([dirr_out{id},gendirr,fname], 'r');
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
    [post,e] = gpu_post2(gmm, x(Start:End,:));
    %[post,e] = gaussian_posteriors(x(Start:End,:)',gmm.centres',gmm.covars',gmm.priors');
    post = double(post);
    e = double(e);
    err = err + e;  
    % Adjust the new estimates for the parameters
    pk = pk+ sum(post, 1);
    xpk = xpk+ post'* x(Start:End,:);
    xxpk = xxpk + post'*(x(Start:End,:).^2);
    clear post;
    Start = 1 + End;
   end
  %[post,e] = gmmpost(gmm, x(Start:nd(1),:));
  [post,e] = gpu_post2(gmm, x(Start:nd(1),:));
 %[post,e] = gaussian_posteriors(x(Start:nd(1),:)',gmm.centres',gmm.covars',gmm.priors');
 post = double(post);
  e=double(e); 
  err = err + e;  
   % Adjust the new estimates for the parameters
  pk = pk+ sum(post, 1);
  xpk = xpk+ post'* x(Start:nd(1),:);
  if sum(isnan(xpk(:))) ~= 0
      clear p;
  end
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
filename = ['world_',int2str(gmm.mixtures),'_',tag,'.gmm'];
save_gmm([dirr,gendirr],gmm, filename);

filename = ['world_',int2str(gmm.mixtures),'_',tag,'_dble.gmm'];
%save_gmm64([dirr,gendirr],gmm, filename);
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