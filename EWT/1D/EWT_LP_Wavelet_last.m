function ymw=EWT_LP_Wavelet_last(wn,aw,gamma,N)

%=========================================================
% function ymw=EWT_LP_Wavelet_last(wn,aw,gamma,N)
%
% Generate the 1D Littlewood-Paley wavelet in the Fourier
% domain associated to scale segment [wn,pi]U[-pi,-wn] with transition 
% ratio gamma.
% This function is used for the real case, i.e generate a symmetric filter.
%
% Input parameters:
%   -wn : lower boundary
%   -aw : frequency vector [0,pi)U[pi,0)
%   -gamma : transition ratio
%   -N : number of point in the vector
%
% Output:
%   -ymw: Fourier transform of the wavelet on the band [wn,pi]U[-pi,-wn]
%
% Author: Jerome Gilles
% Institution: SDSU - Department of Mathematics
% Year: 2019
% Version: 2.0
%==========================================================
ymw=zeros(N,1);

an=1/(2*gamma*wn);
pbn=(1+gamma)*wn;
mbn=(1-gamma)*wn;

for k=1:N
   if (aw(k)>=pbn)
       ymw(k)=1;
   elseif ((aw(k)>=mbn) && (aw(k)<=pbn))
       ymw(k)=sin(pi*EWT_beta(an*(aw(k)-mbn))/2);
   end
end