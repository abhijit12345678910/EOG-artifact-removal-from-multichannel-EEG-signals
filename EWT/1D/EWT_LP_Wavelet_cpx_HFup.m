function ymw=EWT_LP_Wavelet_cpx_HFup(wn,aw,gamma,N)

%=========================================================
% function ymw=EWT_LP_Wavelet_cpx_HFup(wn,aw,gamma,N)
%
% Generate the 1D Littlewood-Paley wavelet in the Fourier
% domain associated to scale segment [pi,wn] (or equivalently [-pi,wn-2pi])
% with transition ratio gamma.
% This function is used for the complex case, i.e asymmetric filter.
%
% Input parameters:
%   -wn : lower boundary
%   -aw : frequency vector [0,2pi)
%   -gamma : transition ratio
%   -N : number of point in the vector
%
% Output:
%   -ymw: Fourier transform of the wavelet on the band [pi,wn]
%
% Author: Jerome Gilles
% Institution: SDSU - Department of Mathematics
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

for k=1:N
   if ((aw(k)>pi) && (aw(k)<=mbn))
       ymw(k)=1;
   elseif ((aw(k)>=mbn) && (aw(k)<=pbn))
       ymw(k)=cos(pi*EWT_beta(an*(aw(k)-mbn))/2);
   end
end