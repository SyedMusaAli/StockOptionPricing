clear all;
close all;

%Simulation Settings%
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
call = 1;
OptionValue = 0;

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
   end
   plot(time, S, cstring(mod(i,3)+1));
   hold on;
   
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

ans = mean(results)*exp(-r*Etime)