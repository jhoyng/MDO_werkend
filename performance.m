function [W_endOverStart] = performance(x,LD)



C_T =  1.8639e-4;   %[1/s]  
R = 2389.080e3;     %[meter]
global V_Cruise;


W_endOverStart = exp(-R*C_T/V_Cruise*(LD^-1));


end