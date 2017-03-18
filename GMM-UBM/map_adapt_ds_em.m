function  map_adapt_ds_em(lang_dir, namelist, wm_dir, wm_file, gender,tag)

if nargin < 6
  tag = 'notag';
end

%[nn,pp] = size(V1);

%nfiles = 20;
r = 0;
%%%%%%%%%%%%%%%%%%%%%%%%

% Reading the GMM-UBM Model parameters ...
gmm = read_gmm([wm_dir,gender],wm_file);

m = gmm.mixtures;
N= 0;
UBM_means = gmm.centres;
%%%%%%%%%%%%%%%%%%%%%%%%%
if gmm.mixtures <= 128
   ndiv = 1;
elseif gmm.mixtures <=256
   ndiv = 2;
elseif gmm.mixtures <=512
   ndiv = 3;
elseif gmm.mixtures <= 1024
   ndiv = 4;
elseif gmm.mixtures <= 2048
  ndiv = 10;
else
ndiv = 16;
end
%fprintf('Reading parameters of world GMM of %d mixtures is finished!\n',gmm.mixtures);
 
pk = zeros(1,m);
xpk = zeros(m,gmm.dim); 
   
fp = fopen([lang_dir,gender,namelist],'r');
Filename = fscanf(fp,'%s\n', 1); %9
nfiles = 0;
while strcmp(Filename,'') ~= 1   
    nfiles = nfiles +1;
    Filename = fscanf(fp,'%s\n', 1);  %9  
end
fclose(fp);
no_files = nfiles;

fp = fopen([lang_dir,gender,namelist], 'r');
for id = 1:no_files
 
    fname = fscanf(fp,'%s\n', 1);  
   %fprintf('processing file %s ....  \n',fname);
   fin = fopen([lang_dir,gender,fname], 'r');
  if fin > -1
    nd = fread(fin, 2, 'int');    
    x = fread(fin,[nd(1),nd(2)],'float');
    fclose(fin); 

  %%%%%%%%%%%%%%%%%CMS%%%%%%%%%%%%%
   %x = (x*V1);%./(ones(nd(1),1)*D1))*V2;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
   N = N + nd(1); %compute total number of vectors   
  %index = zeros(nd(1),1);
   ss = 1;
   ee = 0;
  for p=1:(ndiv-1)       
     ee = ee + floor(nd(1)/ndiv);    
     post = gaussian_posteriors(x(ss:ee,:)',gmm.centres',gmm.covars',gmm.priors');
     post = double(post');
     
     pk = pk + sum(post, 1);
     xpk = xpk + post'*x(ss:ee,:);  
     ss = ee+1;
  end
        
      post = gaussian_posteriors(x(ss:nd(1),:)',gmm.centres',gmm.covars',gmm.priors');
      post = double(post');
      
      pk = pk + sum(post, 1);
      xpk = xpk + post'*x(ss:nd(1),:);  
   
  end %if fin > -1
end %files
fclose(fp); 
 
% Now move new estimates to old parameter vectors
xpk = xpk ./ (pk' * ones(1, gmm.dim));
w = pk./N;
pk = pk ./ (pk + r);
gmm.centres = (pk' * ones(1, gmm.dim)).*xpk  +  ((1-pk)'*ones(1,gmm.dim)).*UBM_means ;
gmm.priors = w; %pk.*w + (1-pk).*gmm.priors;
gmm.priors = gmm.priors./sum(gmm.priors);

%fprintf('MAP Adaptation is finished and now saving lang. dependentGMM model into file\n');
filename = ['LDM_',int2str(gmm.mixtures),'_',tag,'.gmm'];
save_gmm([lang_dir,gender],gmm, filename);
