%Initial values of design vector
Rootchord_0 = 5.78 ;
Taper_mid_0 = 0.699;
Taper_tip_0 = 0.356;
Root_twist_0 = 4;
Mid_twist_0 = 2.62;
Tip_twist_0 = -0.44;    
Tip_span_0 = 14.038 ;
LE_sweep_tip_0 = 19.37 ;
W_mtow_0 =  43090-5696.73;       %[kg]
W_fuel_0 = 13365*0.81715-5696.73;       %[m^3]*[kg/m^3] = [kg]
LD_0 = 16+8.1744;

%Defign the root and tip airfoil
%e553
%Defign the root and tip airfoil
%f100 root and tip
AuR =[0.153528825211809;0.114367804944869;0.212917645596938;0.119276832908319;0.069646397047114];
AlR = [-0.169319963986527;-0.092193075229581;-0.302733614226347;-0.092782085231768;-0.108253650607020];
AuT =[0.180964236453140;0.112375548755489;0.199250369688744;0.144259294381080;0.150037563263751];
AlT = [-0.152238948766128;0.102651482055201;-0.333682672036304;0.114339150685438;-0.156366477902652];

x0 = [Rootchord_0  Taper_mid_0    Mid_twist_0  Taper_tip_0  Tip_span_0  LE_sweep_tip_0  Tip_twist_0    AuR(1)  AuR(2)  AuR(3)  AuR(4)  AuR(5)  AlR(1)  AlR(2)  AlR(3)  AlR(4)  AlR(5)  AuT(1)  AuT(2)  AuT(3)  AuT(4)  AuT(5)  AlT(1)  AlT(2)  AlT(3)  AlT(4)  AlT(5) W_mtow_0 W_fuel_0 LD_0];

%[W_strWing,W_fmax, wingsurf] = structures(x0);

%[CD_nowing, D_nowing] = fun_findCda_w(x0);

[Aero_LD] = Aerodynamics(x0);


