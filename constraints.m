function [c, ceq] = constraints(x)
global x_0normalizing
x = x.*x_0normalizing;
%Global parameters
global couplings;
LD = couplings.LD;
W_fuelMax = couplings.W_fuelMax;
MTOW = couplings.MTOW;
W_a_w = 3.110115025000000e+04;  %Nader in te vullen
W_wing = couplings.W_wing;
W_endOverStart = couplings.W_endOverStart;

%W_fuel_0 = x(30);
%LD = x(31);
%W_mtow_0 = x(29);

cc1 = ((W_a_w + W_wing)/((1/(1-0.938*W_endOverStart))-1) - x(30));        %Constraint that fuel weight of X0 equals output of performance %Hier zelfde som voor W_f gebruiken als bij constraint c1?
cc2 = (LD - x(31));         %Constraint that LD of x0 equals output of aerodynamics
cc3 = (MTOW - x(29));       %Constraint that MTOW of x0 equals that of the objective function

c1 = ((W_a_w + W_wing)/((1/(1-0.938*W_endOverStart))-1) - W_fuelMax);  %Contraint that the required fuel is less than the maximum capacity

% c = [c1];
% ceq = [cc1,cc2,cc3];

c = [c1/x_0normalizing(30)];
ceq = [cc1/x_0normalizing(30),cc2/x_0normalizing(31),cc3/x_0normalizing(29)];

%write the weight fraction on the data file
global write_data


if write_data == true
    global fid_data
    fprintf(fid_data, '%15g', c1 ,cc1,cc2,cc3);
    fprintf(fid_data, '\n');
end


end