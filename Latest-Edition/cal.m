%%% read test file %%%
%fileID = fopen('real_op','r');
fileID = fopen('test','r');
original = textscan(fileID, '%f %f', 'HeaderLines', 2); % 跳過前兩行
fclose(fileID);

original = [original{1}, original{2}];
x=original(:,2);

%ALL change
gain =1198;
bias =-1004;
%42.7205 1.860e-06 139.6752

Err(x, gain, bias);