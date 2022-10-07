function Show_EWT(ewt,f,rec)

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
l=1;
%don't plot more than 6 component per figure for clarity reasons
if length(ewt)>5
    lm=5;
else
    lm=length(ewt);
end

for k=1:length(ewt)
    if isreal(ewt{k})
        hold on;
        dummy = ewt{k};
        subplot(lm,1,l); plot(dummy(1:1000)); 
        title(['ewt(',num2str(k),')'])
        %%to get a commomn xlabel and y label
        han=axes(fig,'visible','off'); 
        han.Title.Visible='on';
        han.XLabel.Visible='on';
        han.YLabel.Visible='on';
        ylabel(han,'Amplitude');
        xlabel(han,'Samples');
        title(han,'EWT Components');
        if mod(k,5) == 0
            figure;
            l=1;
        else
            l=l+1;
        end
    else
        hold on; 
        subplot(lm,2,l); plot(x,real(ewt{k})); 
        title(['real part of ewt(',num2str(k),')'])
        subplot(lm,2,l+1);plot(x,imag(ewt{k})); 
        title(['imaginary part of ewt(',num2str(k),')'])
        if mod(k,6) == 0
            figure;
            l=1;
        else
        l=l+2;
        end
    end
end

%These lines plot f and its reconstruction
if nargin>1
    figure;
    if isreal(f)
        subplot(2,1,1);plot(x,f); title('f')
        subplot(2,1,2);plot(x,rec); title('rec')
    else
        subplot(2,2,1);plot(x,real(f)); title('real part of f')
        subplot(2,2,2);plot(x,imag(f)); title('imaginary part of f')
        subplot(2,2,3);plot(x,real(rec)); title('real part of rec')
        subplot(2,2,4);plot(x,imag(rec)); title('imaginary part of rec')
    end
end
