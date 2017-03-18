function   GMM_SV_MAP(lang_dir, namelist, wm_dir,wm_file,gender)

r = 16;
%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Reading parameters of world GMM of ');

% Reading the GMM-UBM Model parameters ...
gmm = read_gmm([wm_dir,gender],wm_file);

fprintf('%d Mixtures\n',gmm.mixtures);
m = gmm.mixtures;
N= 0;
UBM_means = gmm.centres;
%%%%%%%%%%%%%%%%%%%%%%%%%

if gmm.mixtures <= 128
   ndiv = 1;
elseif gmm.mixtures <=256
   ndiv = 2;
elseif gmm.mixtures <=512
   ndiv = 2;
elseif gmm.mixtures <= 1024
   ndiv = 6;
elseif gmm.mixtures <= 2048
  ndiv = 6;
else
ndiv = 16;
end
fprintf('Reading parameters of world GMM of %d mixtures is finished!\n',gmm.mixtures);
fp = fopen([lang_dir,gender,namelist],'r');
Filename = fscanf(fp,'%s\n', 1); %9
nfiles = 0;
while strcmp(Filename,'') ~= 1   
    nfiles = nfiles +1;
    Filename = fscanf(fp,'%s\n', 1);  %9  
end
fclose(fp);
no_files = nfiles;
no_files
fp = fopen([lang_dir,gender,namelist], 'r');
Svec = zeros(m*gmm.dim, no_files);
for id = 1:no_files
  % if rem(id,2) ~= 0
    fname = fscanf(fp,'%s\n', 1);
  
   fprintf('processing file %s ....  \n',fname);
   fin = fopen([lang_dir,gender,fname], 'r');
   
  if fin > -1
      nd = fread(fin, 2, 'int');
      pk = zeros(1,m);
      xpk = zeros(m,nd(2));    
     
   x = fread(fin,[nd(1),nd(2)],'float');
   fclose(fin); 
   
   N = N + nd(1); %compute total number of vectors   
 
   ss = 1;
   ee = 0;
   size((x(ss:ee,:))')
size(gmm.centres')
size(gmm.covars')
size(gmm.priors')
  for p=1:(ndiv-1)       
     ee = ee + floor(nd(1)/ndiv);   
%      post = gpu_post2(gmm, x(ss:ee,:));

     [post,e] = gaussian_posteriors((x(ss:ee,:))',gmm.centres',gmm.covars',gmm.priors');
     post = post';
     pk = pk + sum(post, 1);
     xpk = xpk + post'*x(ss:ee,:);  
     ss = ee+1;
  end    
%       post = gpu_post2(gmm, x(ss:nd(1),:));
     [post,e] = gaussian_posteriors(x(ss:nd(1),:)',gmm.centres',gmm.covars',gmm.priors');
     post = post'; 
     pk = pk + sum(post, 1);
     xpk = xpk + post'*x(ss:nd(1),:);  
   
  end %if fin > -1
 
% Now move new estimates to old parameter vectors

xpk = xpk ./(pk'* ones(1, gmm.dim));
pk = pk ./ (pk + r);
new_means = (pk' * ones(1, gmm.dim)).*xpk  +  ((1-pk)'*ones(1,gmm.dim)).*UBM_means ;
new_means = new_means';
new_means = new_means(:);
Svec(:,id) = new_means;
end %files
fclose(fp);

 fprintf('MAP Adaptation on file basis is finished and now saving GMM supper vectors into file\n');
 filename = ['LDM_',int2str(gmm.mixtures),'sv.sv'];

 fout = fopen([lang_dir,gender,filename],'wb');
 fwrite(fout,m*gmm.dim,'int');
 fwrite(fout,no_files,'int');
 fwrite(fout,Svec,'float');
 fclose(fout);


