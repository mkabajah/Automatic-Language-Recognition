function K = new_GMMkernel(x,xsup,UBM,V)


if nargin<4
    V=[];
end;


if nargin<2
    xsup=x;
end;
if nargin<3
    error('UBM Model is needed!')
end;
if isempty(xsup)
    xsup=x;
end;
MD = UBM.dim*UBM.mixtures;
with_w=0;
if size(x,2) ~= MD
    wx = x(:,MD+1:end);
    wxsup = xsup(:,MD+1:end);
    with_w = 1;
    x=x(:,1:MD);
    xsup = xsup(:,1:MD);
end

[n1 md1]=size(x);
[n2 md2]=size(xsup);
if md2 ~= md1
    error('Data and Support Vectors have different dimention!')
end

%gx = GPUdouble(x); clear x;
%gxsup = GPUdouble(xsup); clear xsup;

covars = (UBM.covars)';
covars = (covars(:)');
x = bsxfun(@rdivide,x,covars);
%matdvec(gx,gcovars,gx);

priors = repmat((UBM.priors),UBM.dim,1);
priors = (priors(:)');
x = bsxfun(@times,x,priors);
%matxvec(gx,gpriors,gx);
if with_w
    x=[x,wx];
    xsup = [xsup,wxsup];
end


if isempty(V)
   K = (x*xsup');
   %K = svmkernel(x,'htrbf',[1,1],xsup);

else
    K = x*(eye(md1)-V'*V)*xsup';
end
