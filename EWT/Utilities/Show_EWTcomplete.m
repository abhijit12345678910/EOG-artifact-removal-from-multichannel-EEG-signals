function Show_EWTcomplete(ewt,f,fs,eeg_sig)

% ====================================================================
% function Show_EWT(ewt,f,rec)

%These lines plot the EWT components
fig = figure;
x=0:1/length(ewt{1}):(length(ewt{1})-1)/length(ewt{1});
y = (0:length(ewt{1})-1)*fs/length(ewt{1});
N_2 = ceil(length(ewt{1})/2);
l=1;
rhythms = ["delta", "theta", "alpha","beta","gamma"] ;
ti= ["z","z","(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)","(i)","(j)"];
%don't plot more than 6 component per figure for clarity reasons
lm=6;
z=2;
subplot(lm,2,[1,2]);
plot(eeg_sig(1,end-2000:end))
axis tight
hold on
xlabel('Samples')
for k=1:length(ewt)
   
    %ylabel('Amplitude')
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
        ylabel(han,'Amplitude');
        
    end
end



end
