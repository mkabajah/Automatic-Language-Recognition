function y = m_norm(xd,gmm)

[d,n] = size(xd);
MD = gmm.mixtures*gmm.dim;
x = xd(1:MD,:);
y = zeros(MD,n,'single');


for i=1:n
 mu = reshape(x(:,i),gmm.dim, gmm.mixtures)';
 temp = (gmm.centres - mu).^2;
 temp = temp./gmm.covars;
 dist = sum(temp,2);
 dist = dist.*gmm.priors';
 dist = 0.5*sum(dist);
 mu = (1/dist).*mu + (1-1/dist).*gmm.centres;
 mu = mu';
 mu= mu(:);
 y(:,i) = mu';
end
if d > MD
   y = [y;xd(MD+1:end,:)];
end