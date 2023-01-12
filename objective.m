function [MTOW] = objective(x)
global CD_nowing;
global W_nowing;


%Going through all disciplines for the reference aircraft
LD = Aerodynamics(x);
loads(x);
W_wing = structures(x);
W_endOverStart = performance(x,LD);  %LD is directly fed into performance

%objective function
MTOW = (W_nowing+W_wing)/(0.938*W_endOverStart);

end