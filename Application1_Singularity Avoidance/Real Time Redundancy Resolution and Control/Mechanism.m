%--------------------------------------------------------------------------
function [M,G,P,fval]=Mechanism(q,q_1dot,k)
%--------------------------------------------------------------------------
global b m mp J
%--------------------------------------------------------------------------
px=q(1,k) ; py=q(2,k) ; teta=q(3,k);
ro1=q(4,k); ro2=q(5,k); ro3=q(6,k) ;
%--------------------------------------------------------------------------
R=[cos(teta) -sin(teta);sin(teta) cos(teta)];
E=[0 -1;1 0];

gama=[0, 2*pi/3, 4*pi/3];
Z1=[cos(gama(1)) -sin(gama(1));sin(gama(1)) cos(gama(1))];
Z2=[cos(gama(2)) -sin(gama(2));sin(gama(2)) cos(gama(2))];
Z3=[cos(gama(3)) -sin(gama(3));sin(gama(3)) cos(gama(3))];
%--------------------------------------------------------------------------
up1=Z1*eye(2,1)*ro1;
up2=Z2*eye(2,1)*ro2;
up3=Z3*eye(2,1)*ro3;

rp1=[px;py]+R*up1;
rp2=[px;py]+R*up2;
rp3=[px;py]+R*up3;
%--------------------------------------------------------------------------
rb1=Z1*eye(2,1)*b;
rb2=Z2*eye(2,1)*b;
rb3=Z3*eye(2,1)*b;
%--------------------------------------------------------------------------
d1=norm(rp1-rb1); s1=(rp1-rb1)/d1;
d2=norm(rp2-rb2); s2=(rp2-rb2)/d2;
d3=norm(rp3-rb3); s3=(rp3-rb3)/d3;

teta1=atan2(s1(2),s1(1));
teta2=atan2(s2(2),s2(1));
teta3=atan2(s3(2),s3(1));

s1_tilde=[-sin(teta1) cos(teta1)];
s2_tilde=[-sin(teta2) cos(teta2)];
s3_tilde=[-sin(teta3) cos(teta3)];

a1=-R*up1*q_1dot(3,k)^2+2*E*R*Z1*eye(2,1)*q_1dot(3,k)*q_1dot(4,k);
a2=-R*up2*q_1dot(3,k)^2+2*E*R*Z2*eye(2,1)*q_1dot(3,k)*q_1dot(5,k);
a3=-R*up3*q_1dot(3,k)^2+2*E*R*Z3*eye(2,1)*q_1dot(3,k)*q_1dot(6,k);
%--------------------------------------------------------------------------
M1=[m*eye(2) zeros(2,1); zeros(1,2) J]+...
    mp*[eye(2) E*R*up1; up1'*R'*E' up1'*up1]+...
    mp*[eye(2) E*R*up2; up2'*R'*E' up2'*up2]+...
    mp*[eye(2) E*R*up3; up3'*R'*E' up3'*up3];

M2=mp*[R*Z1*eye(2,1)        ,R*Z2*eye(2,1)            ,R*Z3*eye(2,1);...
    up1'*R'*E'*R*Z1*eye(2,1) ,up2'*R'*E'*R*Z2*eye(2,1) ,up3'*R'*E'*R*Z3*eye(2,1)];

M3=mp*[eye(1,2)*Z1'*R' ,eye(1,2)*Z1'*R'*E*R*up1;...
    eye(1,2)*Z2'*R' ,eye(1,2)*Z2'*R'*E*R*up2;...
    eye(1,2)*Z3'*R' ,eye(1,2)*Z3'*R'*E*R*up3];

M4=mp*eye(3);

M=[M1 ,M2 ;M3 ,M4];
%--------------------------------------------------------------------------
G1=mp*[eye(2);up1'*R'*E']*a1+[eye(2);up2'*R'*E']*a2+[eye(2);up3'*R'*E']*a3;
G2=mp*[eye(1,2)*Z1'*R'*a1;eye(1,2)*Z2'*R'*a2;eye(1,2)*Z3'*R'*a3];

G=[G1;G2];
%--------------------------------------------------------------------------
P=[s1                 ,s2                 ,s3                 ,s1_tilde'/d1                  ,s2_tilde'/d2                  ,s3_tilde'/d3                 ;...
    up1'*R'*E'*s1      ,up2'*R'*E'*s2      ,up3'*R'*E'*s3      ,up1'*R'*E'*s1_tilde'/d1       ,up2'*R'*E'*s2_tilde'/d2       ,up3'*R'*E'*s3_tilde'/d3     ;...
    eye(1,2)*Z1'*R'*s1 ,0                  ,0                  ,eye(1,2)*Z1'*R'*s1_tilde'/d1  ,0                             ,0                           ;...
    0                  ,eye(1,2)*Z2'*R'*s2 ,0                  ,0                             ,eye(1,2)*Z2'*R'*s2_tilde'/d2  ,0                           ;...
    0                  ,0                  ,eye(1,2)*Z3'*R'*s3 ,0                             ,0                             ,eye(1,2)*Z3'*R'*s3_tilde'/d3];
%--------------------------------------------------------------------------
alpha1=s1'*R*Z1*eye(2,1);
alpha2=s2'*R*Z2*eye(2,1);
alpha3=s3'*R*Z3*eye(2,1);
beta1=s1_tilde*R*Z1*eye(2,1);
beta2=s2_tilde*R*Z2*eye(2,1);
beta3=s3_tilde*R*Z3*eye(2,1);
Jx(1,:)=(s1'/alpha1-s1_tilde/beta1)*[eye(2) E*R*up1];
Jx(2,:)=(s2'/alpha2-s2_tilde/beta2)*[eye(2) E*R*up2];
Jx(3,:)=(s3'/alpha3-s3_tilde/beta3)*[eye(2) E*R*up3];
fval=1/cond(Jx);
%--------------------------------------------------------------------------