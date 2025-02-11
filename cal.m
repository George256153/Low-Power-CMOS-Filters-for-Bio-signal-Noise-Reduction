%%% read test file %%%
%fileID = fopen('real_op','r');
fileID = fopen('test','r');
original = textscan(fileID, '%f %f', 'HeaderLines', 2); % 跳過前兩行
fclose(fileID);
%%% read noise-contaminated signal file %%%
fileID1 = fopen('pressure.txt','r');
noise = fscanf(fileID1,"%f");
fclose(fileID1);
%%% parameter setting
Fs = 10*1000;  % sampling rate 
T = 1/Fs;      % sampling period
L = 9460;      % length of signal 
t = (0:L-1)*T; % time vector 
H = (0:L-1)*Fs;

original = [original{1}, original{2}];
x=original(:,2);

%ALL change
gain =1198;
bias =-1004;
%42.7205 1.860e-06 139.6752

Err(x, gain, bias);