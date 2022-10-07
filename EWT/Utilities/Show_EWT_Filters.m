function Show_EWT_Filters(mfb,fs)

% ====================================================================
% function Show_EWT_Filters(mfb,f)
%
% This function plots each filter on top of the magnitude spectrum of f.
% The plots are on the frequency interval [-pi,pi).
% NOTE: the magnitude spectrum has been normalized!
%
% Inputs:
%   -mfb: EWT wavelet filters
%   -f: input signal
%
% Author: Jerome Gilles
% Institution: SDSU - Department of Mathematics & Statistics
% Year: 2019
% Version: 1.0
% =====================================================================

figure;
x=0:1/length(mfb{1}):(length(mfb{1})-1)/length(mfb{1});
x=2*pi*x-pi;
y = (0:length(mfb{1})-1)*fs/length(mfb{1});
N_2 = ceil(length(mfb{1})/2);
%don't plot more than 6 filters per figure
l=1;

    lm=5;


% ff=fftshift(abs(fft(f)));
% ff=ff/max(ff);

for k=1:length(mfb)-1
    hold on; 
    if isreal(mfb{k})
        box on
        hold on
        dummy = mfb{k};
        plot(y(1:N_2),dummy(1:N_2),'LineWidth',1.75);
        xlabel('Frequency(Hz)')
        ylabel('Magnitude')
        axis([0 50 0 1.5])
        grid on
        xticks([4 8 13 30 60])
        yticks([0 1])
        

    else
        hold on
        plot(x,fftshift(real(mfb{k})));
        title(['real part of mfb(',num2str(k),')'])
        subplot(lm,2,l+1); plot(x,ff,x,fftshift(imag(mfb{k})));
        title(['imaginary part of mfb(',num2str(k),')'])
        if mod(k,6) == 0
            figure;
            l=1;
        else
            l=l+2;
        end
    end
    legend('\delta rhythm','\theta rhythm','\alpha rhythm','\beta rhythm','\gamma rhythm')
end