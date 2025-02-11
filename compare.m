fileID = fopen('pressure_time.txt', 'r');
original = fscanf(fileID, '%f', [2, 9460]); 
original = original'; 
fclose(fileID);
%%% read noise-contaminated signal file %%%
fileID1 = fopen('sig_time.txt','r');
noise = fscanf(fileID1,"%f");
fclose(fileID1);
%%% real file %%%
fileID = fopen('test','r');
real = textscan(fileID, '%f %f', 'HeaderLines', 2); % 跳過前兩行
fclose(fileID);
real = [real{1}, real{2}];
real=real(:,2)-0.89;
%%% parameter setting
Fs = 10*1000;  % sampling rate 
T = 1/Fs;      % sampling period
L = 9460;      % length of signal 
t = (0:L-1)*T; % time vector 
H = (0:L-1)*Fs;
%%% 設定參數
filterOrder1 = 4;        % 濾波器階數
filterOrder2 = 4;        % 濾波器階數
passbandRipple = 1;     % 通帶內最大衰減 (dB)
lowpassFrequency = 250; % 低通濾波器的截止頻率 (Hz)
highpassFrequency =58; % 高通濾波器的截止頻率 (Hz)
%%% 設計高通濾波器
[b_hp, a_hp] = cheby1(filterOrder1, passbandRipple, highpassFrequency / (Fs/2), 'high');

%%% 設計低通濾波器
[b_lp, a_lp] = cheby1(filterOrder2, passbandRipple, lowpassFrequency / (Fs/2), 'low');
%%% 濾波應用
% 高通濾波
filteredSignalHighpass = filtfilt(b_hp, a_hp, noise);

% 再應用低通濾波
filteredSignal = filtfilt(b_lp, a_lp, filteredSignalHighpass);

%%% 計算頻率響應
% 結合高通和低通濾波器的係數
b_combined = conv(b_hp, b_lp); % 分子係數相乘
a_combined = conv(a_hp, a_lp); % 分母係數相乘
[HR, f] = freqz(b_combined, a_combined, 1024, Fs); % 1024點，取樣頻率為Fs

original=original(:,2);
original=original/1100-0.04;

figure(1);
plot(t,original,'b');
hold
plot(t,real,'r'); 
%plot(t,filteredSignal,'g');

