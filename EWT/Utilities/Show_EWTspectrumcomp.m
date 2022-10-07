function Show_EWTspectrumcomp(ewt,f,fs,eeg_sig)

fig = figure;
x=0:1/length(ewt{1}):(length(ewt{1})-1)/length(ewt{1});
y = (0:length(ewt{1})-1)*fs/length(ewt{1});
N_2 = ceil(length(ewt{1})/2);
l=1;
lm=6;
ti = ["(a)","(g)","(b)","(h)","(c)","(i)","(d)","(j)","(e)","(k)","(f)","(l)"];
z=2;
subplot(lm,2,1);
plot(eeg_sig(1,end-2000:end),'color','k')
xticks([])
colororder({'k'});
%title(ti(1),'fontsize',11)
% yyaxis right
% 
% yticks([])
% ylabel(ti(1),'color','k','fontsize',12)
% ylh = get(gca,'ylabel');
% ylp = get(ylh, 'Position');
% ext=get(ylh,'Extent');
% set(ylh, 'Rotation',0, 'Position',ylp+[ext(3)-730 0.15 0]);

axis tight
hold on;
eegfft = abs(fft(eeg_sig(1,:)));
subplot(lm,2,2);
plot(y(1:N_2),eegfft(1:N_2),'color','k'); 
xticks([])
%title(ti(2),'fontsize',11)
% yyaxis right
% yticks([])
% ylabel(ti(2),'color','k','fontsize',12);%,'FontWeight','bold')
% ylh = get(gca,'ylabel');
% ylp = get(ylh, 'Position');
% ext=get(ylh,'Extent');
% set(ylh, 'Rotation',0, 'Position',ylp+[ext(3)-7 0.15 0])
% colororder({'k'})
axis tight
hold on;
for k=1:length(ewt)
    if k <= 5
        hold on;
        z=z+1;
        dummy = ewt{k};
        subplot(lm,2,z); 
        plot(dummy(end-1200:end),'color','k');
        if (k~=5)
            xticks([])
        end
        axis tight
        %title(ti(z),'fontsize',11)
%         yyaxis right
%         yticks([])
%         ylabel(ti(z),'color','k','fontsize',12)
%         ylh = get(gca,'ylabel');
%         ylp = get(ylh, 'Position');
%         ext=get(ylh,'Extent');
%         set(ylh, 'Rotation',0, 'Position',ylp+[ext(3)-170 0.15 0])
% %         set(get(gca,'ylabel'),'rotation',0,'VerticalAlignment','middle','Position')
%         colororder({'k'})
        hold on;
        z=z+1;
        dummy2 = abs(fft(ewt{k}));
        subplot(lm,2,z); 
        plot(y(1:N_2),dummy2(1:N_2),'color','k');
        if (k~=5)
            xticks([])
        end
        %title(ti(z),'fontsize',11)
%         yyaxis right
%         yticks([])
%         ylabel(ti(z),'color','k','fontsize',12)
%         ylh = get(gca,'ylabel');
%         ylp = get(ylh, 'Position');
%         ext=get(ylh,'Extent');
%         set(ylh, 'Rotation',0, 'Position',ylp+[ext(3)-7 0.15 0])
%         colororder({'k'})
        %%to get a commomn xlabel and y label
        han=axes(fig,'visible','off'); 
        han.Title.Visible='on';
        han.XLabel.Visible='on';
        han.YLabel.Visible='on';
        ylabel(han,'Amplitude','fontsize',13);
        
    end
end
end
