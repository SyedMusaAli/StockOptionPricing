clear all;
close all;

%scenario%
paths = 1000;
periods = 4;
Etime = 1;
h = Etime/periods;

%stock%
S0 = 100;
a = 0.04;
r=0.04;
vol =  0.1;
delta = 0;

%option%
K = 100;
call = 1;                %set this to 0 if put, 1 if call%
upper_barrier = 120;
lower_barrier = 90;
OptionValue = 0;

%initializations%
results = zeros(1,paths);
time = 1:periods+1;
S = 1:periods+1;

plot([1, periods+1],[K, K], 'g');
hold on;
plot([1, periods+1],[upper_barrier, upper_barrier], 'r');
hold on
plot([1, periods+1],[lower_barrier, lower_barrier], 'r');
hold on;



%runs%
for(i = 1:paths)
    S(1) = S0;
   for(t = 2:periods+1 )
        z = randn;
        S(t)= S(t-1)*exp((a-delta-0.5*vol^2)*h+vol*z*sqrt(h));
        if(S(t) >= upper_barrier || S(t) <= lower_barrier)
            break;
        end;
   end
   plot(time, S, 'b');
   hold on;
   if(S(t) >= upper_barrier || S(t) <= lower_barrier)
       results(i) = 0;
   else
       if(call == 1)
            if(S(t)>K)
                results(i) = S(t)-K;
            else
                results(i) = 0;
            end
       else
           if(S(t)<K)
               results(i) = K - S(t);
           else
               results(i) = 0;
           end
       end
   end
end

xlabel('Time');
ylabel('Price');
title('Simultaed Paths');

OptionPrice = mean(results)*exp(-r*Etime)