function [v_f] = constraints(x)


global loc_kink
coeffs = x.coeffs;
span = x.span;
chord1 = x.chord1;
chord2 = x.chord2;
chord3 = x.chord3;

coeffsNr = 5;

AuR = coeffs(1,1:coeffsNr);
AlR = coeffs(1,coeffsNr+1:coeffsNr*2);
AuT = coeffs(2,1:coeffsNr);
AlT = coeffs(2,coeffsNr+1:coeffsNr*2);

AuM = (AuR*(1-loc_kink)+AuT*loc_kink);
AlM = (AlR*(1-loc_kink)+AlT*loc_kink);


%From all airfoils, 21 points are taken which means 20 
xpoints = linspace(0,1,21)';

[Xtu1,Xtl1,C1] = D_airfoil2(AuR,AlR,xpoints);
[Xtu2,Xtl2,C2] = D_airfoil2(AuM,AlM,xpoints);
[Xtu3,Xtl3,C3] = D_airfoil2(AuT,AlT,xpoints);
disp([Xtu1,Xtu3]);

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

v_f1 = loc_kink * span * (A1+A2)/2;

frac2_3 = 1-loc_kink;
frac2_85 = 0.85 - loc_kink;
A85 = (1-frac2_85/frac2_3)*A2+frac2_85/frac2_3*A3;
v_f2 = frac2_85*span*(A2+A85)/2;
v_f = (v_f2+v_f1)*0.93;
v_ftotalLitres = v_f*1000*0.93;


hold on
plot(Xtu1(:,1),Xtu1(:,2),'b');    %plot upper surface coords
plot(Xtl1(:,1),Xtl1(:,2),'b');    %plot lower surface coords
plot(Xtu2(:,1),Xtu2(:,2),'r');    %plot upper surface coords
plot(Xtl2(:,1),Xtl2(:,2),'r');    %plot lower surface coords
plot(Xtu3(:,1),Xtu3(:,2),'g');    %plot upper surface coords
plot(Xtl3(:,1),Xtl3(:,2),'g');    %plot lower surface coords
%plot(xpoints,lower_Out,'r');
%plot(xpoints,upper_Out,'r');
axis([0,1,-.5,.5]);
axis([0,1,-0.5,0.5]);
hold on;

end