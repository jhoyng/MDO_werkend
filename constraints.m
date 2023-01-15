function [c, ceq] = constraints(x)
global x_0normalizing
x = x.*x_0normalizing;
%Global parameters
global couplings;
LD = couplings.LD;
Wingarea = couplings.Wingarea;
W_fuelMax = couplings.W_fuelMax;
MTOW = couplings.MTOW;
W_a_w = 3.110115025000000e+04;  %Nader in te vullen
W_wing = couplings.W_wing;
W_endOverStart = couplings.W_endOverStart;
Wingloading_ref = 3.923293889839573e+03;

%--------------------------------------
%from design vector
Chord_root = x(1);
Taper_mid = x(2) ;
Incidence_root = 4; %x(3);
Incidence_mid = x(3);
Taper_tip = x(4);
Span_tip = x(5);
Sweep_LE_tip = x(6)*(pi/180);
Incidence_tip = x(7);
W_mtow = x(28)*9.81;
W_fuel = x(29)*9.81;

%Fixed values from reference planform
TE_sweep_mid = 4.6*(pi/180);            
Span_mid = 4.64;                
Dihedral = 3*(pi/180);  
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
x_tip = x_mid + (Span_tip-Span_mid)*tan(Sweep_LE_tip);
y_tip = Span_tip;
z_tip = tan(Dihedral)*y_tip;
Chord_tip = Chord_mid*Taper_tip;
Incidence_tip = Incidence_tip;
%---------------------------------------------

%W_fuel_0 = x(30);
%LD = x(31);
%W_mtow_0 = x(29);

cc1 = ((W_a_w + W_wing)/((1/(1-0.938*W_endOverStart))-1) - x(29));        %Constraint that fuel weight of X0 equals output of performance %Hier zelfde som voor W_f gebruiken als bij constraint c1?
cc2 = (LD - x(30));         %Constraint that LD of x0 equals output of aerodynamics
cc3 = (MTOW - x(28));       %Constraint that MTOW of x0 equals that of the objective function

%Constraints that keep Upper CST coefs higher than lower CST coefs
%root Margin 
c4 = x(13) + 0.13 - x(8); %0.13
c5 = x(14) + 0.13 - x(9); %0.13
c6 = x(15) + 0.13 - x(10); %0.13
c7 = x(16) + 0.13 - x(11); %0.13
c8 = x(17) + 0.013 - x(12); %0.013
%tip
c9 = x(23) + 0.13 - x(18); %0.13
c10 = x(24) + 0.13 - x(19); %0.13
c11 = x(25) + 0.13 - x(20); %0.13
c12 = x(26) + 0.13 - x(21); %0.13
c13 = x(27) + 0.013 - x(22); %0.13

%Constraint that makes sure the sweep of the tip section is at least equal
%to that of the mid section
%SweepTETIP = atan(((x_mid+Chord_mid)-(x_root+Chord_root))/(y_mid-y_root));
%Margin of 3 deg added to constraint and added a weight of 20 to the
%constraint
c14 = ((4.60*pi/180) + (3*pi/180) - (atan(((x_tip+Chord_tip)-(x_mid+Chord_mid))/(y_tip-y_mid))))*20; %Sweet TE tip smaller than Sweep TE mid to prevent weird kink

c1 = ((W_a_w + W_wing)/((1/(1-0.938*W_endOverStart))-1) - W_fuelMax);  %Contraint that the required fuel is less than the maximum capacity
c2 = Wingarea/MTOW - Wingloading_ref ; %Constraint forcing the wing loading not to be higher than the wing loading of the reference aircraft


c = [c1/x_0normalizing(29), c2/Wingloading_ref, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14];
ceq = [cc1/x_0normalizing(29),cc2/x_0normalizing(30),cc3/x_0normalizing(28)];

%write the weight fraction on the data file
global write_data


if write_data == true
    global fid_data
    fprintf(fid_data, '%15g', c1 ,cc1,cc2,cc3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14);
    fprintf(fid_data, '\n');
end


end