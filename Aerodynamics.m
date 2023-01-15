function [Aero_LD, Wingarea] = Aerodynamics(x)
global W_nowing
%from design vector
Chord_root = x(1);
Taper_mid = x(2) ;
Incidence_root = 4; %x(3);
Incidence_mid = x(3);
Taper_tip = x(4);
Span_tip = x(5);
kinkAngle = x(6)*(pi/180);
Incidence_tip = x(7);
W_mtow = (x(28)+W_nowing+x(29))*9.81;
W_fuel = x(29)*9.81;

%Fixed values from reference planform
TE_sweep_mid = 4.6*(pi/180); 

Span_mid = 4.64;                
Dihedral = 3*(pi/180);                


%Planform description
x_root = 0;
y_root = 0;
z_root = 0;
Chord_root = Chord_root;
Incidence_root = Incidence_root;
x_mid = (Chord_root+tan(TE_sweep_mid)*Span_mid-(Taper_mid*Chord_root));
y_mid = Span_mid;
z_mid = Span_mid*tan(Dihedral);
Chord_mid = Taper_mid*Chord_root;
Incidence_mid = Incidence_mid;




y_tip = Span_tip;
z_tip = tan(Dihedral)*y_tip;
x_tip=  x_mid+ Chord_mid+ tan(TE_sweep_mid+kinkAngle)*(y_tip-y_mid)-Chord_mid*Taper_tip;


Chord_tip = Chord_mid*Taper_tip;
Incidence_tip = Incidence_tip;


% Wing planform geometry 
%               x         y        z       chord(m)        twist angle (deg) 
AC.Wing.Geom = [x_root    y_root   z_root  Chord_root      Incidence_root;
                x_mid     y_mid    z_mid   Chord_mid       Incidence_mid;
                x_tip     y_tip    z_tip   Chord_tip       Incidence_tip];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;


%x0 = [Rootchord_0  Taper_mid_0  Root_twist_0 Mid_twist_0  Taper_tip_0  Tip_span_0  LE_sweet_tip_0  Tip_twist_0 AuR(1)  AuR(2)  AuR(3)  AuR(4)  AuR(5)  AlR(1)  AlR(2)  AlR(3)  AlR(4)  AlR(5)  AuT(1)  AuT(2)  AuT(3)  AuT(4)  AuT(5)  AlT(1)  AlT(2)  AlT(3)  AlT(4)  AlT(5)];
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.              <-|       | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   =    [x(8)    x(9)    x(10)    x(11)    x(12)        x(13)   x(14)   x(15)   x(16)    x(17);
                         x(18)   x(19)   x(20)    x(21)    x(22)        x(23)   x(24)   x(25)   x(26)    x(27)];


AC.Wing.eta = [0;1];                    % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = 1;                           % 0 for inviscid and 1 for viscous analysis
AC.Aero.MaxIterIndex = 150;             %Maximum number of Iteration for the
                                        %convergence of viscous calculation
global V_Cruise;

V_Cruise = 414*0.514444;


rho = 0.3796;
alt = 35000*0.3048;
viscosity = 1.444e-5;
T_cruise = 218.808;
%AoA = params.AoA;
a = sqrt(1.4*287*T_cruise);
Wingarea = 2*(((Chord_root+Chord_mid)/2)*Span_mid+((Chord_mid+Chord_tip)/2)*(Span_tip-Span_mid));                        
%meanChord = (2/Wingarea)*((Chord_root*Span_mid-(0.5*((Chord_root-Chord_mid)/Span_mid)*Span_mid^2))+(Chord_mid*(Span_tip-Span_mid)-(0.5*((Chord_mid-Chord_tip)/(Span_tip-Span_mid))*(Span_tip-Span_mid)^2)));                        %Mean aerodynamic chord?


fun1 = @(integry) ((Chord_root-(Chord_root-Chord_mid)/Span_mid*integry).^2);
fun2 = @(integry2) ((Chord_mid-(Chord_mid-Chord_tip)/(Span_tip-Span_mid)*integry2).^2);
MAC1 = integral(fun1,0,Span_mid);
MAC2 = integral(fun2,Span_mid,(Span_tip-Span_mid));
meanChord = (2/(Wingarea))*(MAC1+MAC2);

Re = rho* meanChord*V_Cruise/viscosity;
L_des = sqrt(W_mtow*(W_mtow-W_fuel));

% Flight Condition
AC.Aero.V     = V_Cruise;               % flight speed (m/s)
AC.Aero.rho   = rho;                    % air density  (kg/m3)
AC.Aero.alt   = alt;                    % flight altitude (m)
AC.Aero.Re    = Re;                     % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = V_Cruise/a;             % flight Mach number 
AC.Aero.CL    = 2*L_des/(rho*(V_Cruise^2)*Wingarea);                    % lift coefficient - comment this line to run the code for given alpha%
%AC.Aero.Alpha = params.AoA;            % angle of attack -  comment this line to run the code for given cl 


%% 

Res = Q3D_solver(AC);


CD_nowing = 0.015332090837714;
D_nowing =  1.034790713693754e+04;
dynpres = 0.5*rho*V_Cruise^2;
Aero_L = Res.CLwing*dynpres*Wingarea;
Aero_D = (Res.CDwing*dynpres*Wingarea)+D_nowing; %for viscous
%Aero_D = (Res.CDiwing*dynpres*Wingarea)+D_nowing; %for inviscid
Aero_LD = Aero_L/Aero_D;


%write L over D on the data file
global write_data


if write_data == true
    global fid_data
    fprintf(fid_data, '%15g', Aero_LD);
end


end