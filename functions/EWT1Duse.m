function [ewt,mfb,boundaries,ff]=EWT1Duse(f,params,fs)

% =========================================================================
% function [ewt,mfb,boundaries]=EWT1D(f,params)
% 
% Perform the Empirical Wavelet Transform of f over Nscale scales. See 
% also the documentation of EWT_Boundaries_Detect for more details about
% the available methods and their parameters.
%
% Inputs:
%   -f: the input signal
%   -params: structure containing the following parameters:
%       -params.log: 0 or 1 to indicate if we want to work with
%                    the log spectrum
%       -params.preproc: 'none','plaw','poly','morpho,'tophat'
%       -params.method: 'locmax','locmaxmin','locmaxminf','adaptive',
%                       'adaptivereg','scalespace'
%       -params.reg: 'none','gaussian','average','closing'
%       -params.lengthFilter: width of the above filters
%       -params.sigmaFilter: standard deviation of the above Gaussian
%                            filter
%       -params.N: maximum number of supports
%       -params.degree: degree of the polynomial (needed for the
%                       polynomial approximation preprocessing)
%       -params.completion: 0 or 1 to indicate if we try to complete
%                           or not the number of modes if the detection
%                           find a lower number of mode than params.N
%       -params.InitBounds: vector of initial bounds (in index domain)
%                           needed for the adaptive and adaptivereg methods
%				-params.typeDetect: (for scalespace method only) 'otsu',
%                           'halfnormal','empiricallaw','mean','kmeans'
%
% Outputs:
%   -ewt: cell containing first the low frequency component and
%         then the successives frequency subbands
%   -mfb: cell containing the filter bank (in the Fourier domain)
%   -boundaries: vector containing the set of boundaries corresponding
%                to the Fourier line segmentation (normalized between
%                0 and Pi)
%
% Author: Jerome Gilles
% Institution: SDSU - Department of Mathematics
% Year: 2019
% Version: 4.0
% =========================================================================

%% Boundary detection
% We compute the Fourier transform of f
ff=fft(f);
% We extract the boundaries of Fourier segments
boundaries =[4 8 13 30 60]; % boundaries in HZ 
boundaries = boundaries *length(ff)/fs; %boundaries in bins
if isreal(f)
    %disp('Real signal');
    
    boundaries = boundaries*pi/round(length(ff)/2);
else
    disp('Complex signal');
   
    boundaries = boundaries*2*pi/length(ff);
    
    %if a a boundary is too close to pi, we remove it
    Nb=length(boundaries);
    n=1;
    while n<=Nb
       if abs(boundaries(n)-pi)<10*pi/length(f)
          boundaries = [boundaries(1:n-1);boundaries(n+1:end)];
          n=n-1;
          Nb=Nb-1;
       end
       n=n+1;
    end
end


% We build the corresponding filter bank
mfb=EWT_LP_FilterBank(boundaries,length(ff),~isreal(f));

% We filter the signal to extract each subband
ewt=cell(length(mfb),1);
if isreal(f)
    for k=1:length(mfb)
        ewt{k}=real(ifft(conj(mfb{k}).*ff));
    end
    
else
    for k=1:length(mfb)
        ewt{k}=ifft(conj(mfb{k}).*ff);
    end
    
end


