function tf=EWT_TF_Plan(ewt,boundaries,Fe,sig,rf,rt,resf,color)
%==========================================================================
% function tf=EWT_TF_Plan(ewt,boundaries,Fe,sig,rf,rt,resf,color)
%
% NOTE: this function works only for the REAL signals.
%
% This function plots the instantaneous amplitude of each EWT component in 
% the Time-Frequency domain. Each amplitude is requantified between 0 and
% 255 (e.g in this representation, the energy level between two components
% are NOT comparable!). 
%
% Inputs:
%   -ewt: components provided by the EWT transform
%   -boundaries: filters boundaries provided by the EWT transform
%   -cpx: 1 if the original signal was complex, 0 otherwise
%   -Fe: sampling frequency (1=normalized frequency)
%   -sig: input signal used in the EWT transform 
%         (if sig=[] then only the TF plane is plotted)
%   -rf: plot only the frequency range [0:Fe/(2rf)] 
%        (if rf<1 or rf=[] then the default value 1 is used)
%   -rt: plot only the time range [0:length(signal)/rt] 
%        (if rt<1 or rt=[] then the default value 1 is used)
%   -resf: by default the full frequency resolution is used (e.g. the
%          frequency axis is sampled over Nf points where if the number of 
%          samples in the instantaneous time series divided by 2). If you 
%          set resf to any number >1 then the frquency axis is downsampled 
%          to the closest integer of Nf/resf points. If resf<1 or resf=[] 
%          then the default value 1 is used.
%   -color: 1 = plot in color, 0 = plot in grayscale (default [] in color)
%
% Output:
%   -tf: matrix containing the image of the time-frequency plane
%		-"figure plot"
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2014
% Version: 1.0
%==========================================================================

% Fix the parameters default values if needed
if (rf<1)
    rf=1;
elseif isempty(rf)
    rf=1;
end

if (rt<1)
    rt=1;
elseif isempty(rt)
    rt=1;
end

if (Fe<0)
    Fe=1;
elseif isempty(Fe)
    Fe=1;
end

if (resf<1)
    resf=1;
elseif isempty(resf)
    resf=1;
end

if isempty(color)
    color=1;
elseif (color~=1) && (color~=0)
    color=1;
end

if size(boundaries,1)<size(boundaries,2)
    boundaries = boundaries';
end

% compute the instantaneous components (amplitude and frequencies)
hilb=EWT_InstantaneousComponents(ewt,boundaries);

Nt=length(hilb{1,2});
Nf=round(length(hilb{1,2})/(2*resf));
tf=zeros(Nf,Nt);
for c=1:size(hilb,1)
   requantified=floor(hilb{c,2}*(Nf-1)/pi)+1;
   requantified(requantified>Nf)=Nf;
   for t=1:Nt
        M=max(hilb{c,1}(:));
        m=min(hilb{c,1}(:));
        % plot requantified amplitude at the position (t,fc(t))
        tf(requantified(t),t)=255*(hilb{c,1}(t)-m)/(M-m);
        %tf(requantified(t),t)=log(1+hilb{c,1}(t));
        %tf(requantified(t),t)=hilb{c,1}(t);
   end
end

% Prepare the figure
tq = 1:floor(Nt/rt);
t=(tq-1)/Fe;

if color == 0
    figure('colormap', 1.-gray);
else
    figure;
end


if isempty(sig)
    imagesc(t,[0,0.5*Fe/rf],tf(1:floor(end/rf),tq));
    xlabel('time (s)')
    ylabel('frequency (Hz)')   
    set(gca,'YDir','normal')
else 
    subplot(6,1,2:6);
    imagesc(t,[0,0.5*Fe/rf],tf(1:floor(end/rf),tq));

    set(gca,'YDir','normal')
    xlabel('time (s)')
    ylabel('frequency (Hz)')

    subplot(6,1,1); plot(t,sig(tq),'Color','Black');
    subplot(6,1,1); plot(t,sig(tq));
    axis([t(1) t(end) min(sig) max(sig)]);
end
