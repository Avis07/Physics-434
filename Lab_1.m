%% PHYSICS 434 - APPLICATION OF COMPUTERS TO PHYSICAL MEASUREMENT 
% LAB 1 
% DUE: 10/13/19
% AVI SOVAL 

%% SECTION I - A LITTLE STATISTICS 

    % Integrate the standard normal distribution with various sigma values
    % and check that the resultant probabilities match the z-table entries.
    
%creating standard normal distribution with mu = 0, stddev = 1

x = [-5:.1:5]; 
y = normpdf(x,0,1); 

figure(1)
plot(x,y)

p1 = normcdf(1); 
p2 = normcdf(2); 
p3 = normcdf(3); 
p4 = normcdf(-1); 
p5 = normcdf(-2); 
p6 = normcdf(-3); 

pVal = [p6 p5 p4 p1 p2 p3]; %integrated values for the standard normal distribution 

zVal = [0.0013 0.0228 .1587 .8413 .9772 .9987]; %z table values for sigma = -3, -2, -1, 1, 2, 3

disp(pVal); 
disp(zVal); 

%As we can see, the integrated values for the standard normal distribution
%match the tabulated z-values

    % Make both the analytic pdf() and a realization of 100k samples using
    % an Exponential Distribution 
    
d = random('Exponential',10,[1,100000]); 
exp = makedist('Exponential','mu',10); 
histogram(d,100,'DisplayStyle',"stairs",'Linewidth',1);
xlim([-1 45]); 

% With a chosen value for the hypothetical measurement = 7.5, our question
% becomes: Given this exponential distribution, what is the probability
% that our signal-free background data has produced a signal that is
% equally or more signal-like than our observed 7.5? 

sig1 = cdf(exp,7.5,'upper'); 
%Probability result
disp(sig1)
ans = norminv(sig1);
%Probability to sigma
disp(ans)

%% SECTION II - NON-CONTINUOUS DISTRIBUTIONS 

x = 0:100; 
bin = binopdf(x,100,0.5); 
figure(2)
plot(x,bin,'*')
bin2 = binopdf(x,100,0.7);
figure(3)
plot(x,bin2,'+'); 
bin3 = binopdf(x,100,0.2); 
figure(4)
plot(x,bin3,'o'); 

%Here, each binomial probability distribution has a different probability
%of each event occuring or not - 50%, 70%, and 20%. This changes the center
%of the binomial distribution, and a lower event probability means the
%graphs will taper off more quickly as there is a lower probability of
%other events occuring or not. 

%Say there are 500 lightbulbs in a hotel that are due for maintenance. An
%electrician begins checking which bulbs to replace, knowing that for any
%given bulb, there is a 15% chance that it needs to be replaced. What is
%the probabilty that he will need to replace 100 bulbs? 

x = 0:500; 
bulbs = binopdf(x,500,0.15);
lights = makedist('Binomial',500,0.15);
figure(5)
plot(x,bulbs);
%Probability
sig = cdf(lights,100,'upper');
disp(sig)
%Probability to sigma
ans1 = norminv(sig);
disp(ans1)

%It makes sense that the mean of a binomial distribution can be
%non-discrete, as averaging a set of integers can yield a non-integer
%value. 