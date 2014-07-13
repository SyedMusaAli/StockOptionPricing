clear all;
close all;


%--- This program calculates stock prices for Single-Barrier Stock Options via the CRR-Binomial Model ---

%Inputs -- Start

periods = 4;        %Number of Periods
time = 1;           %Time to expiry
StockPrice = 100;       %stock price    
StrikePrice = 100;      %Strike price
barrier = 120;          %option barrier
call = 1;               %set this to 0 if put, 1 if call%
r = 0.04;               %rate of interest
delta = 0;              %rate of dividends
vol = 0.1;              %volatility
h = time/periods;       %time step

%Inputs -- End

u = exp(vol*sqrt(h));
d = exp(-vol*sqrt(h));
p = (exp((r-delta)*h)-d)/(u-d);

PriceTree = zeros([periods+1, periods+1]);      %Matrix to store Stock Price tree
ValueTree = zeros([periods+1, periods+1]);      %matrix to store option value tree

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
    ctime = ctime+h;
        for(i = 1:j)
            if(PriceTree(i,j-1) ~= 0)                   %generate new prices using revious prices
                PriceTree(i,j) = PriceTree(i,j-1)*u;
            else
                PriceTree(i,j) = PriceTree(i-1,j-1)*d;
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
for(i= 1:periods+1)
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
    ctime = ctime - h;
    for(i = 1:j)
        if(up_out == 1 && PriceTree(i,j) >= barrier || up_out == 0 && PriceTree(i,j) <= barrier)        %check barrier
            ValueTree(i,j) = 0;
        else
            ValueTree(i,j) = exp(-(r-delta)*h)*(p*ValueTree(i,j+1)+(1-p)*ValueTree(i+1,j+1));           %back propogate value
        end
        plot(ctime, ValueTree(i,j), '*');       %plot option value
        hold on;
    end
end


OptionPrice = ValueTree(1,1)
PriceTree
ValueTree
