function SVM_evaluate()

tar_dir = 'C:\LID\NIST Test\lid96d1\MFCC\';
dir_t = 'C:\LID\NIST Test\lid96d1\30\';
namelist = 'seg_lang.ndx'; % 
svm_file = 'AD_SVM_model1024.dat'; %accent depenedent SVMs
wm_dir = 'C:\LID\UBM\'; %world model;  
wm_file = 'world_1024_MFCC.gmm'; %world GMM model
[~, dir_out] = db_info('train','MFCC'); 
use_fuse =0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gmm_wm = read_gmm([wm_dir,'male\'],wm_file);
gmm_wf = read_gmm([wm_dir,'female\'],wm_file);

fp = fopen([dir_t,namelist],'r');
Filename = fscanf(fp,'%s\n', 2); 
no_test_files = 0;
while strcmp(Filename,'') ~= 1   
    no_test_files = no_test_files +1;
    Filename = fscanf(fp,'%s', 2);  %9  
end
fclose(fp);
no_test_files
correct = zeros(1,12); % 12 classes (accents)
conf = zeros(12,12, 'single'); % confusion Matrix
counts=zeros(1,12);
scores = zeros(1, 12); %  no of langauges (12)

fp = fopen([dir_t,namelist],'r'); 
ft= fopen([tar_dir,'true_lang_svm.dat'],'w');
ff= fopen([tar_dir,'imposter_lang_svm.dat'],'w');


for i = 1:no_test_files
    (i/no_test_files)*100
    Filename = fscanf(fp,'%s\n', 2);    
    Fnamein = [Filename(1:4),'.cep']; %(1:8)
    %Filename1 = fscanf(fp,'%s\n', 7);
    fin = fopen([tar_dir,Fnamein], 'r');
 if fin ~= -1 
     nd = fread(fin,2,'int');
     tdat = fread(fin,[nd(1),nd(2)],'float');
     fclose(fin); 
    
    %%%%%%%%%%%%%%%%%    
     switch   lower(Filename(5:end)) %(9:end)
       case 'english'
            langID = 1;
        case 'french'
            langID = 3;    
        case 'arabic'
            langID = 2;
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
            %warning('non-defined language');
            %return;
    end
    
    
 if langID > 0 && nd(2) == gmm_wm.dim    
    
    %fprintf(fg,'%s  %s  %d\n',Filename(1:8),lower(Filename(9:end)),AID); 
     
        
    counts(langID)= counts(langID)+1;   
  
   
    tdat = (tdat - ones(nd(1),1)*mean(tdat))./(ones(nd(1),1)*std(tdat));
    %gmm_wm.centres = gmm_wm.centres - ones(gmm_wm.mixtures,1)*mean(gmm_wm.centres,1);
    %gmm_wf.centres = gmm_wf.centres - ones(gmm_wf.mixtures,1)*mean(gmm_wf.centres,1); 
   
   
    [score_wm,topm] = probgmm_w(tdat,gmm_wm, 1);
    [score_wf,topf] = probgmm_w(tdat,gmm_wf, 1);
    
    if score_wm > score_wf 
        score_w = score_wm;
        top = topm;
        gender = 1; %male
        %gendir = 'male\';
        gmm_w = gmm_wm;
        
    else
        score_w = score_wf;
        top=topf;
        gender = 0; %female
        %gendir = 'female\';
        gmm_w = gmm_wf;        
    end
    
   xtest = Gen_SV_Test2(tdat,gmm_w);
   MD = gmm_w.dim*gmm_w.mixtures;
%    xtest = Gen_mcov_Test(tdat,gmm_w);
   xtest=xtest';
  
   
    sums = 0;
   for l=1:12 %12    
         if gender == 1
             
             SVM = read_SVM([dir_out{l},'male\'],svm_file);             
              
          else              
           
             SVM = read_SVM([dir_out{l},'female\'],svm_file);  

          end
          

         %%%%%%%%%%%%%%%%%%%%%%         
        score = svmval2(xtest',SVM.xsup,SVM.w,SVM.b,'GMM_SV',gmm_w,[]);
        scores(l) = score;         
        sums = sums + exp(score);          
        
   end
   
     
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        s = zeros(1,12); %12
        %ss = exp(scores);
      for k=1:12
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
              if mmx < scores(6)
                  mmx = scores(6);
              end
           end
          end
          
          s(k) = scores(k) - mmx;
      end %if 0
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
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
      end 
     
 end  

 end
  
end
fclose(fp); 
fprintf('\nTotal correct percentage = %4.2f percent of %d test segments.\n',sum(correct)*100/sum(counts),sum(counts));
fprintf('Correct percentage of each Language-Model\n');
for c = 1:12
fprintf('%d|%d  ',correct(c), counts(c));
end

fclose(ft);
fclose(ff);
%fwrite(ff,ldata,'float');
%fclose(fi);

fprintf('\n============================================================\n');

My_Det();

