
clear all;
close all;

params = refParams();
global loc_kink;
loc_kink = params.loc_kink;


%Defign the root and tip airfoil
%e553
AuR = [0.2171    0.3450    0.2975    0.2685    0.2893];
AlR = [-0.1299   -0.2388   -0.1635   -0.0476    0.0797];

%the 0.1 and -0.05 are chosen  in order to make the tip thinner than the
%root
AuT = [0.2171     0.1    0.2975    0.2685    0.2893];
AlT = [-0.1299   -0.05   -0.1635   -0.0476    0.0797];

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


