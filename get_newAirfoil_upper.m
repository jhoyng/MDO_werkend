function [error] = get_newAirfoil_upper(x)

global airfoil; %if True then the root will be calculated, else the tip

% M = size(x,1)/2;
% Au = x(1:M);
% Al = x(M:end);


M = size(x,1);
Au = x;
Al = zeros(M,1);


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



foilSide_points_RU = [foilSide_RU(:,1)/100, (50-foilSide_RU(:,2))/100];
foilSide_points_RL = [foilSide_RL(:,1)/100, -1*(50-foilSide_RL(:,2))/100];
foilSide_points_TU = [foilSide_TU(:,1)/100, (50-(foilSide_TU(:,2) +  foilSide_TU(:,1) *0.49/100  ))  /100];
foilSide_points_TL = [foilSide_TL(:,1)/100, -1*(50-(foilSide_TL(:,2) - foilSide_TL(:,1)*0.49/100 ))/100];



if airfoil
    foilSide_points = foilSide_points_RU;

else
    foilSide_points = foilSide_points_TU;
end

%build the airfoil from the class function, C
[Xtu,Xtl,C] = D_airfoil2(Au,Al,foilSide_RU(:,1)/100);


airfoil_Out = Xtu(:,2);
reference_Out = foilSide_points(:,2);

%calculate the error with the least squares method
error = sum((airfoil_Out - reference_Out).^2);
end