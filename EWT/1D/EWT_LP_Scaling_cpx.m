function yms=EWT_LP_Scaling_cpx(w1,w2,aw,gamma,N)

%==================================================
% function ymw=EWT_LP_Scaling_cpx(w1,w2,aw,gamma,N)
%
% Generate the 1D Littlewood-Paley complex scaling filter in the Fourier
% domain associated to the segment [0,w1]U[w2,2pi] (or equivalently
% [w2-2pi,w1]) with transition ratio gamma.
% This function is used for the complex case, i.e asymmetric filter.
%
% Input parameters:
%   -w1 : boundary (closest boundary to 0)
%   -w2 : boundary (closest boundary to 2pi)
%   -aw : frequency vector [0,2pi)
%   -gamma : transition ratio
%   -N : number of point in the vector
%
% Output:
%   -yms: Fourier transform of the scaling function
%
% Author: Jerome Gilles
% Institution: SDSU - Department of Mathematics & Statistics
% Year: 2019
% Version: 2.0
%===================================================
yms=zeros(N,1);

if w1>pi
    a=1;
else
    a=0;
end
an=1/(2*gamma*abs(w1-a*2*pi));
pbn=w1+gamma*abs(w1-a*2*pi);
mbn=w1-gamma*abs(w1-a*2*pi);

if w2>pi
    a=1;
else
    a=0;
end
am=1/(2*gamma*abs(w2-a*2*pi));
pbm=w2+gamma*abs(w2-a*2*pi);
mbm=w2-gamma*abs(w2-a*2*pi);

for k=1:N
   if ((aw(k)<=mbn) || (aw(k)>=pbm))
       yms(k)=1;
   elseif ((aw(k)>=mbn) && (aw(k)<=pbn))
       yms(k)=cos(pi*EWT_beta(an*(aw(k)-mbn))/2);
   elseif ((aw(k)>=mbm) && (aw(k)<=pbm))
       yms(k)=sin(pi*EWT_beta(am*(aw(k)-mbm))/2);
   end
end