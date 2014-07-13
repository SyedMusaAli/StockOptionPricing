clear all;
close all;

%--- This program calculates stock prices for Standard Stock Options via
%the CRR-Binomial Model ---%

%Inputs

periods = 1000;        %Number of Periods
time = 1;           %Time to expiry
StockPrice = 100;       %stock price    
StrikePrice = 100;      %Strike price
barrier = 110;          %option barrier
call = 1;               %set this to 0 if put, 1 if call%
r = 0.1;               %rate of interest
delta = 0;              %rate of dividends
vol = 0.25;              %volatility
dt = time/periods;       %time step

cc = r-delta;

u = exp(vol*sqrt(2*dt));
d = exp(-vol*sqrt(2*dt));
P_up = ((exp(cc * dt / 2) - exp(-vol * sqrt(dt / 2))) / (exp(vol * sqrt(dt / 2)) - exp(-vol * sqrt(dt / 2)))) ^ 2;
P_down = ((exp(vol * sqrt(dt / 2)) - exp(cc * dt / 2)) / (exp(vol * sqrt(dt / 2)) - exp(-vol * sqrt(dt / 2)))) ^ 2;
P_mid = 1 - P_up - P_down;

PriceTree = zeros([2*periods+1, periods+2]);      %Matrix to store Stock Price tree
ValueTree = zeros([2*periods+1, periods+2]);      %matrix to store option value tree

if(StockPrice < barrier)
    up_out = 1;             %is a up and out%
else
    up_out = 0;             %is a down and out%
end


%graph settings

subplot(2,1,1);
plot(0, StockPrice, '.');
hold on;
plot([0, time],[StrikePrice, StrikePrice], 'g');
hold on;
plot([0, time],[barrier, barrier], 'r');
hold on;

xlabel('Time');
ylabel('Stock Price');
hold on

%Price tree calculation%
PriceTree(1,1) = StockPrice;    %initializing stock price

ctime = 0;          %time counter for graph

for(j = 2:periods+1)        %loop through periods
    ctime = ctime+dt;
        for(i = 1:2*(j-1)+1)
            if(PriceTree(i,j-1) ~= 0)                   %generate new prices using previous prices
                PriceTree(i,j) = PriceTree(i,j-1)*u;
            else
                if( PriceTree(i-1,j-1) ~= 0)
                    PriceTree(i,j) = PriceTree(i-1,j-1);
                else
                    PriceTree(i,j) = PriceTree(i-2,j-1)*d;
                end
            end
            
            plot(ctime, PriceTree(i,j), '*');           %plot prices
            hold on
        end
end
    
%graph setting for option value

subplot(2,1,2);
xlabel('Time');
ylabel('Option Value');
hold on

%Option Value tree calculation%

%Setting value at expiry%
for(i= 1:2*periods+1)
    if(up_out == 1 && PriceTree(i,j) >= barrier || up_out == 0 && PriceTree(i,j) <= barrier)        %%check if barrier was crossed
            ValueTree(i,periods+1) = 0;
    else
        %check option type
        if(call == 1)                                   
            if(PriceTree(i,periods+1) > StrikePrice)            %check price against strike price
                ValueTree(i, periods+1) = PriceTree(i,periods+1) - StrikePrice;
            else
                ValueTree(i,periods+1) = 0;
            end
        else
            if(PriceTree(i,periods+1) < StrikePrice)            %check price against strike price
                ValueTree(i, periods+1) = StrikePrice - PriceTree(i,periods+1);
            else
                ValueTree(i,periods+1) = 0;
            end
        end
    end
    
    plot(ctime, ValueTree(i,periods+1), '*');       %plot option value
    hold on
end

%back-propogating values*
for j = periods:-1:1
    ctime = ctime - dt;
    for(i = 1:2*(j-1)+1)
        if(up_out == 1 && PriceTree(i,j) >= barrier || up_out == 0 && PriceTree(i,j) <= barrier)        %check barrier
            ValueTree(i,j) = 0;
        else
            ValueTree(i,j) = exp(-(r-delta)*dt)*(P_up*ValueTree(i,j+1)+P_mid*ValueTree(i+1,j+1)+P_down*ValueTree(i+2,j+1));           %back propogate value
        end
        plot(ctime, ValueTree(i,j), '*');       %plot option value
        hold on;
    end
end


OptionPrice = ValueTree(1,1)
PriceTree;
ValueTree;
