

sweep1_TE   =   4.60;
%Initial values of design vector
Rootchord_0 = 5.78 ;
Taper_mid_0 = 0.699;
Taper_tip_0 = 0.356;
Root_twist_0 = 3;
Mid_twist_0 = 2;
Tip_twist_0 = 0;
Tip_span_0 = 28.076/2;
LE_sweep_tip_0 = 19.37 ;

%Defign the root and tip airfoil
%e553
AuR = [0.2171    0.3450    0.2975    0.2685    0.2893];
AlR = [-0.1299   -0.2388   -0.1635   -0.0476    0.0797];

%the 0.1 and -0.05 are chosen  in order to make the tip thinner than the
%root
AuT = [0.2171     0.1    0.2975    0.2685    0.2893];
AlT = [-0.1299   -0.05   -0.1635   -0.0476    0.0797];

x0 = [Rootchord_0  Taper_mid_0  Root_twist_0 Mid_twist_0  Taper_tip_0  Tip_span_0  LE_sweep_tip_0  Tip_twist_0 AuR(1)  AuR(2)  AuR(3)  AuR(4)  AuR(5)  AlR(1)  AlR(2)  AlR(3)  AlR(4)  AlR(5)  AuT(1)  AuT(2)  AuT(3)  AuT(4)  AuT(5)  AlT(1)  AlT(2)  AlT(3)  AlT(4)  AlT(5)];
%X0 =  C_root       Taper_M        Twist_root   Twist_mid   Taper_T     span_tip   sweep_LE_tip       Twist_tip
%X0 =   1             2                 3           4         5              6         7                   8
%%%_____Routine to write the input file for the EMWET procedure________% %%

x = x0;


% namefile    =    char('Fokke100');
MTOW        =    43090;         %[kg]
MZF         =    35830;         %[kg]
nz_max      =    2.5;   
span_tip        =    x(6);            %[m]
root_chord =    x(1);           %[m]
taper1       =    x(2);
taper2       =    x(5);   
sweep2_LE = x(7);

sweep1_TE   =   4.60;   %set in stone
y1 = 0;
y2 = 4.79;              %set in stone
y3 = span_tip;

x1 = 0;
x2 = root_chord + tan(sweep1_TE/180*pi) * y2 - root_chord*taper1;
x3 = x2+ tan(sweep2_LE/180*pi) * (span_tip-y2);

z1 = 0;
z2 = tan(3/180*pi)*y2;
z3 = tan(3/180*pi)*(y3);

spar_front  =    0.175;
spar_rear   =    0.575;
ftank_start =    0.1;
ftank_end   =    0.85;
E_al        =    7.0E10;       %N/m2
rho_al      =    2800;         %kg/m3
Ft_al       =    2.95E8;        %N/m2
Fc_al       =    2.95E8;        %N/m2
pitch_rib   =    0.5;          %[m]
eff_factor  =    0.96;             %Depend on the stringer type
Airfoil     =    'e553'; 
section_num =    3;
airfoil_num =    2;
wing_surf   =    root_chord*(1+taper1)*y2+root_chord*(taper1 + taper1*taper2)*(y3-y2);

fid = fopen( 'Fokker100reference.init','wt');
fprintf(fid, '%g %g \n',MTOW,MZF);
fprintf(fid, '%g \n',nz_max);

fprintf(fid, '%g %g %g %g \n',wing_surf,span_tip*2,section_num,airfoil_num);

fprintf(fid, '0 %s \n',Airfoil);
fprintf(fid, '1 %s \n',Airfoil);
fprintf(fid, '%g %g %g %g %g %g \n',root_chord,                 x1,y1,z1,spar_front,spar_rear);
fprintf(fid, '%g %g %g %g %g %g \n',root_chord*taper1,          x2,y2,z2,spar_front,spar_rear);
fprintf(fid, '%g %g %g %g %g %g \n',root_chord*taper1*taper2,   x3,y3,z3,spar_front,spar_rear);

fprintf(fid, '%g %g \n',ftank_start,ftank_end);

fprintf(fid, '%g \n', 0);

fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);

fprintf(fid,'%g %g \n',eff_factor,pitch_rib)
fprintf(fid,'1 \n')
fclose(fid)

EMWET Fokker100reference
%%

fileID = fopen('Fokker100reference.weight','r');
formatSpec = '%s';
sizeA = [2 Inf];

A = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

W_strWing = str2double(A{1,1}{1,1}(23:29));

