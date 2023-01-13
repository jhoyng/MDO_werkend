close all;
clear all;
clc


%here you choose whether you want to obtain the airfoil for the root or tip
%, true or false have to be chosen respectively
global airfoil;

airfoil = false; %if True then the root will be calculated, else the tip

M = 10;  %Number of CST-coefficients in design-vector x

%Define optimization parameters
x0 = 1*ones(M,1);%initial value of design vector x(starting vector for search process)=

lb = -1.5*ones(M,1);    %upper bound vector of x
ub = 1.5*ones(M,1);     %lower bound vector of x


options = optimset('Display','iter','Algorithm','sqp',Tolfun = 0.000001);

%fit an airfoil through the points of the upper side points
[x_upper,fval,exitflag,output] = fmincon(@get_newAirfoil_upper,x0,[],[],[],[],lb,ub,[],options);

%fit an airfoil through the points of the lower side points
[x_lower,fval,exitflag,output] = fmincon(@get_newAirfoil_lower,x0,[],[],[],[],lb,ub,[],options);


Au = x_upper;
Al = x_lower;


[Xtu,Xtl,C] = D_airfoil2(Au,Al,linspace(0,1,1000)');
%%

%all data points found from analysing the root and tip airfoils. 

%Root upper side 
foilSide_RU=   [0      50;
            0.25    49.2;
            0.5     48.93
            1       48.51
            2       47.93
            4       47.17
            8       46.17
            12      45.57
            18      44.96
            22      44.69
            30      44.30
            40      44.09
            50      44.63
            60      45.51
            70      46.79
            80      47.85
            90      49.09
            95      49.75
            100     50];

%Root lower side
foilSide_RL=   [0      50
            0.25    49.21
            0.5     48.72
            1       48.17
            2       47.69
            4       47.01
            8       46.14
            12      45.34
            18      44.59
            22      44.19
            30      43.52
            40      43.43
            50      43.79
            60      44.75
            70      46.03
            80      47.75
            90      49.01
            95      49.33
            100     50];

%Tip upper side
foilSide_TU=   [0      50;
            0.25    49.36;
            0.5     48.84
            1       48.29
            2       47.55
            4       46.58
            8       45.68
            12      44.93
            18      44.59
            22      44.28
            30      43.98
            40      43.81
            50      44.08
            60      44.73
            70      45.71
            80      46.88
            90      48.15
            95      48.72
            100     49.51];

%Tip lower side
foilSide_TL=   [0      50;
            0.25    49.12;
            0.5     48.72
            1       48.36
            2       48.02
            4       47.88
            8       47.78
            12      47.84
            18      47.69
            22      47.47
            30      47.05
            40      46.91
            50      47.20
            60      47.82
            70      48.51
            80      48.93
            90      49.68
            95      50.20
            100     50.49];
%%



%the points obtained before where on a grid 100 times larger than unity so
%they are made smaller. Also the points on the tip are compensated for the
%trailin edge that was not on 0 but 0.49 off. 
foilSide_points_RU = [foilSide_RU(:,1)/100, (50-foilSide_RU(:,2))/100];
foilSide_points_RL = [foilSide_RL(:,1)/100, -1*(50-foilSide_RL(:,2))/100];
foilSide_points_TU = [foilSide_TU(:,1)/100, (50-(foilSide_TU(:,2) +  foilSide_TU(:,1) *0.49/100  ))  /100];
foilSide_points_TL = [foilSide_TL(:,1)/100, -1*(50-(foilSide_TL(:,2) - foilSide_TL(:,1)*0.49/100 ))/100];


%the root or tip airfoil is plotted
if airfoil
    foilSide_points_U = foilSide_points_RU;
    foilSide_points_L = foilSide_points_RL;

else
    foilSide_points_U = foilSide_points_TU;
    foilSide_points_L = foilSide_points_TL;
end


%%
hold on
plot(Xtu(:,1),Xtu(:,2),'b');    %plot upper surface coords
plot(Xtl(:,1),Xtl(:,2),'b');    %plot lower surface coords
scatter(foilSide_points_U(:,1),foilSide_points_U(:,2),'r');    %plot upper surface coords
scatter(foilSide_points_L(:,1),foilSide_points_L(:,2),'r');    %plot lower surface coords
axis([0,1,-.5,.5]);

