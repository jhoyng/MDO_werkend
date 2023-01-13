function [c, ceq] = constraints(x)
%Global parameters
global couplings;
LD = couplings.LD;
W_fuelMax = couplings.W_fuelMax;
MTOW = couplings.MTOW;
W_a_w = ;
W_wing = couplings.W_wing;
W_endOverStart = couplings.W_endOverStart;

%W_fuel_0 = x(30);
%LD = x(31);
%W_mtow_0 = x(29);

cc1 = ((W_a_w + W_wing)/((1/(1-0.938*W_endOverStart))-1) - x(30));        %Constraint that fuel weight of X0 equals output of performance %Hier zelfde som voor W_f gebruiken als bij constraint c1?
cc2 = (LD - x(31));         %Constraint that LD of x0 equals output of aerodynamics
cc3 = (MTOW - x(29));       %Constraint that MTOW of x0 equals that of the objective function

c1 = ((W_a_w + W_wing)/((1/(1-0.938*W_endOverStart))-1) - W_fuelMax);  %Contraint that the required fuel is less than the maximum capacity

c = [c1];
ceq = [cc1,cc2,cc3];

end