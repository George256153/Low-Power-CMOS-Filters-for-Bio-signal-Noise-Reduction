function err_min=Err(out, gain, bias)
load pressure.txt;
number=length(pressure);
org_sig=pressure((number/2+1):number);
out=out((number/2+1):number);
%%% Nomalization %%%
normal=out*gain+bias; 
number=number/2;

%%% calculate least square error
error_min=1000000000; % initial it with a big number
num_comp=3000;
% start is an index to align out(t) with org_sig(t)
for start=1:1000,
    sum=0;
    for i=1:num_comp,
        sum=sum+(normal(i+start-1)-org_sig(i))^2;
    end
    err=sum/num_comp;
    [start err]; %%calculated Err for this start index 
    if error_min > err,
        error_min=err;
        aligns=start;       
    end
end
[aligns error_min]

figure(5)
plot(1/10000:1/10000:number/10000,org_sig)
hold
plot(1/10000:1/10000:(number-aligns+1)/10000, normal(aligns:number),'r')
xlabel('Time(sec)')
legend('original signal(without noise)', 'normalized out(t) signal')
%fprintf("error_min= %f\n",error_min);
return ;
