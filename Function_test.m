%This file was created to test functions 

%Copied the initial design vector from master.m
%If this is changed, the new version should be copied to test the
%individual functions.

Rootchord_0 = 5.78 ;
Taper_mid_0 = 0.699;
Taper_tip_0 = 0.356;
Root_twist_0 = 4;
Mid_twist_0 = 2.26;
Tip_twist_0 = -0.44;
Tip_span_0 = 14.038 ;
LE_sweep_tip_0 = 19.37 ;
W_mtow_0 =  43090;         %[kg]
W_zerofuel =  35830;         %[kg]
W_fuel_0 = 13365*0.81715;           %[m^3]*[kg/m^3] = [kg]

%Defign the root and tip airfoil
%e553
AuR = [0.2171    0.3450    0.2975    0.2685    0.2893];
AlR = [-0.1299   -0.2388   -0.1635   -0.0476    0.0797];

%the 0.1 and -0.05 are chosen  in order to make the tip thinner than the
%root
AuT = [0.2171     0.1    0.2975    0.2685    0.2893];
AlT = [-0.1299   -0.05   -0.1635   -0.0476    0.0797];



x0 = [Rootchord_0  Taper_mid_0  Root_twist_0 Mid_twist_0  Taper_tip_0  Tip_span_0  LE_sweep_tip_0  Tip_twist_0 AuR(1)  AuR(2)  AuR(3)  AuR(4)  AuR(5)  AlR(1)  AlR(2)  AlR(3)  AlR(4)  AlR(5)  AuT(1)  AuT(2)  AuT(3)  AuT(4)  AuT(5)  AlT(1)  AlT(2)  AlT(3)  AlT(4)  AlT(5) W_mtow_0 W_fuel_0];
%x0 =[    1             2           3              4          5            6              7             8        9       10      11      12      13      14      15      16      17      18      19      20     21       22      23      24      25      26      27     28        29      30   ]; 

%--------------------------------------------------------------------------------------------------------------------------------------------------------

%Krijg een warning: Warning: airfoil transonic analysis diverged:no output
%produced.
%[Aero_LD] = Aerodynamics(x0);

%Werkt volgensmij naar behoren
%[loadVector] = loads(x0);

%obtaining initial values for Cd_nowing and W_nowing
CD_nowing = fun_findCda_w(x0);
W_nowing = fun_findW_AW(x0);


%Going through all disciplines for the reference aircraft
LD = Aerodynamics(x0);
loads(x0);
W_wing = structures(x0);
W_endOverStart = performance(x0,LD);  %LD is directly fed into performance

%objective function
MTOW = (W_nowing+W_wing)/(0.938*W_endOverStart);

disp(MTOW);







