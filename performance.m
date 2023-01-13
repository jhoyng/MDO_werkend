function [W_endOverStart] = performance(x,LD)



C_T =  1.8639e-4;   %[1/s]  
R = 2389.080e3;     %[meter]
global V_Cruise;


W_endOverStart = exp(-R*C_T/V_Cruise*(LD^-1));

%write the weight fraction on the data file
global write_data


if write_data == true
    global fid_data
    fprintf(fid_data, '%15g \n', W_endOverStart);
end


end