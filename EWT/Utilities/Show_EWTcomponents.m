function Show_EWTcomponents(ewt,f,fs,eeg_sig)

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
ti= ["(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)","(i)","(j)"];
z=0;
for k=1:length(ewt)
    if k <= 5
        hold on;
        z=z+1;
        dummy = ewt{k};
        subplot(lm,1,z); 
        plot(dummy(end-2000:end));
        axis tight
        title(ti(z))
        %%to get a commomn xlabel and y label
        han=axes(fig,'visible','off'); 
        han.Title.Visible='on';
        han.XLabel.Visible='on';
        han.YLabel.Visible='on';
        ylabel(han,'Amplitude');
        xlabel(han,'Samples');
    end
end       


end
