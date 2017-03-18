function score = probgmm(data, gmm, top)


ndata = size(data, 1);
act = zeros(ndata,1);
normal = (2*pi)^(gmm.dim/2);
s = prod(sqrt(gmm.covars), 2);
 

for n = 1:ndata
  diff2 = (data(n,:) - gmm.centres(top(n),:)).^2;
  act(n) = gmm.priors(top(n))*exp(-0.5*sum(diff2./gmm.covars(top(n),:))) ./(normal*s(top(n)));
end


prob = sum(act,2);
prob = prob + (prob==0);
if length(prob) > 1000
prob = sort(prob); lmt = floor(0.05*ndata);
prob = prob(lmt:end);
end

score =  sum(log(prob))/ndata;
 
 