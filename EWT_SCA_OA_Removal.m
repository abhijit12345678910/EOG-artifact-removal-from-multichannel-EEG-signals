%% Ocular artifact (OA) removal from multichannel EEG signals EWT-SCA
clc
clear 
close all
EEGOARemoval='/MATLAB Drive/EWTSCA_OARemoval';
parentDir = EEGOARemoval;
addpath(genpath(parentDir))
%% Step 1 : Initialization (Load the signal and set the input parameters)
%[hdr, full_eeg_cont] = edfread('S001R01.edf');
load('SampleEEGSig.mat')
tic
dic_thr=1.8; % Dictionary Threshold parameter 
full_eeg_cont = full_eeg_cont(1:64,:);
eeg_sig = full_eeg_cont;
L = length(eeg_sig);
total_ch = size(eeg_sig,1);
fs = 160;  % Sampling rate of the signals
range = 1:L;
% Set parameters for ewt
params.SamplingRate = fs; 
params.globtrend = 'none';
params.reg = 'none';
%% Step 2 : Rhythm separation of multivariate input EEG signal using EWT.

    for i=1:total_ch
        ch=i;
        f = eeg_sig(ch,range)';
        [ewt_cont(i,:),mfb_cont(i,:)]=EWT1Duse(f,params,fs);
        rec_cont(i,:)=EWT_Modes_EWT1D(ewt_cont(i,:),mfb_cont(i,:));
    end
    
%% Compute energy ratio of contaminated eeg 
    full_E_cont = cellfun(@energy,rec_cont);
    
    for i = 1:length(full_E_cont)
        full_ER_cont(i,1) = full_E_cont(i,1)/ sum(full_E_cont(i,1:end-1));
    end
%% Find the dictionary channels

    % selecting 'k' max. energy ratio channels  
    
[indd]=(full_ER_cont>(mean(full_ER_cont)+dic_thr*std(full_ER_cont)));
dict_ch =sum(indd);  % Number of dictionary signals ('k') automatically computed 
T(1)=toc;
if (dict_ch==0)
    tic
  full_eeg_clean =  full_eeg_cont;
  clc
  T(2)=toc;
Time=sum(T);
ElapsedTime=strcat('Total Elapsed time is ',num2str(Time),' seconds');
disp(ElapsedTime);
  disp('Dictionary is Empty.')
else
   tic
    [ER_max,ER_in_max] = maxk(full_ER_cont,dict_ch);

    %% Step 3: Form the signal Matrix and Dictionary for SCA 
    % output = each channel decomposed into two subbands: 0-4 Hz and 4 Hz-above
     d = rec_cont(:,1)';
     sig_sca = cell2mat(d)'; % Signals used as input to SCA. 
     sig_pure =zeros(size(eeg_sig)); % Signal subband above 4 Hz will not be processed with SCA.
     for i=2:6
     d = rec_cont(:,i)';
     sig_pure =sig_pure + cell2mat(d)'; 
     end     
    dic = sig_sca(ER_in_max,range); % Dictionary 
    
%% Step 4: Perform SCA operation  
  
[Y1,Y2,V,D1,U1,S,W] = CSSD_old(sig_sca,dic,size(dic,1));
    
%% Clean the OA contaminated components in Y1.
    
nc = dict_ch;  % The number of components (nc) to be eliminated. 
Y3 = double(Y1);
EEG2  = zeros(nc,size(Y3,2)); 
Y3(1:nc,:) = [];
Y3 = [EEG2;Y3];
Z3 = V*Y3;
clean_sca = U1*(D1^(0.5))*Z3;
full_eeg_clean = clean_sca + sig_pure; % Signal subbands are added to reconstruct clean EEG (full_eeg_clean)
T(2)=toc;
Time=sum(T);
ElapsedTime=strcat('Total Elapsed time is','',num2str(Time),' seconds');
clc
disp(ElapsedTime);

% Plot the multichannel contaminated EEG, cleaned EEG, and eliminated OAs.

affichage(eeg_sig,fs)
title('Input EEG Signals')
affichage(full_eeg_clean,fs)
title('EEG Signals after OA elimination using EWT-SCA')
affichage(eeg_sig-full_eeg_clean,fs)
title('Eliminated OAs using EWT-SCA')

%% Evaluate performance parameters    

 % Percentage change in delta band Energy Ratio (Percentage_ER).
 
    for i=1:total_ch
        ch=i;
        f = full_eeg_clean(ch,range)';
        [ewt_clean(i,:),mfb_clean(i,:)]=EWT1Duse(f,params,fs);
        rec_clean(i,:)=EWT_Modes_EWT1D(ewt_clean(i,:),mfb_clean(i,:));
    end
    full_E_clean = cellfun(@energy,rec_clean);
    for i = 1:length(full_E_clean)
        full_ER_clean(i,1) = full_E_clean(i,1)/ sum(full_E_clean(i,1:end-1));
    end
    Percentage_ER = (full_ER_cont - full_ER_clean)*100;

    % Plot the Histograms of ER of delta rhythms for contaminated and cleaned EEG signals.  
    
figure;histogram(full_ER_cont,10)
title('Histogram of ER of delta rhythm for OA contaminated EEG')
xlabel('ER_{\delta} value')
ylabel('Number of channels')
ax = gca;
ax.FontSize = 13;
figure;histogram(full_ER_clean,10)
title('Histogram of ER of delta rhythm for OA eliminated EEG')
xlabel('ER_{\delta} value')
ylabel('Number of channels')
ax = gca;
ax.FontSize = 13;
    
    % Average mean absolute error in terms of power spectral density(PSD)
    
    [Pxx,F] = periodogram(full_eeg_cont',[],length(full_eeg_cont(1,:)),fs);
    [Qxx,FQ] = periodogram(full_eeg_clean',[],length(full_eeg_clean(1,:)),fs);
    absolute = abs(Pxx-Qxx);
    freq_hz = [0.1 4 8 13 30 60];
    freq_bins = round(freq_hz *length(full_eeg_cont(1,:))/fs);
    for p = 1:5
        MAE(p,:) = sum(absolute(freq_bins(p):freq_bins(p+1),:)/(freq_bins(p+1)-freq_bins(p)+1));
    end
    MAE = MAE';
    
Max_Per_EnergyRatio=max(Percentage_ER);
Mean_MaE=mean(MAE(:,2:5));
% Display Final Results
disp('Performance Parameters')
Max_Percentage_ER_Change=[Max_Per_EnergyRatio];
Parameter = {'Value'};
Mean_MaE_Theta=Mean_MaE(1);
Mean_MaE_Alpha=Mean_MaE(2);
Mean_MaE_Beta=Mean_MaE(3);
Mean_MaE_Gamma=Mean_MaE(4);
Tabl = table(Parameter,Max_Percentage_ER_Change,Mean_MaE_Theta,Mean_MaE_Alpha,Mean_MaE_Beta,Mean_MaE_Gamma);
disp(Tabl)
end

%% function for calculating energy of each component
function E = energy(ewt)
    E = sum(abs(ewt.^2));
end
