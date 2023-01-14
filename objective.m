function [MTOW] = objective(x)
global x_0normalizing
x = x.*x_0normalizing;
W_nowing = 3.110115025000000e+04;

%make a file to write all wanted data to 
global write_data;
if write_data == true
    global fid_vector;
    fprintf(fid_vector, '%13g' , [x(1:8) x(29:31)]);
    fprintf(fid_vector, '\n');
    
    global fid_fullVector
    fprintf(fid_fullVector, '%13g' , x(:));
    fprintf(fid_fullVector, '\n');

    
    global ub
    global lb
    fid_bounds = fopen('dataBounds.dat','wt');
    fprintf(fid_bounds,  '%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s\n' ,'chord_R',  'taper_M', 'twist_R' ,'twist_M', 'taper_tip', 'span' , 'sweep_tip',   'twist_T', 'MTOW', 'W_fuel','L/D');
    fprintf(fid_bounds, '%13g' , [ub(1:8) ub(29:31)]);
    fprintf(fid_bounds, '\n');
    fprintf(fid_bounds, '%13g' , [x(1:8) x(29:31)]);
    fprintf(fid_bounds, '\n');
    fprintf(fid_bounds, '%13g' , [lb(1:8) lb(29:31)]);
    fclose(fid_bounds);

    global fid_coeffs;
    fprintf(fid_coeffs, '\n');
    fprintf(fid_coeffs, '%13g' , x(9:18));
    fprintf(fid_coeffs, '\n');
    fprintf(fid_coeffs, '%13g' , x(19:28));
    fprintf(fid_coeffs, '\n\n');
end

%Going through all disciplines for the reference aircraft
LD = Aerodynamics(x);
loads(x);
[W_wing,W_fuelMax] = structures(x);
W_endOverStart = performance(x);  %LD is directly fed into performance

%objective function
MTOW_abs = (W_nowing+W_wing)/(0.938*W_endOverStart);
MTOW = MTOW_abs/x_0normalizing(29);

global couplings;
couplings.LD = LD;
couplings.W_fuelMax = W_fuelMax;  %Voor de inequality constraint dat fuel volume groot genoeg is.
couplings.MTOW = MTOW;
couplings.W_wing = W_wing;
couplings.W_endOverStart = W_endOverStart;





end