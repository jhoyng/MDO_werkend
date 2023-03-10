function [loadVector] = loads(x)

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

%Fixed values from reference planform
TE_sweep_mid = 4.6*(pi/180);            
Span_mid = 4.64;                
Dihedral = 3*(pi/180);                


%Planform description
x_root = 0;
y_root = 0;
z_root = 0;
x_mid = (Chord_root+tan(TE_sweep_mid)*Span_mid-(Taper_mid*Chord_root));
y_mid = Span_mid;
z_mid = Span_mid*tan(Dihedral);
Chord_mid = Taper_mid*Chord_root;

y_tip = Span_tip;
z_tip = tan(Dihedral)*y_tip;
x_tip=  x_mid+ Chord_mid+ tan(TE_sweep_mid+kinkAngle)*(y_tip-y_mid)-Chord_mid*Taper_tip;

Chord_tip = Chord_mid*Taper_tip;


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
AC.Visc  = 0;                           % 0 for inviscid and 1 for viscous analysis
AC.Aero.MaxIterIndex = 150;             %Maximum number of Iteration for the
                                        %convergence of viscous calculation


%Flight conditions
rho = 0.3796;
alt = 35000*0.3048;
viscosity = 1.444e-5;
T_cruise = 218.808;
%AoA = params.AoA;
a = sqrt(1.4*287*T_cruise);
V_mo = 0.77*a;                          %Machnr*a
V_Cruise = V_mo;                        %In loads, we use maximum operative speed for the structural calculations
Cruiseweight = W_mtow;                   %Functie voor design point uit assignment gebruiken
n_loadfactor = 2.5;
Wingarea = 2*((Chord_root+Chord_mid)/2)*Span_mid+((Chord_mid+Chord_tip)/2)*(Span_tip-Span_mid);                        
%meanChord = (2/Wingarea)*((Chord_root*Span_mid-(0.5*((Chord_root-Chord_mid)/Span_mid)*Span_mid^2))+(Chord_mid*(Span_tip-Span_mid)-(0.5*((Chord_mid-Chord_tip)/(Span_tip-Span_mid))*(Span_tip-Span_mid)^2)));                        %Mean aerodynamic chord?


fun1 = @(integry) ((Chord_root-(Chord_root-Chord_mid)/Span_mid*integry).^2);
fun2 = @(integry2) ((Chord_mid-(Chord_mid-Chord_tip)/(Span_tip-Span_mid)*integry2).^2);
MAC1 = integral(fun1,0,Span_mid);
MAC2 = integral(fun2,Span_mid,(Span_tip-Span_mid));
meanChord = (2/(Wingarea))*(MAC1+MAC2);


Re = rho* meanChord*V_Cruise/viscosity;

% Flight Condition
AC.Aero.V     = V_Cruise;               % flight speed (m/s)
AC.Aero.rho   = rho;                    % air density  (kg/m3)
AC.Aero.alt   = alt;                    % flight altitude (m)
AC.Aero.Re    = Re;                     % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = V_Cruise/a;             % flight Mach number 
AC.Aero.CL    = 2*Cruiseweight*n_loadfactor/(rho*(V_Cruise^2)*Wingarea);                    % lift coefficient - comment this line to run the code for given alpha%
%AC.Aero.Alpha = params.AoA;            % angle of attack -  comment this line to run the code for given cl 



%% 

Res = Q3D_solver(AC);


q = 0.5*rho*(V_Cruise^2);%dynamic pressure
loadVector = [Res.Wing.Yst/(Span_tip)  Res.Wing.ccl.*q  Res.Wing.cm_c4.*meanChord.*Res.Wing.chord.*q];
fid = fopen( 'Fokker100.load','wt');
for i = 1:14
    fprintf(fid, '%g %g %g \n' ,loadVector(i,1),loadVector(i,2),loadVector(i,2));
end
fclose(fid);





end