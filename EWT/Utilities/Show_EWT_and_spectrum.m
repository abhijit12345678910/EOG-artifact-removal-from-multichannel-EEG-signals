function Show_EWT_and_spectrum(ewt,f,fs)

% ====================================================================
% function Show_EWT(ewt,f,rec)
%
% This function plots the successive filtered components (low scale 
% first and then wavelets scales). The original and
% reconstructed signals are plotted on a different graph.
% If f and rec are provided, it also plot the original and reconstructed
% signals on a separate figure
%
% Inputs:
%   -ewt: EWT components
%   -f: input signal  (OPTIONNAL)
%   -rec: reconstructed signal (OPTIONNAL)
%
% Author: Jerome Gilles
% Institution: SDSU - Department of Mathematics & Statistics
% Year: 2019
% Version: 2.0
% =====================================================================

%These lines plot the EWT components
fig = figure;
x=0:1/length(ewt{1}):(length(ewt{1})-1)/length(ewt{1});
y = (0:length(ewt{1})-1)*fs/length(ewt{1});
N_2 = ceil(length(ewt{1})/2);
l=1;
rhythms = ["delta", "theta", "alpha","beta","gamma"] ;
ti= ["(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)","(i)","(j)"];
%don't plot more than 6 component per figure for clarity reasons
lm=5;
z=0;
for k=1:length(ewt)
    if k <= 5
        hold on;
        z=z+1;
        dummy = ewt{k};
        dummy2 = abs(fft(ewt{k}));
        subplot(lm,2,z); 
        plot(dummy(end-2000:end));
        axis tight
        
        title(ti(z))
        z = z+1;
        subplot(lm,2,z); 
        plot(y(1:N_2),dummy2(1:N_2)); 
        title(ti(z))
        %%to get a commomn xlabel and y label
        han=axes(fig,'visible','off'); 
        han.Title.Visible='on';
        han.XLabel.Visible='on';
        han.YLabel.Visible='on';
        ylabel('Amplitude');
    end
end
end
