clear all;
close all;

%scenario%
paths = 1000;
periods = 1000;
Etime = 1;
h = Etime/periods;

%stock%
S0 = 100;
a = 0.1;
r=0.1;
vol =  0.25;
delta = 0;

%option%
K = 100;
call = 1;                %set this to 0 if put, 1 if call%
barrier = 110;
OptionValue = 0;
if(S0 < barrier)
    up_out = 1;         %up and out%
else
    up_out = 0;         %down and out%
end

%initializations%
results = zeros(1,paths);
time = 1:periods+1;
S = 1:periods+1;

cstring = 'rbk';


%runs%
for(i = 1:paths)
    S(1) = S0;
   for(t = 2:periods+1 )
        z = randn;
        S(t)= S(t-1)*exp((a-delta-0.5*vol^2)*h+vol*z*sqrt(h));
        if(up_out == 1 && S(t) >= barrier || up_out==0 && S(t) <= barrier)
            break;
        end;
   end
   plot(time, S, cstring(mod(i,3)+1));
   hold on;
   if(up_out == 1 && S(t) >= barrier || up_out==0 && S(t) <= barrier)
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
title('Simulated Paths');

OptionPrice = mean(results)*exp(-r*Etime)