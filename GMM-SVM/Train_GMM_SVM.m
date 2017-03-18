function Train_GMM_SVM()

[dir_in, dir_out, in_files] = LID_db_info('train','MFCC');
wm_dir = 'C:\LID\UBM\';
wm_file = 'world_128_MFCC.gmm';
%U_fname =  'U_Matrix_4096_400.dat'; 
fprintf('***Starting GMM-SVM training ...***\n');


 for id = 1:12
   fprintf('%d - Language #%d is being processed ...',id,id);
    
      GMM_SV_MAP(dir_out{id},in_files{id},wm_dir,wm_file,'male\');       
      GMM_SV_MAP(dir_out{id},in_files{id},wm_dir,wm_file,'female\'); 
    
 fprintf('finished\n');
 end
 
 
if 1

% collecting data

filename = 'LDM_1024sv.sv';
countsm = zeros(1,12); 
countsf = zeros(1,12);
datam = [];
dataf = [];
for id =1:12
    
   fin = fopen([dir_out{id},'male\',filename],'r');
   nd = fread(fin, 2,'int');
   countsm(id) = nd(2);
   x = single(fread(fin,[1*nd(1),nd(2)],'float'));
   fclose(fin);

   datam = [datam,single(x)];     
%   %%%%%%%%%%%%% collecting Females SVs %%%%%%%%%%
    fin = fopen([dir_out{id},'female\',filename],'r');
    nd = fread(fin, 2,'int');         
    countsf(id) = nd(2);   
    x = single(fread(fin,[1*nd(1),nd(2)],'float')); %2*nd(1)
    fclose(fin); 
%    %%%%%%%%%%%%%
 %  x(1:nd(1),:) = my_norm(x(1:nd(1),:),[wm_dir,'female\'], wm_file);
%    %%%%%%%%%%%%%
    dataf = [dataf,single(x)]; 
end
%% read UBM GMM model
gmm_m = read_gmm([wm_dir,'male\'], wm_file);
gmm_f = read_gmm([wm_dir,'female\'], wm_file);

% now apply model normalization technique %%%%%%%%
datam(1:nd(1),:) = m_norm(datam(1:nd(1),:),gmm_m);
dataf(1:nd(1),:) = m_norm(dataf(1:nd(1),:),gmm_f);

fprintf('\nNow, start training SVM Models ....\n');
fprintf('-------males------- \n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = 1; e = 0;
c = 2; %inf; %linear SVM
epsilon = .000001;
kernel= 'gmm_sv';%
verbose = 0;%1;
fnameout = 'AD_SVM_model128.dat'; %'pushbak_4096_mu_featnorm.dat';%
 xapp = single(datam'); clear datam;
for id = 1:12
 fprintf('processing Language # %d ...',id);   
 e = e + countsm(id);
 yapp = -ones(sum(countsm),1);
 yapp(s:e) = +1;
 s = e+1;
kerneloption= gmm_m;

[xsup,w,b,pos]=svmclass2(xapp,yapp,c,epsilon,kernel,kerneloption,verbose,[]);

%%%%%%%%%%%%%%%
% if 0
% [nn,MD]=size(xsup);
% xp = zeros(1,MD);
% xm = zeros(1,MD);
% cc = 0;
% for ii=1:nn
%    if yapp(pos(ii))>0 
%        xp = xp + w(ii).*xsup(ii,:);
%        cc = cc + w(ii);
%    else
%        xm = xm + w(ii).*xsup(ii,:);
%        
%    end
% end
% xp = xp./cc;
% xm = xm./(-1*cc);
% cc = -0.5*cc;
% fout = fopen([dir_out{id},'male\',fnameout],'wb');
% fwrite(fout,MD,'int');
% fwrite(fout,xp,'float');
% fwrite(fout,xm,'float');
% fwrite(fout,cc,'float');
% fclose(fout);
% end %if 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 1
xsup = xsup';
[n,d] = size(xsup);
fout = fopen([dir_out{id},'male\',fnameout],'wb');
fwrite(fout,n,'int');
fwrite(fout,d,'int');
fwrite(fout,xsup,'float');
[n,d] = size(w);
fwrite(fout,n,'int');
fwrite(fout,d,'int');
fwrite(fout,w,'float');
fwrite(fout,b,'float');
fclose(fout);
end % if 0
fprintf('finished\n');
end

fprintf('\nNow, start training SVM Models ....\n');
fprintf('-------females------- \n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = 1; e = 0;
c = 2; %inf; %linear SVM
epsilon = .000001;
kernel= 'gmm_sv';%
verbose = 0;%1;
fnameout = 'AD_SVM_model128.dat'; %'pushbak_4096_mu_featnorm.dat';%
 xapp = single(dataf'); clear dataf;
for id = 1:12
 fprintf('processing language # %d ...',id);   
 e = e + countsf(id);
 yapp = -ones(sum(countsf),1);
 yapp(s:e) = +1;
 s = e+1;
kerneloption= gmm_f;

[xsup,w,b,pos]=svmclass2(xapp,yapp,c,epsilon,kernel,kerneloption,verbose,[]);

%%%%%%%%%%%%%%%
% if 0
% [nn,MD]=size(xsup);
% xp = zeros(1,MD);
% xm = zeros(1,MD);
% cc = 0;
% for ii=1:nn
%    if yapp(pos(ii))>0 
%        xp = xp + w(ii).*xsup(ii,:);
%        cc = cc + w(ii);
%    else
%        xm = xm + w(ii).*xsup(ii,:);
%        
%    end
% end
% xp = xp./cc;
% xm = xm./(-1*cc);
% cc = -0.5*cc;
% fout = fopen([dir_out{id},'male\',fnameout],'wb');
% fwrite(fout,MD,'int');
% fwrite(fout,xp,'float');
% fwrite(fout,xm,'float');
% fwrite(fout,cc,'float');
% fclose(fout);
% end %if 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 1
xsup = xsup';
[n,d] = size(xsup);
fout = fopen([dir_out{id},'female\',fnameout],'wb');
fwrite(fout,n,'int');
fwrite(fout,d,'int');
fwrite(fout,xsup,'float');
[n,d] = size(w);
fwrite(fout,n,'int');
fwrite(fout,d,'int');
fwrite(fout,w,'float');
fwrite(fout,b,'float');
fclose(fout);
end % if 0
fprintf('finished\n');
end

fprintf('SVM Training is now Finished.');

end %if0

  SVM_evaluate();
% gmm_evaluate03();
%gmm_svm_gmm_evaluate03();