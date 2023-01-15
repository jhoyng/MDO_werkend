
clear all;
close all;
%Initial values of design vector
Rootchord_0 = 5.78 ;
Taper_mid_0 = 0.699;
Taper_tip_0 = 0.356;
Root_twist_0 = 0.1; %4;
Mid_twist_0 = 0.1; %2.62;
Tip_twist_0 = 0.1; %-0.44;    
Tip_span_0 = 14.038 ;
LE_sweep_tip_0 = 19.37 ;
W_mtow_0 =  43090-520;       %[kg]
W_fuel_0 = 12950*0.81715; %13365*0.81715-5696.73;       %[m^3]*[kg/m^3] = [kg]
LD_0 = 9.67065; %16+8.1744;

%Defign the root and tip airfoil
%e553
%Defign the root and tip airfoil
%f100 root and tip
AuR =[0.153528825211809;0.114367804944869;0.212917645596938;0.119276832908319;0.069646397047114];
AlR = [-0.169319963986527;-0.092193075229581;-0.302733614226347;-0.092782085231768;-0.108253650607020];
AuT =[0.180964236453140;0.112375548755489;0.199250369688744;0.144259294381080;0.150037563263751];
AlT = [-0.152238948766128;0.102651482055201;-0.333682672036304;0.114339150685438;-0.156366477902652];

%removed Root_twist_0
%x0 = [Rootchord_0  Taper_mid_0  Root_twist_0 Mid_twist_0  Taper_tip_0  Tip_span_0  LE_sweep_tip_0  Tip_twist_0 AuR(1)  AuR(2)  AuR(3)  AuR(4)  AuR(5)  AlR(1)  AlR(2)  AlR(3)  AlR(4)  AlR(5)  AuT(1)  AuT(2)  AuT(3)  AuT(4)  AuT(5)  AlT(1)  AlT(2)  AlT(3)  AlT(4)  AlT(5) W_mtow_0 W_fuel_0 LD_0];
x0 = [Rootchord_0  Taper_mid_0    Mid_twist_0  Taper_tip_0  Tip_span_0  LE_sweep_tip_0  Tip_twist_0    AuR(1)  AuR(2)  AuR(3)  AuR(4)  AuR(5)  AlR(1)  AlR(2)  AlR(3)  AlR(4)  AlR(5)  AuT(1)  AuT(2)  AuT(3)  AuT(4)  AuT(5)  AlT(1)  AlT(2)  AlT(3)  AlT(4)  AlT(5) W_mtow_0 W_fuel_0 LD_0];
x0(10:12) = x0(10:12)/2;
x0(15:17) = x0(15:17)/2;
x0(20:22) = x0(20:22)/2;
x0(25:27) = x0(25:27)/2;

%x0 = [6.5     0.688382      2.70705     0.200003           16      16.9628     -0.43562          0.1     0.067593     0.112645     0.108532    0.0584835         -0.1    0.0675909     0.111645     0.108479    0.0584867          0.1     0.146733    0.0191988     0.108537    -0.220665         -0.1     0.146757    0.0181988     0.108527    -0.221665      36797.5      4477.69      29.7583];

%x0 =   [1             2             3               4          5            6              7             8        9       10      11      12      13      14      15      16      17      18      19      20     21       22      23      24      25      26      27     28        29      30]; 

%removed Root_twist_0
%start from last point
%x0 = [3.08474          0.5     -3.64968      4.23567          0.2      6.14038      20.0165    -0.417936     0.327636     0.442008     0.472959     0.111562   -0.0123295    -0.342126    -0.423072    -0.493525    -0.241739     -0.10572     0.173443     0.112376     0.191729     0.140151    0.0965042     -0.14813     0.102651    -0.326161     0.117752   -0.0429229      6991.39      4844.71      22.5829];
%x0 = [3.08474          0.5      4.23567          0.2      6.14038      20.0165    -0.417936     0.327636     0.442008     0.472959     0.111562   -0.0123295    -0.342126    -0.423072    -0.493525    -0.241739     -0.10572     0.173443     0.112376     0.191729     0.140151    0.0965042     -0.14813     0.102651    -0.326161     0.117752   -0.0429229      6991.39      4844.71      22.5829];
%x0 =   [1             2           3              4          5            6              7             8        9       10      11      12      13      14      15      16      17      18      19      20     21       22      23      24      25      26      27     28        29      30    31]; 

%Overwriting x0 with last result before error
%x0 = [5.77762     0.699028            4      2.61999        0.356       14.038        19.37        -0.44 0.153529     0.114368     0.212918     0.119277    0.0696464     -0.16932   -0.0921931    -0.302734   -0.0927821    -0.108254 0.180964     0.112376      0.19925     0.144259     0.150038    -0.152239     0.102651    -0.333683     0.114339    -0.156366  42856.4      10253.6  24.3184];


%x0 after converged inviscid analysis:
%x0 = [3     0.501896            6     0.350401           16           10        -0.44     0.382615     0.468861     0.473597      0.32561    -0.478287    -0.382844    -0.496927    -0.494673    -0.373377     0.375517     0.327627     0.286618     0.367932      0.30702    -0.378023    -0.152239     0.278485    -0.333683     0.281994     0.479095      37718.8      6072.37      18.7466];

coeff_mean = 0.01;


global x_0normalizing
x_0normalizing = abs([x0(1:7)  coeff_mean*ones(1,20)  x0(28:30)]);

global ub
global lb
%Creating bounds for the design variables
%Upper bounds
%ub = [Rootchord_0  Taper_mid_0  Mid_twist_0  Taper_tip_0  Tip_span_0  LE_sweep_tip_0  Tip_twist_0   AuR(1)    AuR(2)  AuR(3)  AuR(4)  AuR(5)  AlR(1)  AlR(2)  AlR(3)  AlR(4)  AlR(5)  AuT(1)  AuT(2)  AuT(3)  AuT(4)  AuT(5)  AlT(1)  AlT(2)  AlT(3)  AlT(4)  AlT(5) W_mtow_0 W_fuel_0 LD_0];
ub = [6.5                1          4             0.5         16          40              3           0.4       0.5      0.5    0.5      0.5     -0.1     0.5     0.5     0.5     0.5    0.4       0.5    0.5    0.5      0.5     -0.1     0.5     0.5     0.5     0.5   50000     15000    30];
ub_n = ub./x_0normalizing;
%Lower bounds
%lb = [Rootchord_0  Taper_mid_0   Mid_twist_0  Taper_tip_0  Tip_span_0  LE_sweep_tip_0  Tip_twist_0 AuR(1)   n AuR(2)  AuR(3)  AuR(4)  AuR(5)  AlR(1)  AlR(2)  AlR(3)  AlR(4)  AlR(5)  AuT(1)  AuT(2)  AuT(3)  AuT(4)  AuT(5)  AlT(1)  AlT(2)  AlT(3)  AlT(4)  AlT(5) W_mtow_0 W_fuel_0 LD_0];
lb = [4.8                 0.5           -0.5           0.2          6          10              -1          0.1      -0.5   -0.5   -0.5     -0.5    -0.4    -0.5    -0.5    -0.5    -0.5   0.1      -0.5  -0.5   -0.5     -0.5    -0.4     -0.5    -0.5    -0.5    -0.5   1000     5000    6];
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
fprintf(fid_data, '%15s%15s%15s%15s%15s%15s%15s%15s%15s%15s\n' ,'L/D' ,'L_mean', 'M_mean', 'C_mean','W_wing', 'W_frac','c1','cc1','cc2','cc3');

%file to write the vector to every iteration without the airfoil
%coefficients
global fid_vector
fid_vector = fopen('dataVector.dat','wt');
fprintf(fid_vector, '%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s\n' ,'chord_R',  'taper_M' ,'twist_M', 'taper_tip', 'span' , 'sweep_tip',   'twist_T', 'MTOW', 'W_fuel','L/D');

%file to write the vector to every iteration
global fid_fullVector
fid_fullVector = fopen('dataFullVector.dat','wt');
fprintf(fid_fullVector, '%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s%13s\n' ,'chord_R',  'taper_M','twist_M', 'taper_tip','Root Upper','', '',  '',   '',  'Root Lower',   '',   '',   '',   '',   'Tip Upper',  '',   '',   '',   '',   'Tip Lower',   '',  '',   '',   '',  'span' , 'sweep_tip',   'twist_T', 'MTOW', 'W_fuel');

%write file to store bounds and current iteration




%file to write the airfoil coefficients to every iteration
global fid_coeffs
fid_coeffs = fopen('dataCoeffs.dat','wt');
fprintf(fid_coeffs, '%65s%65s\n' ,'Coefficients Root Upper',  'Coefficients Root Lower');
fprintf(fid_coeffs, '%65s%65s\n' ,'Coefficients Tip Upper',  'Coefficients Tip Lower');


options.Display         = 'iter';
options.Algorithm       = 'sqp';
options.FunValCheck     = 'off';
options.PlotFcns = {@optimplotfval, @optimplotx, @optimplotfirstorderopt, @optimplotconstrviolation, @optimplotfunccount, @optimplotstepsize};
options.DiffMinChange   = 1e-2;         % Minimum change while gradient searching
options.DiffMaxChange   = 1e-1;         % Maximum change while gradient searching
options.TolCon          = 1e-3;         % Maximum difference between two subsequent constraint vectors [c and ceq]
options.TolFun          = 1e-3;         % Maximum difference between two subsequent objective value
options.TolX            = 1e-10;         % Maximum difference between two subsequent design vectors
%options.FinDiffType = 'central';
options.MaxIter         = 30;           % Maximum iterations
%options = optimset('Display','iter','Algorithm','sqp',Tolfun = 0.000001);

tic
[x_upper,fval,exitflag,output] = fmincon(@objective,x0_n,[],[],[],[],lb_n,ub_n,@constraints,options);
toc


%close data file
fclose(fid_coeffs);
fclose(fid_fullVector);
fclose(fid_vector);
fclose(fid_data);
