clear all
clc

global mu alpha beta B

beta = 0.3; 
mu = 1/80; %death rate ~susceptibles
alpha = 1/10-mu; %death rate ~infecteds
tp = 10000; %total susceptible population at start
noinfst = 100; %number infected at start
xstart = [tp, noinfst]; %starting values (no suscep, no infected)
B = mu*sum(xstart); %in this model I have defined B (birth rate) to relate to the population size (B is still a constant as xstart is a constant)
timesteps = 1000;

%'matrix' represents change to population structure wrt different events 
matrix(1,:) = [1,0]; %birth  
matrix(2,:) = [-1,0]; %death of susceptible
matrix(3,:) = [-1,1]; %infection
matrix(4,:) = [0,-1]; % death of infected host
%this needs updating 
%cf  column 3 of table

t = zeros(1,timesteps+1); %vector that will hold the times
m=zeros(timesteps+1,2); %vector that will hold the population structure

m(1,:) = xstart;
x=xstart;
t(1)=0;
for j=2:timesteps+1
    f=ee(x); 
    tt=tstep(x,f(5));  %%this needs changing: replace 5 with no of different events + 1
    f(4:5)=[]; %%this needs changing. replace 4:5 with {no  events:no events+1}
    q=rand; %generate random number
    x = x + ((q>[0,f]).*(q<=[f,1])*matrix); %calculating the new populating structure based upon probability of the different events  occuring
    m(j,:)=x; %updating the population structure vector
    t(j) = tt; %updating the time vector
end
sumt=cumsum(t);
S = m(:,1);
I = m(:,2);
hold on; plot(sumt,I)
