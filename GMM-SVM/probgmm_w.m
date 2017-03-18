function [score, top] = probgmm_w(data, gmm, top_n)

top = zeros(top_n,1);
ndata = size(data, 1);
act = zeros(ndata, gmm.mixtures);  % Preallocate matrix

  normal = (2*pi)^(gmm.dim/2);
  s = prod(sqrt(gmm.covars), 2);
 
for j = 1:gmm.mixtures
   
     diffs = data - (ones(ndata, 1) * gmm.centres(j, :));    
     act(:, j) = exp(-0.5*sum((diffs.*diffs)./(ones(ndata, 1) * ...
      gmm.covars(j, :)), 2)) ./ (normal*s(j));
    act(:,j) = act(:,j).*(gmm.priors(j)*ones(ndata,1));
   
end
  
 %prob = act*(gmm.priors)'; 
 prob = sum(act,2); 
 score =  sum(log(prob))/ndata;
 
 %act = act .* (ones(ndata,1)*gmm.priors);
 [mx,top] = max(act,[],2);

%for t=1:top_n 
 %for j=1:gmm.mixtures
 % idx = find(temp == max(temp));
 % top(t) = max(idx);
 % temp(max(idx)) = 0;
 %end
    
 %end

 