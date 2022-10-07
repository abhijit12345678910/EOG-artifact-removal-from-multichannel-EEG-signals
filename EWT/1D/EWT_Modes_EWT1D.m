function rec=EWT_Modes_EWT1D(ewt,mfb)

%==================================================================
% function rec=EWT_Modes_EWT1D(ewt,mfb)
%
% This function reconstruct the IMFs: IMF(i)=ewt(i)psi(i) (or phi)
%
% Inputs:
%   -ewt: the EWT components
%   -mfb: filter bank used to generate the EWT
%
% Output:
%		-rec: reconstructed IMFs
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2012
% Version: 1.0
%==================================================================

rec=cell(size(ewt));

for k=1:length(ewt)
    rec{k}=zeros(length(ewt{1}),1);
    rec{k}=real(ifft(fft(ewt{k}).*mfb{k}));
end
