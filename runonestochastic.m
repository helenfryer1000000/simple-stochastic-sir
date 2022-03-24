clear all
clc

global mu alpha beta B

beta = 0.3; 
mu = 1/80; %death rate ~susceptibles
alpha = 1/10-mu; %death rate ~infecteds
epidemicyears = 4; %time duration of the stochastic run
tp = 10000; %total susceptible population at start
noinfst = 100; %number infected at start

t = zeros(1,epidemicyears+1); %vector that will hold the interarrival times
sumt=zeros(1,epidemicyears+1);
m=zeros(epidemicyears+1,2); %vector that will hold the population structure

%'matrix' represents change to population structure wrt different events 
matrix(1,:) = [1,0]; %birth  
matrix(2,:) = [-1,0]; %death of susceptible
matrix(3,:) = [-1,1]; %infection
matrix(4,:) = [0,-1]; % death of infected host
%this needs updating 
%cf  column 3 of table

xstart = [tp, noinfst]; %starting values (no suscep, no infected)
B = mu*sum(xstart); %in this model I have defined B (birth rate) to relate to the population size (B is still a constant as xstart is a constant)

%%%%%%%%%%%  FASTER VERSION
m(1,:) = xstart;
x=xstart;
t(1)=1;
for j=2:epidemicyears+1
    tt =t(j-1)-1;  %this value is just a bit bigger than 0
    while tt<1
        f=ee(x); %vector containing cumulative sum of the individual rates, followed by the total rate c.f function ee
        tt=tt+tstep(x,f(5));  %%calculate interarrival time
        f(4:5)=[]; %for determining population structure we are only interested in all but the last two values 
        q=rand; %generate random number
        x = x + ((q>[0,f]).*(q<=[f,1])*matrix); %calculating the new populating structure based upon probability of the different events  occuring
    end
    m(j,:)=x; %updating the population structure vector
    t(j) = tt; %updating the time vector
    sumt(j) = j-2+tt;
end
S = m(:,1); %S= vector of susceptibles over time
I = m(:,2); %I= vector of infects over time

hold on; plot(sumt,I,'-x')

