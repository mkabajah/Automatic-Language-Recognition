function ABI_Frontend()
tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[dirin, dirout, in_files] =   db_info('SDC68_fn','wav');%

for id =1:14
  fprintf('%d - Accent #%d is being processed ...',id,id); 
  
  Feature_extraction(in_files{id}, dirin{id}, dirout{id},'male\');
  Feature_extraction(in_files{id}, dirin{id}, dirout{id},'female\');
  
  fprintf('finished\n');
  
end


%% Training world Model %% 

wm_dir = 'D:\ABI_1\Training\UBMs\MFCC\';
tag = 'm';fc
M =256; %% GMM Order

     ABI_train_gmm(wm_dir,'',M,'MFCC',tag,'',1:14);
%      ABI_train_gmm_StandBy(wm_dir,'',M,'SDC68_fn',tag);
%      ABI_train_gmm(wm_dir,'female\',M,'SDC68',tag,1:14);


%% MAP Adaptation
wm_file = ['world_',int2str(M),'_',tag,'.gmm'];
fprintf('Starting MAP adaptation ...\n');
for id =1:14
   fprintf('%d -processing accent no %d (males) ...',id,id);
   map_adapt_ds_em(dirout{id}, in_files{id}, wm_dir, wm_file, 'male\',tag);
    
   fprintf('..Finished.\n');
   fprintf('  -processing accent no %d (females) ...',id);
   map_adapt_ds_em(dirout{id}, in_files{id}, wm_dir, wm_file, 'female\',tag);
   
  fprintf('..Finished.\n');
end
fprintf('MAP Adaptation Process is finished now.\n');
%%
%ABI_test_extract();
gmm_evaluate03();
toc;





function  Feature_extraction(namelist, dirin, dirout,gender)

Fs=22050;%*4/11;
FrameLen = 442; %20msec
Fshift = 221 ; %Frame rate 10ms
OverLap = FrameLen-Fshift; % Overlap between frames
NFFT = 2^(ceil(log(FrameLen)/log(2)));
no_filts = 30;
no_cep = 19;
once = 1;
use_pre_emph = 0;
use_mfcc = 1; % 1 ==> use MFCC. 0==> use LPC
lpc_order = 15;

width = 1.0;
minfrq = 0;
maxfrq = 11025;%4000;
htkmel =0; alfa = 1;
constamp = 0;
% load 'D:\FIR_FE\pcmg721.mat';
load 'D:\FIR_FE\bandpass19gab.mat'; %bp19ham80.mat'; %bp30ham220.mat'; % %bp19kai80.mat'; %bandpass19gab.mat'; %
% load 'D:\FIR_FE\fbamat19.mat';
% load('D:\FIR_FE\SRU_filters1.mat');
wts = fft2melmx(NFFT,Fs,no_filts,width, minfrq, maxfrq, htkmel, alfa, constamp); %fbamat; %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wts=wts(1:19,:);
% bbh = bbh(2:19,:); bbp = bbp(2:19,:);

% wts = fft2melmx(NFFT,Fs,28,width, minfrq, 8500, htkmel, alfa, constamp);

fp = fopen([dirin,namelist],'r');
Filename = fscanf(fp,'%s\n', 1); %9
no_files = 0;
while strcmp(Filename,'') ~= 1   
    no_files = no_files +1;    
    Filename = fscanf(fp,'%s\n', 1);  %9  
end
fclose(fp);

% fpch =  fopen([pitch_dir,namelist],'r');
if ~isempty(gender) 
   fw = fopen([dirout,gender,namelist],'wt');
end
if isequal(gender,'male\')
   fGI = fopen([dirout,namelist],'wt'); % GI namelist
else
    fGI = fopen([dirout,namelist],'at');
end
fp = fopen([dirin,namelist],'r'); 
for i = 1:no_files
 Fnamein = fscanf(fp,'%s\n', 1);
 pitch_fname = [Fnamein(1:end-3),'mat'];%fscanf(fpch,'%s\n', 1);
  [samples,Fs] = READWAV([dirin,Fnamein],'s');    
%    [samples,Fs] = wavread([dirin,Fnamein]);
%   samples = filter(Num,1,samples);
%   samples = resample(samples,4,11); Fs = Fs*4/11;
%   writewav(samples,Fs,[dirout,gender,Fnamein]);
%   continue;
  
  Fnameout = [Fnamein(1:end-3),'cep']; %(1:8)   
  
%   clc
%   fprintf('%s\n',Fnameout);
  if isequal('kjr001_gca_CT.cep',Fnameout)
      clear stop;
  end
   samples = samples(121:end-120);
%  samples2 = remove_silience_test2(samples); %,FrameLen,OverLap);
%  [s2,v2] = remove_silence2(samples,FrameLen,OverLap);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MFCC%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if use_mfcc 
   if 0%length(samples) > 18634960  && 0%%24634960
       hf = floor(length(samples)/2);
      [fbarray1] = mfirofifil4(bbp',bbh',samples(1:hf),0);
      [fbarray2] = mfirofifil4(bbp',bbh',samples(hf+1:end),0);
      fbarray = [fbarray1,fbarray2]; clear fbarray1; clear fbarray2;
%       eng = [eng1,eng2]; clear eng1; clear eng2;
%       zcc = [zcc1;zcc2]; clear zcc1; clear zcc2;
%       v = [v1;v2];  clear v1; clear v2; zcr = [zcr1;zcr2]; clear zcr1 zcr2;
   else
  %cepstra = feature_extract1(samples,fs,FrameLen, OverLap);
%    [fbarray] = mfirofifil4(bbp',bbh',samples,0);  %%,v,zcr,eng,zcc
  %[fbarray,v] =jsrufba(samples,80,denom,numer);
   [fbarray] = fbacpu22(samples,wts,FrameLen,OverLap,NFFT,use_pre_emph);
%    load([prosody_dir,gender,pitch_fname]); cepstra=Formants'; clear Formants;
%   fbarray = [fbarray(1:end-2,:);-50.*ones(2,size(fbarray,2))];
%  v = label_vowels([prosody_dir,pitch_fname(1:end-3),'rec'],0.01);
%  v(v>size(fbarray,2))= size(fbarray,2);
%  if length(v)<300
%      continue;
%  end
   end
%    fbarray = fbarray(1:22,:);
  clear samples;   
  fbarray = my_rasta(fbarray); %;zcc']);
if once
  [cepstra,dctm] = spec2cep(fbarray, no_cep);
  once = 0;
else
  cepstra = dctm*fbarray; 
end   

else        
       %ar=lpcauto2(samples,13,[Fshift FrameLen]);
       
     [ar,v] = gpu_lpc(samples,lpc_order,160,80); 
     cepstra = lpcar2cc(ar,lpc_order+1);
     cepstra = cepstra';
     cepstra = my_rasta(cepstra);
      
end
%   clear fbarray;
  cepstra = lifter(cepstra,0.6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 1
clear pitch;
load([pitch_dir,gender,pitch_fname]);
% pitch = pitch(4:end-4,:);
Nm = min(size(pitch,1),size(cepstra,2));
pitch = pitch(1:Nm,:);
% I = pitch(:,2)'; I(I<0) = 0; 
% I = I - mean(I);
p = pitch(:,1)';
% p(p>0) = log(p(p>0));
cepstra = [cepstra(:,1:Nm)]; %cepstra(cepstra(:)>0) = log(cepstra(cepstra(:)>0));
v = p>0 ; %v(1:Nm);
% pitch = [p;I;deltas([p;I])];
% pitch = pitch(:,v)';
% [nn,dd] = size(pitch);
end %if 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 sdc = SDC(cepstra,7,3,1,7); % N-P-d-k  7-3-1-7
%  sdc = MSDC(cepstra,7,3,3,7); 
%  sdc = deltas(cepstra); 
%  delta2 = deltas(sdc); 
 feat = [cepstra;sdc]'; clear cepstra; clear delta1; clear delta2; clear sdc; 
 feat = feat(v,:);
%  feat = feat(zcr,:); 
 [nn,dd]= size(feat);
 if nn<300 
 continue;
 else
   if ~isempty(gender) 
    fprintf(fw,'%s\n',Fnameout);
   end
  fprintf(fGI,'%s\n',[dirout,gender,Fnameout]);
  feat = feat_warp2(feat, 0.01);
%    feat = (feat - ones(nn,1)*mean(feat))./(ones(nn,1)*std(feat));
 end
 
%cd([dirout,sub1]) 
fout =fopen([dirout,gender,Fnameout],'wb'); 
fwrite(fout,nn,'int');
fwrite(fout, dd, 'int');
fwrite(fout,feat,'float');
fclose(fout);

clear feat;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

end
fclose(fp);
if ~isempty(gender) 
   fclose(fw);
end
fclose(fGI);

