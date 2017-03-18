function m = CDFInverse2( p)



if sum((p <= 0.0) + (p >= 1.0)) ~= 0
fprintf('Invalid input! input should be between 0 and 1\n');
end

sl = find(p<0.5);
sg = find(p>=0.5);

p(sl) = sqrt(-2*log(p(sl)));
p(sg) = sqrt(-2*log(1-p(sg))); 

m = RationalApproximation(p);
m(sl) = m(sl).*-1;
%ml = -1*RationalApproximation( sqrt(-2.0*log(p(sl))) );
%mg =  RationalApproximation( sqrt(-2.0*log(1-p(sg))) );



%%%%%%%%%%%%%%%%%%%%
function u =  RationalApproximation( t)

% The absolute value of the error should be less than 4.5 e-4.

t2 = t.^2;
o = ones(1,length(t)); 

 c = [2.515517, 0.802853, 0.010328];
 d = [1.432788, 0.189269, 0.001308];
u = t - ((c(3)*t2 + c(2)*t) + c(1)*o) ./ (d(3)*(t2.*t) + d(2)*t2 + d(1)*t + o);




