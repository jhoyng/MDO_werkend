function showGeometry(x)


MTOW        =    x(29);         %[kg]
MZF         =    x(29)- x(30);         %[kg]
nz_max      =    2.5;   
span_tip    =    x(6);            %[m]
root_chord  =    x(1);           %[m]
taper1       =    x(2);
taper2       =    x(5);   
sweep2_LE   = x(7);
Incidence_root = x(3);
Incidence_mid = x(4);
Incidence_tip = x(8);

sweep1_TE   =   4.60;   %set in stone
loc_kink = sweep1_TE / span_tip;
y1 = 0;
y2 = 4.79;              %set in stone
y3 = span_tip;

x1 = 0;
x2 = root_chord + tan(sweep1_TE/180*pi) * y2 - root_chord*taper1;
x3 = x2+ tan(sweep2_LE/180*pi) * (span_tip-y2);

z1 = 0;
z2 = tan(3/180*pi)*y2;
z3 = tan(3/180*pi)*(y3);

mid_chord = root_chord * taper1;
tip_chord = mid_chord * taper2;

%%

AuR = [x(9)    x(10)    x(11)    x(12)    x(13)]; 
AlR = [x(14)   x(15)   x(16)   x(17)    x(18)];
AuT = [x(19)   x(20)    x(21)    x(22)    x(23)];
AlT = [x(24)   x(25)   x(26)   x(27)    x(28)];


AuM = (AuR*(1-loc_kink)+AuT*loc_kink);
AlM = (AlR*(1-loc_kink)+AlT*loc_kink);



[XtuR,XtlR,C] = D_airfoil2(AuR,AlR,linspace(0,1,300)');
[XtuM,XtlM,C] = D_airfoil2(AuM,AlM,linspace(0,1,300)');
[XtuT,XtlT,C] = D_airfoil2(AuT,AlT,linspace(0,1,300)');

%Plot the 3 functions in a 3D graph
hold on
disp(Incidence_root);
plot3(root_chord*XtlR(:,1),y1*ones(300,1), root_chord *XtlR(:,2)-XtlR(:,1)*tan(Incidence_root*pi/180)*root_chord,'b');    %plot lower surface coords
plot3(root_chord*XtuR(:,1),y1*ones(300,1), root_chord *XtuR(:,2)-XtlR(:,1)*tan(Incidence_root*pi/180)*root_chord,'b');    %plot upper surface coords
plot3(x2+mid_chord*XtlM(:,1),y2*ones(300,1), z2+mid_chord*XtlM(:,2)-XtlR(:,1)*tan(Incidence_mid*pi/180)*mid_chord,'b');    %plot lower surface coords
plot3(x2+mid_chord*XtuM(:,1),y2*ones(300,1), z2+mid_chord*XtuM(:,2)-XtlR(:,1)*tan(Incidence_mid*pi/180)*mid_chord,'b');    %plot upper surface coords
plot3(x3+tip_chord*XtlT(:,1),y3*ones(300,1), z3+tip_chord*XtlT(:,2)-XtlR(:,1)*tan(Incidence_tip*pi/180)*tip_chord,'b');    %plot lower surface coords
plot3(x3+tip_chord*XtuT(:,1),y3*ones(300,1), z3+tip_chord*XtuT(:,2)-XtlR(:,1)*tan(Incidence_tip*pi/180)*tip_chord,'b');    %plot upper surface coords
plot3([0;x2],[0;y2],[0;z2], 'b');
plot3([root_chord;x2+mid_chord],[0;y2],[-tan(Incidence_root*pi/180)*root_chord;z2-tan(Incidence_mid*pi/180)*mid_chord], 'b');
plot3([x2;x3],[y2;y3],[z2;z3], 'b');
plot3([x2+mid_chord;x3+tip_chord],[y2;y3],[z2-tan(Incidence_mid*pi/180)*mid_chord;z3-tan(Incidence_tip*pi/180)*tip_chord], 'b');


view(45,45);

%Set x,y,z axis labels
xlabel('x Axis')
ylabel('y Axis') 
zlabel('z Axis')


% Add a title
title('Current Iteration Geometry');
axis([-5,span_tip-5,0,span_tip,-7,span_tip+7]);

end