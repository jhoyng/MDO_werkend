function [W_strWing,W_fmax] = structures(x)
% global x_0normalizing
% x = x.*x_0normalizing;


%incidence angle toevoegen , mzf wordt fuel weight

MTOW        =    x(28);         %[kg]
MZF         =    x(28)- x(29);         %[kg]
nz_max      =    2.5;   
span_tip    =    x(5);            %[m]
root_chord  =    x(1);           %[m]
taper1       =    x(2);
taper2       =    x(4);   
sweep2_LE = x(6);

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
Airfoil_root     =   'f100_root'; 
Airfoil_tip     =    'f100_tip'; 
section_num =    3;
airfoil_num =    2;
wing_surf   =    root_chord*(1+taper1)*y2+root_chord*(taper1 + taper1*taper2)*(y3-y2);

fid = fopen( 'Fokker100.init','wt');
fprintf(fid, '%g %g \n',MTOW,MZF);
fprintf(fid, '%g \n',nz_max);

fprintf(fid, '%g %g %g %g \n',wing_surf,span_tip*2,section_num,airfoil_num);

fprintf(fid, '0 %s \n',Airfoil_root);
fprintf(fid, '1 %s \n',Airfoil_tip);
fprintf(fid, '%g %g %g %g %g %g \n',root_chord,                 x1,y1,z1,spar_front,spar_rear);
fprintf(fid, '%g %g %g %g %g %g \n',root_chord*taper1,          x2,y2,z2,spar_front,spar_rear);
fprintf(fid, '%g %g %g %g %g %g \n',root_chord*taper1*taper2,   x3,y3,z3,spar_front,spar_rear);

fprintf(fid, '%g %g \n',ftank_start,ftank_end);

fprintf(fid, '%g \n', 0);

fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);

fprintf(fid,'%g %g \n',eff_factor,pitch_rib);
fprintf(fid,'0 \n');
fclose(fid);

EMWET Fokker100
%%

fileID = fopen('Fokker100.weight','r');
formatSpec = '%s';

A = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

W_strWing = str2double(A{1,1}{1,1}(23:end));
W_fuel = MTOW - MZF;

W_AW = MTOW - W_fuel - W_strWing;


loc_kink = sweep1_TE / span_tip;
chord1 = root_chord;
chord2 = root_chord*taper1;
chord3 = root_chord*taper1*taper2;

AuR = [x(8)    x(9)    x(10)    x(11)    x(12)]; 
AlR = [x(13)   x(14)   x(15)   x(16)    x(17)];
AuT = [x(18)   x(19)    x(20)    x(21)    x(22)];
AlT = [x(23)   x(24)   x(25)   x(26)    x(27)];

AuM = (AuR*(1-loc_kink)+AuT*loc_kink);
AlM = (AlR*(1-loc_kink)+AlT*loc_kink);


%From all airfoils, 21 points are taken which means 20 
xpoints = linspace(0,1,21)';

[Xtu1,Xtl1,C1] = D_airfoil2(AuR,AlR,xpoints);
[Xtu2,Xtl2,C2] = D_airfoil2(AuM,AlM,xpoints);
[Xtu3,Xtl3,C3] = D_airfoil2(AuT,AlT,xpoints);


%3 empty variables to start integrating over the 
area_dimless1 = 0;
area_dimless2 = 0;
area_dimless3 = 0;


for i = (5:12)
    area_dimless1 = area_dimless1+ (Xtu1(i,2)-Xtl1(i,2))/20;
end

for i = (5:12)
    area_dimless2 = area_dimless2+ (Xtu2(i,2)-Xtl2(i,2))/20;
end

for i = (5:12)
    area_dimless3 = area_dimless3+ (Xtu3(i,2)-Xtl3(i,2))/20;
end

A1 = area_dimless1*chord1^2;
A2 = area_dimless1*chord2^2;

A3 = area_dimless1*chord3^2;

v_f1 = loc_kink * span_tip * (A1+A2)/2;

frac2_3 = 1-loc_kink;
frac2_85 = 0.85 - loc_kink;
A85 = (1-frac2_85/frac2_3)*A2+frac2_85/frac2_3*A3;
v_f2 = frac2_85*span_tip*(A2+A85)/2;
v_f = (v_f2+v_f1)*0.93;
W_fmax = v_f*0.81715e3*2;


%write wing weight on the data file
global write_data


if write_data == true
    global fid_data
    fprintf(fid_data, '%15g', W_strWing);
end




end