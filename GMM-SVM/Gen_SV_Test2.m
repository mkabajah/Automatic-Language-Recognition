function  out =  Gen_SV_Test2(x,gmm,r)

%nfiles = 20;
if nargin < 3
   r = 16;
end
%%%%%%%%%%%%%%%%%%%%%%%%

UBM_means = gmm.centres;
 
%       post = gpu_post2(gmm, x);
      [post,e] = gaussian_posteriors(x',gmm.centres',gmm.covars',gmm.priors');
      post = double(post');      
      pk =  sum(post, 1);
      xpk =  post'*x;  
       
 
% Now move new estimates to old parameter vectors
pk = pk + (pk==0);
xpk = xpk ./ (pk' * ones(1, gmm.dim));

pk = pk ./ (pk + r);
new_means = (pk' * ones(1, gmm.dim)).*xpk  +  ((1-pk)'*ones(1,gmm.dim)).*UBM_means ;

new_means = new_means';
new_means = new_means(:);

out = new_means';

