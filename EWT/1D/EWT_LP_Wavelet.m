function ymw=EWT_LP_Wavelet(wn,wm,aw,gamma,N)

%=========================================================
% function ymw=EWT_LP_Wavelet(wn,wm,gamma,N)
%
% Generate the 1D Littlewood-Paley wavelet in the Fourier
% domain associated to scale segment [-wm,-wn]U[wn,wm]with transition ratio 
% gamma.
% This function is used for both the real and complex case (the distinction
% is made via the provided aw).
%
% Input parameters:
%   -wn : lower boundary
%   -wm : upper boundary
%   -aw : frequency vector [0,pi)U[pi,0) for the real case or [0,2pi) for
%         the complex case
%   -gamma : transition ratio
%   -N : number of point in the vector
%
% Output:
%   -ymw: Fourier transform of the wavelet on the band [-wm,-wn]U[wn,wm]
%   for the real case or [wn,wm] for the complex case
%
% Author: Jerome Gilles
% Institution: SDSU - Department of Mathematics & Statistics
% Year: 2019
% Version: 2.0
%==========================================================
ymw=zeros(N,1);

if wn>pi
    a=1;
else
    a=0;
end
an=1/(2*gamma*abs(wn-a*2*pi));
pbn=wn+gamma*abs(wn-a*2*pi);
mbn=wn-gamma*abs(wn-a*2*pi);

if wm>pi
    a=1;
else
    a=0;
end
am=1/(2*gamma*abs(wm-a*2*pi));
pbm=wm+gamma*abs(wm-a*2*pi);
mbm=wm-gamma*abs(wm-a*2*pi);

for k=1:N
   if ((aw(k)>=pbn) && (aw(k)<=mbm))
       ymw(k)=1;
   elseif ((aw(k)>=mbm) && (aw(k)<=pbm))
       ymw(k)=cos(pi*EWT_beta(am*(aw(k)-mbm))/2);   
   elseif ((aw(k)>=mbn) && (aw(k)<=pbn))
       ymw(k)=sin(pi*EWT_beta(an*(aw(k)-mbn))/2);
   end
end