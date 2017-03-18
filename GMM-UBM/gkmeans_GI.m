function [gmm, esq] = gkmeans_GI(dir, m, Init_centres )

%if ninarg < 3
 %   error('You need to specify number of GMM mixtures!');
%end

niters = 7;
max_err = 0.005;
%no_files = no_files + no_files;
GMM_WIDTH = 0.01;
%%%%%%%%%%%%%%%%%%
gmm.mixtures = m;
once = 1;
Start = 1;
total_N = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%
if m < 256
  ndiv = 1;
elseif m == 256
   ndiv = 2;
elseif m ==512
   ndiv = 1;
elseif m == 1024
   ndiv = 6;
elseif m == 2048
  ndiv = 16;
else
ndiv = 16;
end

[dir_in, dir_out, in_files] =  db_info();
%%%%%%%%%%%%%%%%%%%%%%%%%%
no_files = 0;
nums = zeros(1,12);
for id = 1:12 
 fp = fopen([dir_out{id},in_files{id}],'r');
 fname = fscanf(fp,'%s\n', 1); %9 
 while strcmp(fname,'') ~= 1   
    no_files = no_files +1;
    nums(id) = nums(id)+1;
    ff = fopen(fname, 'r'); 
       if ff == -1
           fprintf('%s\n',fname);
       end
       nd = fread(ff, 2, 'int');
       total_N = total_N + nd(1);
       fclose(ff);       
       
      if once == 1
        gmm.dim = nd(2);
        gmm.priors = zeros(1,m);
        gmm.centres = zeros(m,nd(2));    
        once = 0;
      end
    fname = fscanf(fp,'%s\n', 1);  %9  
 end
 fclose(fp);
end


if isempty(Init_centres)

%find initial centers randomly (from all data files)
fprintf('finding initial centres randomly ...\n');
        
    idx = 1;% - floor(no_files/12);
    flg = m;
    count =0;
    End = 0;
    c=0;
    start = 1;
    while(count < m)
        
        if idx  > 12             
            idx =  1;%ceil(rand*4);
            %fprintf('file index : %d \n',idx);
            
            if m > no_files
                flg = 1;
            end
        end
     if flg < no_files  
               
        fp = fopen([dir_out{idx},in_files{idx}], 'r');
        for k=1:ceil(rand*nums(idx))
           fname =  fscanf(fp,'%s\n', 1);
        end
     else
         if  start == 1            
           start =0;          
           fp = fopen([dir_out{idx},in_files{idx}], 'r');
           fname =  fscanf(fp,'%s\n', 1);
           c=1;
         else
            fname =  fscanf(fp,'%s\n', 1);
            c =c+1;
         end
     end

      if ~isempty(fname)       
        %fprintf('%d-processing file %s \n',count+1,fname);
        fin = fopen(fname, 'r');
        if fin == -1
            fprintf('%s\n',fname);
        end
        nd = fread(fin, 2, 'int');         
        if once == 1
          gmm.dim = nd(2);
          gmm.priors = zeros(1,m);
          gmm.centres = zeros(m,nd(2));
          %gmm.covars = zeros(m,nd(2));         
          once = 0;
        end
        x = fread(fin,[nd(1),nd(2)],'float');
        fclose(fin);
       %%%%%%%%%%%%%%%%%CMS%%%%%%%%%%%%%
      % x = (x - ones(nd(1),1)* mean(x))./(ones(nd(1),1)* std(x));
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       if  flg < no_files       
         count = count +1;
         gmm.centres(count,:) = x(ceil(rand*nd(1)),:); 
         %idx = idx + floor(no_files/24); 
         %for u =1:floor(no_files/24)
          % fname = fscanf(fp,'%s\n', 1); 
         %end
         idx = idx + 1;%floor(no_files/24); 
         fclose(fp);
         
       else
          End = End + floor(m/no_files); 
          rows = rand_gen(floor(m/no_files),nd(1));      
          gmm.centres(Start:End,:) = x(rows,:); 
          Start = End+1;    
          %rows = rand_gen((m-End),nd(1));
          %gmm.centres(Start:m,:) = x(rows,:);
          if c == nums(idx)
             idx = idx + 1;
             fclose(fp);
             start =1;
          end
          count = count + floor(m/no_files);
       end
       %fseek(fp,idx*length(fname),-1);
      end %if not empty
    end   
    %fclose(fp);


else
    gmm.centres = Init_centres;
    gmm.dim = size(Init_centres,2);
    gmm.mixtures = size(Init_centres,1);
    m= gmm.mixtures;
    gmm.priors = zeros(1,m);
end
 
%%%%%Start of the Kmeans Algorith%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%index = zeros(total_N,1,'single');
fprintf('start kmeans algorithm ...\n');
for itr = 1:niters % loop until max loops reached
%cluster_sizes = 0;    
e = 0;
counts = zeros(m,1);
means = zeros(m,gmm.dim);
gmm.covars = zeros(m,nd(2));   
%err = zeros(m,1,'single');


%fp = fopen(namelist, 'r');
for id = 1:12     
   fp = fopen([dir_out{id},in_files{id}], 'r'); 
   for j = 1:nums(id)
    fname = fscanf(fp,'%s\n', 1);    
    fin = fopen(fname, 'r');
    nd = fread(fin, 2, 'int');
    x = fread(fin,[nd(1),nd(2)],'float');
    fclose(fin);  
   %%%%%%%%%%%%%%%%%CMS%%%%%%%%%%%%%
  % x = (x - ones(nd(1),1)* mean(x))./(ones(nd(1),1)* std(x));
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %n1 = floor(nd(1)/2);
   index = zeros(nd(1),1);
   ss = 1;
   ee = 0;
  for p=1:(ndiv-1)       
     ee = ee + floor(nd(1)/ndiv);   
     z= dist2(x(ss:ee,:),gmm.centres);
     
     [minvals, index(ss:ee)] = min(z,[],2); 
     e = e + sum(minvals);
     clear minvals;
     ss = ee+1;
  end
     z= dist2(x(ss:nd(1),:),gmm.centres); 
         
     [minvals, index(ss:nd(1))] = min(z,[],2); 
     e = e + sum(minvals);
     clear minvals;
     
     
   for t = 1:m      
      s = index==t;        
      if sum(s) ~= 0                  
            counts(t) = counts(t) + sum(s);
            %gmm.centres(t,:) = sum(x(s,:),1) + gmm.centres(t,:); 
            means(t,:) =  sum(x(s,:),1) + means(t,:); 
            gmm.covars(t,:) = sum(x(s,:).^2,1) + gmm.covars(t,:);       
          
        %cluster_sizes = cluster_sizes + sum(s); %total cluster sizes      
      end
     
   end
   end % for j
   fclose(fp);
end
%fclose(fp);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%gmm.centres = means./(counts*ones(1,gmm.dim));
for v=1:m
    if itr < 2 && counts(v)==min(counts)
        [count,h_row] = max(counts);
        gmm.centres(v,:) = ((means(h_row,:)./(counts(h_row)*ones(1,gmm.dim)))+ gmm.centres(v,:))./2;
        
    else
        gmm.centres(v,:) = means(v,:)./(counts(v)*ones(1,gmm.dim));
    end
end


if itr>1 && abs(old_e - e) < max_err*total_N
        break;    
else
    if itr > 1
        fprintf('diff = %f.  our threshold is %f\n',abs(old_e-e),max_err*total_N);
    end
   old_e = e;
end
fprintf('kmeans iteration no %d with error %11.6f .\n',itr,e);
end %end of max iterations niters

%initializing the weights and the variances 
fprintf('initializing the weights and the variances ...\n');
%make sure that no priors is zero
counts = counts + (counts == 0);
for j=1:m     
            
       gmm.covars(j,:)=(gmm.covars(j,:)/counts(j))-gmm.centres(j,:).^2;
       gmm.priors(j)=counts(j)/sum(counts);        
      
      % Replace small entries by GMM_WIDTH value
      a = gmm.covars(j, :);
      a(a <= GMM_WIDTH) = GMM_WIDTH;
      gmm.covars(j, :) = a;
     % gmm.covars(j, :) = gmm.covars(j, :) + GMM_WIDTH .*(gmm.covars(j, :)<GMM_WIDTH);
end

   %gmm.priors = gmm.priors';
   esq = e;
   filename = ['kmeans_',int2str(gmm.mixtures),'_gi.gmm'];
   save_gmm(dir,gmm, filename);
   
