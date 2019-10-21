%% PHYSICS 434 | APPLICATION OF COMPUTERS TO PHYSICAL MEASUREMENTS 
 % LAB 2 ROUGH DRAFT 
 % 10.18.19
 % AVI SOVAL 

%% PROBLEM 1 

 % We continue our exploration into the convolution of different data
 % distributions by analyzing hypothetical signal-free background data in a
 % Poisson distribution 

 % With an average background of 7 for the cosmic background ray data, and
 % an average gamma-ray emission of 11
 
    % A : How does the background pdf change as we sum over more days? 
    
background = 7; 
gammaray = 11; 

distribution = makedist('Poisson','lambda',background); 

x = 0:1:25; 

pdf1 = pdf(distribution,x); 
pdf2 = conv(pdf1,pdf1); 
pdf4 = conv(pdf2,pdf2); 
pdf6 = conv(pdf2,pdf4); 
pdf8 = conv(pdf4,pdf4); 
pdf10 = conv(pdf8,pdf2); 

x1 = 0:1:length(pdf1)-1; 
x2 = 0:1:length(pdf2)-1; 
x4 = 0:1:length(pdf4)-1; 
x6 = 0:1:length(pdf6)-1; 
x8 = 0:1:length(pdf8)-1; 
x10 = 0:1:length(pdf10)-1; 

figure(1)
plot(x,pdf1,'LineWidth',2); 
hold on 
plot(x2,pdf2,'LineWidth',2); 
plot(x4,pdf4,'LineWidth',2);
plot(x6,pdf6,'LineWidth',2); 
plot(x8,pdf8,'LineWidth',2);
plot(x10,pdf10,'LineWidth',2);
% one way to make the graph look better is to use xlim code to set limit for x
hold off

    % B : Show that after 5 days, the resulting distribution is still a
    % Poisson distribution. Why does this make sense? 
    
    % To do so, we just create a new Poisson distribution with an average
    % background cosmic ray radiation equal to any of our convoluted
    % distributions - say the pdf10, which convolutes over 10 days. If the
    % two graphs match, then our resultant convoluted distribution is also
    % a Poisson distribution 
    
x = 0:1:length(pdf10)-1; 
lambda = dot(pdf10,x); 

figure(2)
pdf10Poisson = makedist('Poisson','lambda',lambda); 
plot(0:length(pdf10)-1,pdf10,'*'); 
hold on
plot(0:length(pdf10)-1,pdf(pdf10Poisson,0:length(pdf10)-1),':'); 

    % As we can see, the two distributions align perfectly. Since the
    % Poisson distribution gives data on the number of events happening
    % within a single day (or any arbitrary period), it makes sense that
    % convolving (which we know to be adding) multiple such Poisson
    % distributions should just yield a final pdf of measuring the initial
    % number of events * the total number of days = total events. It scales
    % completely proportionally, causing the resultant graphs to be
    % identical. 
    
    % C : Show how the probability distribution evolves as we *average* the
    % days, and discuss the change in the shape of the distribution with
    % respect to part 1b 
    
    % Averaging the days means just dividing the background events measured
    % for each of the convolved distributions by the number of days in each
    % respective distribution, as follows: 
    
figure(3)
plot(x1/1,pdf1,'LineWidth',2);
hold on 
plot(x2/2,pdf2,'LineWidth',2);
plot(x4/4,pdf4,'LineWidth',2);
plot(x6/6,pdf6,'LineWidth',2);
plot(x8/8,pdf8,'LineWidth',2);
plot(x10/10,pdf10,'LineWidth',2);
hold off

    % As we can see, graphing the *average* of the days essentially makes
    % all the Poisson distributions the same, just scaled slightly
    % differently. The most likely number of counts for each day still
    % remains 7, which is in line with the initial lambda parameter for the
    % cosmic ray background Poisson distribution 
    
    % D : Given a testing period of 17 days, assuming we saw 17*11  = 187
    % gamma ray events from our source, calculate the sigma of our
    % observation
    
testPeriod = 17; 
events = testPeriod*gammaray; 

    % From the results of 1b, we know that the lambda parameter for this
    % 17-day data collection distribution should just be 17*lambda for a
    % single day's data = 17*7 = 119
    
pdf17dist = makedist('Poisson','lambda',119); 
probs = cdf(pdf17dist,events,'upper'); 
sigma = norminv(probs); 
disp(sigma)

%% PROBLEM 2 

 % With a skewed background distribution such as the Rayleigh distribution:
 
    % A : Show how the distribution changes as we average over more
    % observing intervals 
 
    % We first create our Rayleigh distribution with a 'b' parameter of 5

x = 0:100; 
ray1 = makedist('Rayleigh','b',5); 
ray1 = pdf(ray1,x);
ray2 = conv(ray1,ray1); 
ray4 = conv(ray2,ray2); 

    % Now we convolve it to get distributions of the following observation
    % intervals: 5, 10, 25, 50, 100, 200
    
ray5 = conv(ray4,ray1); 
ray10 = conv(ray5,ray5); 
ray20 = conv(ray10,ray10); 
ray25 = conv(ray20,ray5); 
ray50 = conv(ray25,ray25); 
ray100 = conv(ray50,ray50); 
ray200 = conv(ray100,ray100); 

    % Plotting

figure(4)
plot(x,ray1); 
x5 = 0:length(ray5)-1; 
x10 = 0:length(ray10)-1; 
x25 = 0:length(ray25)-1; 
x50 = 0:length(ray50)-1; 
x100 = 0:length(ray100)-1; 
x200 = 0:length(ray200)-1; 
hold on 
plot(x5/5,ray5,'LineWidth',2);
plot(x10/10,ray10,'LineWidth',2);
plot(x25/25,ray25,'LineWidth',2);
plot(x50/50,ray50,'LineWidth',2);
plot(x100/100,ray100,'LineWidth',2);
plot(x200/200,ray200,'LineWidth',2);
hold off

    % B : Discuss how this shape changes. Does it approach a Gaussian
    % distribution? If yes, after how many intervals? 
    
    % We can examine the Gaussian nature of each of these convolved
    % Rayleigh distributions by graphing them on a log scale and analyzing
    % their parabolic nature: 
    
figure(5)
plot(x,ray1);
hold on 
plot(x5/5,ray5,'LineWidth',2);
plot(x10/10,ray10,'LineWidth',2);
plot(x25/25,ray25,'LineWidth',2);
plot(x50/50,ray50,'LineWidth',2);
plot(x100/100,ray100,'LineWidth',2);
plot(x200/200,ray200,'LineWidth',2);
set(gca,'YScale','log'); 
hold off 

    % We can see from here that increasing the number of convolved Rayleigh
    % distributions does indeed approach a more Gaussian set. 
    
    % To more accurately gauge the Gaussian nature of these convolved
    % distributions, we can create a Gaussian function with a mu and sigma
    % that match that of any of our Rayleigh distributions. We take the
    % Rayleigh distribution that has been convolved 100 times and find its
    % mu and sigma accordingly. 
    
mu = dot(x100/100,ray100); 
variance = 0; 

for i = 1:length(x100)
    
    variance = variance + (i/100-mu)^2 * ray100(i); 
    
end

sigma = sqrt(variance);

gaussRayTest = makedist('Normal','mu',mu,'sigma',sigma); 
gaussRayTest = pdf(gaussRayTest,x100/100); 

    % We know overlay the Rayl00 (100 convolved Rayleigh distributions)
    % plot with this test Gaussian plot to see how close they are, after
    % which we will do the same except on a logarithmic scale 
    
figure(6)
plot(x100/100,ray100,'LineWidth',2); 
hold on 
plot(x100/100,gaussRayTest,'LineWidth',2); 

    % I KNOW THE ABOVE CODE IS NOT WORKING CORRECTLY RIGHT NOW I WILL COME BACK AND
    % FIX IT ONCE I FIGURE OUT WHY ITS WRONG ^^^^^^^^^^^^^
    
%% PROBLEM 3 

    % A : Assume we have a signal-free background distribution as a
    % Gaussian with a mean of 0 with constant width. From looking at all
    % the other pixels in the image, we can measure the width*3 and end up
    % measuring a signal of strength 11.7. What is the significane and sigma
    % of this detection? Can we claim a discovery? 
    
    % We begin by creating a Gaussian of mu 0 and sigma of 3
   
x = -100:1:100; 
swift = makedist('Norma','mu',0,'sigma',3); 
swift1 = pdf(swift,x); 
signal = 11.7; 
figure(7)
plot(x,swift1,'LineWidth',2); 

    % Now calculating the significance and sigma of the discovery 
    
prob = cdf(swift,signal,'upper'); 
sigma = norminv(prob); 
disp(sigma)

    % Our sigma is only -3.9 - therefore this is not significant enough to
    % make a discovery. 
    
    % B and C : Say we search 10,000 pixels, what is the probability distribution
    % of this background? Clearly state the question 
    
    % With 10,000 pixels to collect data from, and considering this is a
    % Gaussian distribution, we know this new Gaussian will simply be the
    % initial one convolved 10,000 times - or summed together 10,000 times
    % while kept normalized. Therefore, we simply multiply the previously
    % found probability by 10,000 and recalculate the significance of this
    % statistic. 
    
prob10k = prob*10000; 
sigma10k = norminv(prob10k); 
disp(sigma10k)

    % In this case, our sigma is only -0.0477, which is not that high at
    % all. 
    
%% PROBLEM 4 

    % A : Assuming we have the same Gaussian as in problem 3, calculate the
    % signal required for a 5-sigma detection given the same conditions as
    % problem 3a - i.e a single pixel trials factor 
    
sig_VI = normcdf(5,'upper'); 
prob_VI = icdf(swift,1-sig_VI); 
disp(prob_VI)

    % B : Do the same as 4a for problem 3b - i.e a 10,000 pixels trials
    % factor 
    
sig_VII = sig_VI/10000; 
prob_VII = icdf(swift,1-sig_VII); 
disp(prob_VII)

    % C : How much brighter must the signal be for a trials factor of
    % 10,000 for it to be considered significant? What is the ratio of
    % the signals? 
    
ratio = prob_VII/prob_VI; 
disp(ratio)

    % As we modify our Gaussian dependent on the trials factor, the
    % majority of the probability remains concentrated around the mean, and
    % signals further away from it still remain in areas of extremely low
    % probability. As a result, the integral we must perform from the
    % signal out to infinity does not grow too much. 
    
    % D : What happens if we change our trials factor by three orders of
    % magnitude? What must be the new signal for it to be considered
    % significant? 
    
sig_VX = sig_VI/10000000; 
prob_VX = icdf(swift,1-sig_VX); 
disp(prob_VX)

    % Even now, with a trials factor of 100,000,000, the signal required to
    % be considered significant is only ~3 points higher than the 10,000
    % trials factor significant signal. This means that as we increase the
    % trials factor to higher and higher numbers, we are actually
    % experiencing a sort of 'diminishing returns'. 
    
%% THE END 