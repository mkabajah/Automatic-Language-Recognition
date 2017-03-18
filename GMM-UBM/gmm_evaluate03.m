function gmm_evaluate03(R)
if nargin < 1
    R = 50;
end
tic;
%dir_t = 'G:\CallFriend DB\Testing sets\lid96d1\test\MFCC24\'; % NIST 96 Devset
dir_t = 'G:\CallFriend DB\Testing sets\lid03e1\test\FFT68\'; %FIR68_2\'; %FFT68\'; %fft68\';% NIST 03 EvalSet
namelist = 'LID03_KEY.v3'; %'seg_lang.ndx'; % 
gmm_file = 'LDM_4096_featsel.gmm'; %'LDM_2048_fsdc.gmm';
svm_file = 'pushbak_512_fir.dat'; 
wm_dir = 'F:\Combined\UBMs\FFT68\'; %SRU\';  
wm_file = 'world_4096_featsel.gmm'; %'world_2048_fsdc2.gmm';
[~, dir_out] = db_info('dev','FFT68'); %CD2();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
U_file = 'U_Matrix_2048_400_featnorm61.dat'; %'U_Matrix_2048_400_featsel.dat';% 'U_matrix_512_50_.dat'; %'U_Matrix_2048_fsdc.dat';
use_ISC = 0;

use_fuse = 0;

if 0
ff = fopen([wm_dir,'male\HLDA_theta_512.dat'],'r');
nd = fread(ff,2,'int');
pt = nd(2);
thetam = fread(ff, [nd(1),nd(2)], 'float');
fclose(ff);
ff = fopen([wm_dir,'female\HLDA_theta_512.dat'],'r');
nd = fread(ff,2,'int');
thetaf = fread(ff, [nd(1),nd(2)], 'float');
fclose(ff);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Read U Matrix%%%%%%%%%%%%%
if use_ISC
fp = fopen(['F:\Combined\UBMs\FFTnorm\',U_file],'r');
nd = fread(fp,2,'int');
U = fread(fp,[nd(1),nd(2)],'float');
E = fread(fp,[1,nd(2)],'float');
fclose(fp);
U = U(:,1:R); E=E(1:R);
%fp = fopen([wm_dir,'female\',U_file],'r');
%nd = fread(fp,2,'int');
%Uf = fread(fp,[nd(1),nd(2)],'float');
%fclose(fp);
%Um=Um'; Uf = Uf';
else
    U = [];
    E = []; 
end %if 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


dir_test = 'G:\CallFriend DB\Testing sets\lid96d1\test\SDC68\';
namelist_test = 'seg_lang.ndx';%'LID03_KEY.v3';
%[im_means_m, im_vars_m] = t_norm2(dir_test, namelist_test, gmm_file, wm_dir, wm_file,U,E,1); % 1: male imposters

%[im_means_f, im_vars_f] = t_norm2(dir_test, namelist_test, gmm_file, wm_dir, wm_file,U,E,0); %0:female mposters

%ff = fopen('C:\CallFriend DB\Testing sets\lid96e1\MFCC24_30\t_norm_64_1.dat','r');
%im_means_m = fread(ff,[1,12],'float');
%im_vars_m = fread(ff,[1,12],'float');
%fclose(ff);

gmm_wm = read_gmm([wm_dir,'male\'],wm_file);
gmm_wf = read_gmm([wm_dir,'female\'],wm_file);

%gmm_wm.priors = gmm_wm.priors ./ sum(gmm_wm.priors);
%gmm_wf.priors = gmm_wf.priors ./ sum(gmm_wf.priors);

fp = fopen([dir_t,namelist],'r');
Filename = fscanf(fp,'%s\n', 9); %9
no_test_files = 0;
while strcmp(Filename,'') ~= 1   
    no_test_files = no_test_files +1;
    Filename = fscanf(fp,'%s\n', 9);  %9  
end
fclose(fp);
correct = zeros(1,12); %12
conf = zeros(12,12, 'single'); % confusion Matrix
counts=zeros(1,12);
scores = zeros(1, 12); %  no of langauges (12)

fp = fopen([dir_t,namelist],'r'); 
ft= fopen('C:\Users\aah648\Documents\MATLAB\true_lang.dat','w');
ff= fopen('C:\Users\aah648\Documents\MATLAB\imposter_lang.dat','w');

if use_fuse
  fuse_t = cell(12);
  fuse_i = cell(12);
  for u=1:12
      fuse_t{u} = [];
      fuse_i{u} = [];
  end
end
%fi= fopen('C:\Documents and Settings\aah648\My Documents\MATLAB\Backend\scores.dat','w');
%fg = fopen('all.txt','wt');
%sss = zeros(1200,12,'single');
%qq = 0;

for i = 1:no_test_files
  
    %cd(dir_t);
    Filename = fscanf(fp,'%s\n', 2);    
    Fnamein = [Filename(1:8),'.cep']; %(1:8)
    fscanf(fp,'%s\n', 4);
    gndr = fscanf(fp,'%s\n', 1);
    fscanf(fp,'%s\n', 2);
    fin = fopen([dir_t,Fnamein], 'r');
 if fin ~= -1 
     
     %qq=qq+1;
     nd = fread(fin,2,'int');
     tdat = fread(fin,[nd(1),nd(2)],'float');
     fclose(fin); 
     if nd(2) ~= 66
         clear g;
     end
     %nd=size(tdat);
  %if ~strcmp(Filename1(end-4:end),'CHOME') %CFRND
    
  
    %%%%%%%%%%%%%%%%%    
    switch   lower(Filename(9:end)) %(9:end)
        case 'english'
            langID = 1;
        case 'french'
            langID = 2;    
        case 'arabic'
            langID = 3;
        case 'farsi'
            langID = 4;
        case 'german'
            langID = 5;
        case 'hindi'
            langID = 6;    
        case 'japanese'
            langID = 7;
        case 'korean'
            langID = 8;
        case 'mandarin'
            langID = 9;
        case 'spanish'
            langID = 10;    
        case 'tamil'
            langID = 11;
        case 'vietnamese'
            langID = 12;
        case 'russian'
            langID = -1;
        otherwise
            langID = -1;
            %warning('non languages');
            %return;
    end
    
    
 if langID > 0 && nd(2) == gmm_wm.dim  %&& counts(langID) < 5%&& gndr =='M'  
    
    %fprintf(fg,'%s  %s  %d\n',Filename(1:8),lower(Filename(9:end)),langID); 
     
        
    counts(langID)= counts(langID)+1;   
    %tdat = feat_warp(tdat,0.01);
   
    tdat = (tdat - ones(nd(1),1)*mean(tdat))./(ones(nd(1),1)*std(tdat));
    gmm_wm.centres = gmm_wm.centres - ones(gmm_wm.mixtures,1)*mean(gmm_wm.centres,1);
    gmm_wf.centres = gmm_wf.centres - ones(gmm_wf.mixtures,1)*mean(gmm_wf.centres,1); 
    %tdatm = ((tdat*V1m)./(ones(nd(1),1)*D1m))*V2m;
    %tdatf = ((tdat*V1f)./(ones(nd(1),1)*D1f))*V2f;
   
    [score_wm,topm] = probgmm_w(tdat,gmm_wm, 1);
    [score_wf,topf] = probgmm_w(tdat,gmm_wf, 1); 
    
    if score_wm > score_wf
        score_w = score_wm;
        top = topm;
        gender = 1; %male
        gendir = 'male\';
        gmm_w = gmm_wm;
        %U = Um;
        %theta =thetam;
%         post = postm; clear postm; clear postf;
    else
        score_w = score_wf;
        top=topf;
        gender = 0; %female
        gendir = 'female\';
        gmm_w = gmm_wf;
        %theta =thetaf;
        %U = Uf;
%         post = postf; clear postm; clear postf;
    end
    
    %gmm_w.centres = gmm_w.centres * theta; 
    %gmm_w.covars = gmm_w.covars * theta;
    %tdat = tdat * theta;
    %[score_w,top] = probgmm_w(tdat,gmm_w, 5);   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if use_ISC 
    xc = channel_factor(tdat,U,E,gmm_w,post);
    %[~,~,nsk,fsk] = gpu_post2(gmm_w,tdat);
%     xc = gchannel_factors(U,nsk,fsk,E);
      %xc = gchannel_factors(U,(nsk),(fsk),E);
  
          %%%%%%%%%%%%%%
          mm = gmm_w.centres; mm = mm';
          mm = mm(:);
          mm = mm + U*xc;
          mm = reshape(mm,gmm_w.dim,gmm_w.mixtures);
          gmm_w.centres = mm';
          %%%%%%%%%%%%%%
          [score_w,top] = probgmm_w_big(tdat,gmm_w, 1);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    sums = 0;
   for l=1:12 %12    
       %if l  ~= 3 && l ~= 6 % || l == 7
                   
          if gender == 1
             
             gmm = read_gmm([dir_out{l},'male\'],gmm_file);            
              %fm = fopen([dir_out{l},'male\','SeqM_512_frag.dat'],'r');
              %M = fread(fm,1,'int');   
              %BiGram = fread(fm,[M,M],'float');
              %Bicounts = single(fread(fm,[1,M],'float'));
              %BiGram = single(fread(fm,[M,M],'float'));
              %TriGram = uint16(fread(fm,[M*M*M,1],'float'));
              %fclose(fm);
              %TriGram = reshape(TriGram,M,M,M);
              %[ss,top] = probgmm_w(tdat,gmm,1);             
              
              
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             if 0
              fc = fopen([dir_out{l},'male\pushbak_4096_mcov.dat'],'r');
              md = fread(fc,1,'int');
              xp = fread(fc,[1,md],'float');
              xm = fread(fc,[1,md],'float');
              c1  = fread(fc,1,'float');
              fclose(fc);
             end %if 0 
              
          else              
           
               gmm = read_gmm([dir_out{l},'female\'],gmm_file);              
              %fm = fopen([dir_out{l},'female\','SeqM_512_frag.dat'],'r');
              %M = fread(fm,1,'int');  
              %BiGram = fread(fm,[M,M],'float');
              %Bicounts = single(fread(fm,[1,M],'float'));
              %BiGram = single(fread(fm,[M,M],'float'));
              %TriGram = single(fread(fm,[M*M*M,1],'float'));
              %fclose(fm);
              %TriGram = reshape(TriGram,M,M,M);
              %[ss,top] = probgmm_w(tdat,gmm,1);

              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              if 0
               fc = fopen([dir_out{l},'female\pushbak_4096_mcov.dat'],'r');
               md = fread(fc,1,'int');
               xp = fread(fc,[1,md],'float');
               xm = fread(fc,[1,md],'float');
               c1  = fread(fc,1,'float');
               fclose(fc);     
             end % if0 
          end
          
%             xp=(xp'+U*xc)';
%             xm=(xm'+U*xc)';

% xp(1:md/2)=(xp(1:md/2)'+U*xc)';
% xm(1:md/2)=(xm(1:md/2)'+U*xc)';

        % gmm.centres = gmm.centres * theta;
         %gmm.covars = gmm.covars * theta;
         %gmm.priors = gmm_w.priors;
         %%%%%%%%%%%%%%%%%%%%%%%%%%
          if 0
%            cc= -2*c1;
%             xp=xp./cc;
%             xm=xm./(-1*cc);
           gmmp = gmm_w;
%            means = reshape(xp(1:md/2),gmmp.dim,gmmp.mixtures);
%            covs = reshape(xp(1+md/2:end),gmmp.dim,gmmp.mixtures);
           
           means = reshape(xp,gmmp.dim,gmmp.mixtures);
           gmmp.centres = means';
%            gmmp.covars = covs';
          
           gmmm = gmm_w;
%            means = reshape(xm(1:md/2),gmmm.dim,gmmm.mixtures);
%            covs = reshape(xm(1+md/2:end),gmmm.dim,gmmm.mixtures);
           
           means = reshape(xm,gmmp.dim,gmmp.mixtures);
           gmmm.centres = means';
%            gmmm.covars = covs';
          end % if0  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

          %gmm.priors = gmm.priors ./ sum(gmm.priors);
           gmm.centres = gmm.centres - ones(gmm.mixtures,1)*mean(gmm.centres,1);
          %%%%%%%%%%%%%%%%%%%%%%
          if use_ISC
          mm = gmm.centres; mm = mm';
          mm = mm(:);  
          mm = mm + U*xc; 
          mm = reshape(mm,gmm.dim,gmm.mixtures);
          gmm.centres = mm';
          end
         
         %%%%%%%%%%%%%%%%%%%%%%         
         score = probgmm(tdat,gmm,top)- score_w ; 
          
%            score = -1*(probgmm_w(tdat,gmmm,1) - probgmm_w(tdat,gmmp,1));
          if gender == 1
           %score = (score - im_means_m(langID))/sqrt(im_vars_m(langID));
         else
            %score = (score - im_means_f(langID))/sqrt(im_vars_f(langID)); 
          end
          
          scores(l) = score;         
          sums = sums + exp(score);          
        
   end
   
     
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        s = zeros(1,12); %12
        %ss = exp(scores);
      for k=1:12 %12
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        if 0
          sm = sums - exp(scores(k));
          if sm == 0
              s(k) = scores(k);
          else
            s(k) = scores(k)- log(sm/11);            
          end
        end %if0 
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if 1
          mmx = -inf;
          for ll=1:12
           if ll ~=k
              if mmx < scores(ll)
                  mmx = scores(ll);
              end
           end
          end
          
          s(k) = scores(k) - mmx;
      end %if 0
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
           %mmu = mean(ss(2:end));
           %ssd = std(ss(2:end));
           %s(k)= ((exp(scores(k)) - mmu)/ssd);
           %ss = circshift(exp(scores),[0 -1]);
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
          %sss(qq,:) = s;
          
          if k == langID
             fwrite(ft,s(k),'float');
             if use_fuse
                fuse_t{k}=[fuse_t{langID};s(k)];
             end
          else
             fwrite(ff,s(k),'float');
             if use_fuse
                fuse_i{k}=[fuse_i{langID};s(k)];
             end
           end
      end
      
      [~,index] = max(s);
      conf(langID,index) = conf(langID,index) +1; % confusion Matrix
      if index == langID
          correct(langID) = correct(langID) +1;
%       else
%           fprintf('%s\n',[dir_t,Fnamein]);
      end 
     
 end  
 %end %if~strcmp() CFrnd
 end
  
end
fclose(fp); 
fprintf('\nTotal correct percentage = %4.2f percent of %d test segments.\n',sum(correct)*100/sum(counts),sum(counts));
fprintf('Correct percentage of each Language-Model\n');
for c = 1:12 %12
fprintf('%d|%d  ',correct(c), counts(c));
end
fprintf('\n Cavg = %f PerCent \n',calc_Cavg(conf));
fclose(ft);
fclose(ff);
%fwrite(ff,ldata,'float');
%fclose(fi);
if use_fuse
  save_fuse(fuse_t,fuse_i, 'C:\Users\aah648\Documents\MATLAB\MFCC38-512\');  %'F:\DET Curves\Train + Dev\Feat_norm24\512_all\');
end

%save 'all_scores.mat' sss;
toc;

fprintf('\n============================================================\n');
fprintf('R = %d \n',R);
My_Det();

%%
function s = Fetch_Tri(fp,M,m,n,l)

off = (M-l)*M*M + (M-n)*M + (M-m) +1;
off = -4*off;
fseek(fp,off,1);
s = fread(fp,1,'float');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Cavg = calc_Cavg(conf)
[n,d] = size(conf);
if n ~= d
  warining('confusion matrix must be square matrix!');
end

Pmiss = zeros(1,n);
Pfa = zeros(1,n);
miss =0; fa=0;

for i=1:n
 for j= 1:n
  if i ~= j
   miss = miss + conf(i,j);
   fa = fa + conf(j,i);
  end
 end
Pmiss(i) = miss / (miss + conf(i,i));
Pfa(i) = fa / (fa + conf(i,i));

end

Pmiss = 0.5.*Pmiss;
Pfa = 0.5*(1/(n-1)).*Pfa;
Cavg = sum(Pmiss + Pfa)/(n-1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function save_fuse(fuse_t, fuse_i,dir_t)
        
        
        fname_t = 'fuse_true.dat';
        fname_i = 'fuse_imp.dat';
        fwt = fopen([dir_t,fname_t],'wb');
        fwi = fopen([dir_t,fname_i],'wb');
        fwrite(fwt,12,'int');
        fwrite(fwi,12,'int');
        for id =1:12
            fwrite(fwt,length(fuse_t{id}),'int');
            fwrite(fwi,length(fuse_i{id}),'int');
            
            fwrite(fwt,fuse_t{id},'float');
            fwrite(fwi,fuse_i{id},'float');
        end
        
        fclose(fwt);
        fclose(fwi);
            
