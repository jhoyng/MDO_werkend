
clear all;
close all;


%Create initial values for design vector x0

%Create bounds for all variables in design vector ub, lb

%Settings for fmincon

%fmincon

%Initial values of design vector
Rootchord_0 = ;
Taper_mid_0 = ;
Root_twist_0 = ;
Mid_twist_0 = ;
Taper_tip_0 = ;
Tip_span_0 = ;
LE_sweep_tip_0 = ;
Tip_twist_0 = ;
W_mtwo_aero = ; %[Newton]
W_fuel_aero = ; %[Newton]

%Defign the root and tip airfoil
%e553
AuR = [0.2171    0.3450    0.2975    0.2685    0.2893];
AlR = [-0.1299   -0.2388   -0.1635   -0.0476    0.0797];

%the 0.1 and -0.05 are chosen  in order to make the tip thinner than the
%root
AuT = [0.2171     0.1    0.2975    0.2685    0.2893];
AlT = [-0.1299   -0.05   -0.1635   -0.0476    0.0797];

x0 = [Rootchord_0  Taper_mid_0  Root_twist_0 Mid_twist_0  Taper_tip_0  Tip_span_0  LE_sweet_tip_0  Tip_twist_0 AuR(1)  AuR(2)  AuR(3)  AuR(4)  AuR(5)  AlR(1)  AlR(2)  AlR(3)  AlR(4)  AlR(5)  AuT(1)  AuT(2)  AuT(3)  AuT(4)  AuT(5)  AlT(1)  AlT(2)  AlT(3)  AlT(4)  AlT(5)  W_mtow_aero  W_fuel_aero];



params = refParams();
global loc_kink;
loc_kink = params.loc_kink;


%Calculate the airfoil at the kink by linear interpolation between the root
%and tip chord.


%put these coefficients in the design vector




designVector.coeffs = [AuR   AlR;
                        AuT  AlT];

designVector.chord1 = 6.05;
designVector.chord2 = 4.16;
designVector.chord3 = 1.42;
designVector.span = 28.076;




span = designVector.span;



disp(constraints(designVector));
res = loads(designVector);





%% 
% tic
% 
% Res = Q3D_solver(AC);
% disp(Res.Wing.cl);
% toc


