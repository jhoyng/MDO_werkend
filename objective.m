function [MTOW] = objective(x)
global CD_nowing;
global W_nowing;

%make a file to write all wanted data to 
global write_data;
if write_data == true
    global fid_vector;
    fprintf(fid_vector, '%13g' , [x(1:8) x(29:30)]);
    fprintf(fid_vector, '\n');
    
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
W_wing = structures(x);
W_endOverStart = performance(x,LD);  %LD is directly fed into performance

%objective function
MTOW = (W_nowing+W_wing)/(0.938*W_endOverStart);







end