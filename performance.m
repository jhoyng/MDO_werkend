function [W_fuel] = performance(x)
% global x_0normalizing
% x = x.*x_0normalizing;
global W_nowing
LD = x(30);

C_T =  1.8639e-4;   %[1/s]  
R = 2389.080e3;     %[meter]
%global V_Cruise;
V_Cruise = 414*0.514444;
W_mtow =    x(28)+W_nowing+x(29);
W_endOverStart = exp(-R*C_T/V_Cruise*(LD^-1));
W_fuel = (1- 0.938*W_endOverStart)*W_mtow;





end