function rec=iEWT1D(ewt,mfb,cpx)

% ======================================================================
% function rec=iEWT1D(ewt,mfb,cpx)
% 
% Perform the Inverse Empirical Wavelet Transform of ewt accordingly to
% the filter bank mfb
%
% Inputs:
%   -ewt: cell containing the EWT components
%   -mfb: filter bank used during the EWT
%   -cpx: 0 is the reconstructed signal is supposed to be real, 1 otherwise
%
% Outputs:
%   -rec: reconstructed signal
%
% Author: Jerome Gilles
% Institution: SDSU - Department of Mathematics & Statistics
% Year: 2019
% Version: 2.0
% ======================================================================


%We perform the adjoint operator to get the reconstruction
rec=zeros(length(ewt{1}),1);
for k=1:length(ewt)
    if cpx==0
        rec=rec+real(ifft(fft(ewt{k}).*mfb{k}));
    else
        rec=rec+ifft(fft(ewt{k}).*mfb{k});
    end
end