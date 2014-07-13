clear all;
close all;

	

%Inputs -- Start%
periods = 4;
time = 1;

StockPrice = 100;
StrikePrice = 100;
call = 1;           %set this to 0 if put, 1 if call%
r = 0.04;
delta = 0;
vol = 0.1;
h = time/periods;

%Inputs -- End%


%graph settings

subplot(2,1,1);
plot(0, StockPrice, '.');
hold on;
plot([0, time],[StrikePrice, StrikePrice], 'g');
hold on;

% Cox-Ross-Rubinstein Model variables%

u = exp(vol*sqrt(h));
d = exp(-vol*sqrt(h));
p = (exp((r-delta)*h)-d)/(u-d);



%- Stock Price tree calculation -%

PriceTree = zeros([periods+1, periods+1]);
ValueTree = zeros([periods+1, periods+1]);
PriceTree(1,1) = StockPrice;

ctime = 0;

for(j = 2:periods+1)
    ctime = ctime+h;
        for(i = 1:j)
            if(PriceTree(i,j-1) ~= 0)
                PriceTree(i,j) = PriceTree(i,j-1)*u;
            else
                PriceTree(i,j) = PriceTree(i-1,j-1)*d;
            end
            
            plot(ctime, PriceTree(i,j), '*');
            hold on
        end
end
   subplot(2,1,1);
xlabel('Time');
ylabel('Stock Price');
hold on
subplot(2,1,2);


%- Option Value tree calculation -%

%Setting value at expiry%
for(i= 1:periods+1)
    if(call == 1)
        if(PriceTree(i,periods+1) > StrikePrice)
            ValueTree(i, periods+1) = PriceTree(i,periods+1) - StrikePrice;
        else
            ValueTree(i,periods+1) = 0;
        end
    else
        if(PriceTree(i,periods+1) < StrikePrice)
            ValueTree(i, periods+1) = StrikePrice - PriceTree(i,periods+1);
        else
            ValueTree(i,periods+1) = 0;
        end
    end
    
    plot(ctime, ValueTree(i,periods+1), '*');
    hold on
end



%back-propogating values*
for j = periods:-1:1
    ctime = ctime - h;
    for(i = 1:j)
        ValueTree(i,j) = exp(-(r-delta)*h)*(p*ValueTree(i,j+1)+(1-p)*ValueTree(i+1,j+1));
        plot(ctime, ValueTree(i,j), '*');
        hold on;
    end
    
end



subplot(2,1,2);
xlabel('Time');
ylabel('Option Value');

% output %
OptionPrice = ValueTree(1,1)
PriceTree
ValueTree
