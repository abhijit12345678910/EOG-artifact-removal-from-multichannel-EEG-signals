function yms=EWT_LP_Scaling(w1,aw,gamma,N)

%==================================================
% function ymw=EWT_LP_Scaling(w1,aw,gamma,N)
%
% Generate the 1D Littlewood-Paley wavelet in the Fourier
% domain associated to the segment [-w1,w1] with transition ratio gamma.
% This function is used for the real case, i.e generate a symmetric filter.
%
% Input parameters:
%   -w1 : boundary
%   -aw : frequency vector [0,pi)U[pi,0)
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

an=1/(2*gamma*w1);
pbn=(1+gamma)*w1;
mbn=(1-gamma)*w1;

for k=1:N
   if (aw(k)<=mbn)
       yms(k)=1;
   elseif ((aw(k)>=mbn) && (aw(k)<=pbn))
       yms(k)=cos(pi*EWT_beta(an*(aw(k)-mbn))/2);
   end
end