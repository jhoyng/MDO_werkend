% Wing planform geometry 
%                x    y     z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [0     0     0     6.05         0;
                5.74  14.65   1.184     1.48         0];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|       | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   =    [0.2171    0.3450    0.2975    0.2685    0.2893    -0.1299   -0.2388   -0.1635   -0.0476    0.0797;
                        0.2171     0.1       0.2975    0.2685    0.2893    -0.1299   -0.05     -0.1635   -0.0476    0.0797];
                  

AC.Wing.eta = [0;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = 1;              % 0 for inviscid and 1 for viscous analysis
AC.Aero.MaxIterIndex = 150;    %Maximum number of Iteration for the
                                %convergence of viscous calculation
                 

V_Cruise = 414*0.514444;
meanChord = 3.8;                    %Mean chord, or mean aerodynamic chord?
rho = 0.3796;
alt = 35000*0.3048;
viscosity = 1.444e-5;
T_cruise = 218.808;
Re = rho* meanChord*V_Cruise/viscosity;
%AoA = params.AoA;
a = sqrt(1.4*287*T_cruise);
CruiseLD = 16;
Cruiseweight = 38780;                    %Nu MTOW gepakt
Wingarea = 93.50;
                                
% Flight Condition
AC.Aero.V     = V_Cruise;            % flight speed (m/s)
AC.Aero.rho   = rho;                    % air density  (kg/m3)
AC.Aero.alt   = alt;                    % flight altitude (m)
AC.Aero.Re    = Re;                     % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = V_Cruise/a;          % flight Mach number 
AC.Aero.CL    = 2*9.81*Cruiseweight/(rho*(V_Cruise^2)*Wingarea);                    % lift coefficient - comment this line to run the code for given alpha%
%AC.Aero.Alpha = params.AoA;            % angle of attack -  comment this line to run the code for given cl 



%% 
tic

Res = Q3D_solver(AC);
toc

%doesnt output load but outputs only Cl. This first has to be multiplied by
%the root and q in order to resemble the load so for now it is still wrong.
CD_nowing = (Res.CLwing/CruiseLD)-Res.CDwing; % Value CD_nowing = 0.0068

