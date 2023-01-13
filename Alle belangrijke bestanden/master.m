
clear all;
close all;
%Initial values of design vector
Rootchord_0 = 5.78 ;
Taper_mid_0 = 0.699;
Taper_tip_0 = 0.356;
Root_twist_0 = 4;
Mid_twist_0 = 2.62;
Tip_twist_0 = -0.44;    
Tip_span_0 = 14.038 ;
LE_sweep_tip_0 = 19.37 ;
W_mtow_0 =  43090;         %[kg]
W_fuel_0 = 13365*0.81715;           %[m^3]*[kg/m^3] = [kg]
LD_0 = 16;

%Defign the root and tip airfoil
%e553
%Defign the root and tip airfoil
%f100 root and tip
AuR =[0.153528825211809;0.114367804944869;0.212917645596938;0.119276832908319;0.069646397047114];
AlR = [-0.169319963986527;-0.092193075229581;-0.302733614226347;-0.092782085231768;-0.108253650607020];
AuT =[0.180964236453140;0.112375548755489;0.199250369688744;0.144259294381080;0.150037563263751];
AlT = [-0.152238948766128;0.102651482055201;-0.333682672036304;0.114339150685438;-0.156366477902652];

x0 = [Rootchord_0  Taper_mid_0  Root_twist_0 Mid_twist_0  Taper_tip_0  Tip_span_0  LE_sweep_tip_0  Tip_twist_0 AuR(1)  AuR(2)  AuR(3)  AuR(4)  AuR(5)  AlR(1)  AlR(2)  AlR(3)  AlR(4)  AlR(5)  AuT(1)  AuT(2)  AuT(3)  AuT(4)  AuT(5)  AlT(1)  AlT(2)  AlT(3)  AlT(4)  AlT(5) W_mtow_0 W_fuel_0 LD_0];
%x0 =[    1             2           3              4          5            6              7             8        9       10      11      12      13      14      15      16      17      18      19      20     21       22      23      24      25      26      27     28        29      30    31]; 

coeff_mean = 0.15;


global x_0normalizing
x_0normalizing = abs([x0(1:8)  coeff_mean*ones(1,20)  x0(29:31)]);

%Creating bounds for the design variables
%Upper bounds
%ub = [Rootchord_0  Taper_mid_0  Root_twist_0 Mid_twist_0  Taper_tip_0  Tip_span_0  LE_sweep_tip_0  Tip_twist_0 AuR(1)  AuR(2)  AuR(3)  AuR(4)  AuR(5)  AlR(1)  AlR(2)  AlR(3)  AlR(4)  AlR(5)  AuT(1)  AuT(2)  AuT(3)  AuT(4)  AuT(5)  AlT(1)  AlT(2)  AlT(3)  AlT(4)  AlT(5) W_mtow_0 W_fuel_0 LD_0];
ub = [6.5                1            6       6             0.5         16          25              4           0.5       0.5    0.5    0.5      0.5     0.5     0.5     0.5     0.5     0.5    0.5       0.5    0.5    0.5      0.5     0.5     0.5     0.5     0.5     0.5   50000     20000    30];
ub_n = ub./x_0normalizing;
%Lower bounds
%lb = [Rootchord_0  Taper_mid_0  Root_twist_0 Mid_twist_0  Taper_tip_0  Tip_span_0  LE_sweep_tip_0  Tip_twist_0 AuR(1)  AuR(2)  AuR(3)  AuR(4)  AuR(5)  AlR(1)  AlR(2)  AlR(3)  AlR(4)  AlR(5)  AuT(1)  AuT(2)  AuT(3)  AuT(4)  AuT(5)  AlT(1)  AlT(2)  AlT(3)  AlT(4)  AlT(5) W_mtow_0 W_fuel_0 LD_0];
lb = [5                 0.5             -6    -6           0.2          12          10              -4          -0.5      -0.5   -0.5   -0.5     -0.5    -0.5    -0.5    -0.5    -0.5    -0.5   -0.5      -0.5  -0.5   -0.5     -0.5    -0.5     -0.5    -0.5    -0.5    -0.5   30000     10000    6];
lb_n = lb./x_0normalizing;
%%
bounddiff = ub_n-lb_n;
%Normalized x0 vector
x0_n = x0./x_0normalizing;

%show reference geometry
%showGeometry(x0_n);


%set this true if you want the data to be written to the data files
global write_data
write_data = true;

%make a file to write all wanted data to from within the different
%disciplines every iteration
global fid_data
fid_data = fopen('dataObtained.dat','wt');
fprintf(fid_data, '%15s%15s%15s%15s%15s%15s\n' ,'L/D' ,'L_mean', 'M_mean', 'C_mean','W_wing', 'W_frac');

%file to write the vector to every iteration without the airfoil
%coefficients
global fid_vector
fid_vector = fopen('dataVector.dat','wt');
fprintf(fid_vector, ['%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s\n'] ,'chord_R',  'taper_M', 'twist_R' ,'twist_M', 'taper_tip', 'span' , 'sweep_tip',   'twist_T', 'MTOW', 'W_fuel');

%file to write the airfoil coefficients to every iteration
global fid_coeffs
fid_coeffs = fopen('dataCoeffs.dat','wt');
fprintf(fid_coeffs, '%65s%65s\n' ,'Coefficients Root Upper',  'Coefficients Root Lower');
fprintf(fid_coeffs, '%65s%65s\n' ,'Coefficients Tip Upper',  'Coefficients Tip Lower');


options = optimset('Display','iter','Algorithm','sqp',Tolfun = 0.000001);
[x_upper,fval,exitflag,output] = fmincon(@objective,x0_n,[],[],[],[],lb_n,ub_n,@constraints,options);


%close data file
fclose(fid_data);
