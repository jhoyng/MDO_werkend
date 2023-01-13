function [W_AW] = fun_findW_AW(x)
global x_0normalizing
x = x.*x_0normalizing;
%incidence angle toevoegen , mzf wordt fuel weight

MTOW        =    x(29);         %[kg]
MZF         =    x(29)- x(30);         %[kg]
nz_max      =    2.5;   
span_tip    =    x(6);            %[m]
root_chord  =    x(1);           %[m]
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

fprintf(fid,'%g %g \n',eff_factor,pitch_rib)
fprintf(fid,'1 \n')
fclose(fid)

EMWET Fokker100
%%

fileID = fopen('Fokker100.weight','r');
formatSpec = '%s';

A = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

W_strWing = str2double(A{1,1}{1,1}(23:29));
W_fuel = MTOW - MZF;

W_AW = MTOW - W_fuel - W_strWing;  %klopt dit?
end