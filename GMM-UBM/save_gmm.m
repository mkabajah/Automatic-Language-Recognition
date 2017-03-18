function save_gmm(dirr,gmm,filename)

%cd(dir);
%filename = ['gmm_',int2str(gmm.mixtures),'_1.gmm'];
if strcmp(dirr(end),'\')~= 1
   dirr = [dirr,'\'];
end


fp = fopen([dirr,filename], 'wb');
fwrite(fp, gmm.dim,'int');
fwrite(fp, gmm.mixtures,'int');
fwrite(fp, gmm.priors ,'float');
fwrite(fp, gmm.centres,'float');
fwrite(fp, gmm.covars ,'float');
%if ~isempty(gmm.max_mix)
% fwrite(fp, gmm.max_mix, 'int');
%end
fclose(fp);
