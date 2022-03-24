function tstep=tstep(x,P)
tstep=-(1/P)*log(rand); %timestep between events. calculated by selecting a random number from an exponential distribution that has rate = P=the total rate at which all events can occur 

%you don't need to change this