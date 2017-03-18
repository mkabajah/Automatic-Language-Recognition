function [score, top,act] = probgmm_w(data, gmm, n,ndiv)

if nargin < 3
  n= 1;
end
if nargin < 4
 ndiv = 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 1
ndata = size(data, 1);
act=zeros(ndata,gmm.mixtures); %[];
St = 1;
Ed = 0;
for p =1:(ndiv-1)
    Ed = Ed + floor(ndata/ndiv);     
    act(St:Ed,:) = double(gmmactf3(gmm, data(St:Ed,:))); %[act;--]
    St=Ed+1;
end    
act(St:ndata,:) = double(gmmactf3(gmm, data(St:ndata,:)));  %[act;---]

% act = gmmactf3(gmm,data);
% act = double(act);


s = sum(act, 2);
if any(s==0)
  % warning('Some zero posterior probabilities\n')
   % Set any zeros to one before dividing
   zero_rows = find(s==0);
   s = s + (s==0);
   act(zero_rows, :) = 1/(gmm.mixtures);
end

score = sum(log(s))/ndata;

 if n > 1
  [~,top] = sort(act,2,'descend');
  top = top(:,1:n);
 else
    [~,top] = max(act,[],2);
 end



if nargout > 2
%gammas = act./(s*ones(1, gmm.mixtures));
act = bsxfun(@rdivide,act,s);
end


end %if 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if 0
data = data';
w = gmm.priors';
m = gmm.centres';
v = gmm.covars';

n_mixtures  = size(w, 1);
n_frames    = size(data, 2);
dim         = size(data, 1);

% precompute the model g-consts and normalize the weights
a = w ./ (((2*pi)^(dim/2)) * sqrt(prod(v)'));

gammas = zeros(n_mixtures, n_frames); 

for ii =1:n_mixtures 
  gammas(ii,:) = gaussian_function(data, a(ii), m(:,ii), v(:,ii));
end
gamasum = sum(gammas,1);

if any(gamasum==0)
   warning('Some zero posterior probabilities\n')
   % Set any zeros to one before dividing
   zero_colms = gamasum==0;
   gamasum = gamasum + (gamasum==0);
   gammas(:,zero_colms) = 1/n_mixtures;
end

score = sum(log(gamasum))/n_frames;
if nargout > 1
  [mx,top] = max(gammas,[],1);
end

if nargout > 2
  % normalize
  gammas=bsxfun(@rdivide, gammas, gamasum);
  gammas = gammas';
end

end %if 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

%for t=1:top_n 
 %for j=1:gmm.mixtures
 % idx = find(temp == max(temp));
 % top(t) = max(idx);
 % temp(max(idx)) = 0;
 %end
    
 %end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if 0
[act,score] = gpu_post2(gmm,data);
score = score/size(data,1);
[~,top] = max(act,[],2);
end
 