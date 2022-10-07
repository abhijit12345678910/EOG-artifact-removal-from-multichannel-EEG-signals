function mfb=EWT_LP_FilterBank(boundaries,N,cpx)

% =========================================================================
% function mfb=EWT_LP_FilterBank(boundaries,N,cpx)
%
% This function generate the Littlewood-Paley filter bank (scaling function
% + wavelets) corresponding to the provided set of frequency segments
%
% Input parameters:
%   -boundaries: vector containing the boundaries of frequency segments (0
%                and pi must NOT be in this vector)
%   -N: signal length
%   -cpx: 1 if the original signal was complex, 0 otherwise
%
% Output:
%   -mfb: cell containing each filter (in the Fourier domain), the scaling
%         function comes first and then the successive wavelets
%
% Author: Jerome Gilles
% Institution: SDSU - Department of Mathematics & Statistics
% Year: 2019
% Version: 2.0
% =========================================================================

Npic=length(boundaries);

% We compute gamma accordingly to the theory
gamma=1;
for k=1:Npic-1
    if ((boundaries(k)<=pi) && (boundaries(k+1)>pi))
        r=min((boundaries(k+1)-pi)/(boundaries(k+1)+pi), ...
            (pi-boundaries(k))/(pi+boundaries(k))); 
    else
        r=(boundaries(k+1)-boundaries(k))/(boundaries(k+1)+boundaries(k));
    end
    if r<gamma 
       gamma=r;
    end
end

if cpx==0
    r=(pi-boundaries(Npic))/(pi+boundaries(Npic));
else
    r=(2*pi-boundaries(Npic))/(2*pi+boundaries(Npic));
end

if r<gamma 
    gamma=r; 
end
gamma=(1-1/N)*gamma; %this ensure that gamma is chosen as strictly less than the min

%create the frequency axis [0,2pi)
Mi=floor(N/2);
w=(0:2*pi/N:2*pi-2*pi/N)';

if cpx==0
    %make the second half of the axis be negative frequencies
    w(Mi+1:end)=-2*pi+w(Mi+1:end); 
    w=abs(w);
    mfb=cell(Npic+1,1);
    % We start by generating the scaling function
    mfb{1}=EWT_LP_Scaling(boundaries(1),w,gamma,N);

    % We generate the wavelets
    for k=1:Npic-1
        mfb{k+1}=EWT_LP_Wavelet(boundaries(k),boundaries(k+1),w,gamma,N); 
    end
    mfb{Npic+1}=EWT_LP_Wavelet_last(boundaries(Npic),w,gamma,N);
else
    mfb=cell(Npic+1,1);
    % We start by generating the scaling function 
    %(here we assume the 0 is not a possible boundary - COULD CHANGE IN THE FUTURE)
    mfb{1}=EWT_LP_Scaling_cpx(boundaries(1),boundaries(end),w,gamma,N);
    
    % We generate the wavelets
    shift=0;
    for k=1:Npic-1
        %check if we transition to the second half of the axis
        if ((boundaries(k)<=pi) && (boundaries(k+1)>pi)) 
            mfb{k+1+shift}=EWT_LP_Wavelet_cpx_HFlow(boundaries(k),w,gamma,N);
            mfb{k+2+shift}=EWT_LP_Wavelet_cpx_HFup(boundaries(k+1),w,gamma,N);
            shift=1;
        else
            mfb{k+1+shift}=EWT_LP_Wavelet(boundaries(k),boundaries(k+1),w,gamma,N); 
        end
    end
end