function gmm = read_gmm(wdir,gmm_file)

% Reading hte GMM Model parameters ...
f1 = fopen([wdir,gmm_file],'r');
gmm.dim = fread(f1,1,'int');
gmm.mixtures = fread(f1,1,'int');
gmm.priors = fread(f1,[1,gmm.mixtures],'float');
gmm.centres = fread(f1,[gmm.mixtures,gmm.dim],'float');
gmm.covars = fread(f1,[gmm.mixtures,gmm.dim],'float');
fclose(f1);