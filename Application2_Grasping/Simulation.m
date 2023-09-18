%--------------------------------------------------------------------------
clc;clear all;
%--------------------------------------------------------------------------
global b J m mp
%--------------------------------------------------------------------------
b=.6;
J=.1;
m=.5;
mp=.1;
f_ext=[0;0;0];
%--------------------------------------------------------------------------
tf=4;
k=0;
w=2*pi/4;
dt=0.005;
%--------------------------------------------------------------------------
q=[0;0.1;30*pi/180;0.1;0.1;0.1];
q_1dot=[0.1*w;0;0;0.001;0.001;0.001];

%--------------------------------------------------------------------------
for t=0:dt:tf
    k=k+1;
    T(k)=t;

        P_des(:,k)=[.1*sin(w*t); .1*cos(w*t);30*pi/180; .1;.1;.1];
        P_des_1dot(:,k)=[.1*w*cos(w*t); -.1*w*sin(w*t);0; 0;0;0];
        P_des_2dot(:,k)=[-.1*w^2*sin(w*t); -.1*w^2*cos(w*t);0;0;0;0];

    [M,G,P,Q,fval]=Mechanism(q,q_1dot,k);
    
    [u]=OptimalControl(M,G,P,Q,f_ext,k,P_des_2dot,P_des_1dot,P_des,q_1dot,q);
    [q,q_1dot]=SolvingEquations(M,G,P,Q,f_ext,u,k,dt,q,q_1dot);
    Norm_error_position1(k)=norm(P_des(1:3,k)-q(1:3,k));
    Norm_error_position2(k)=norm(P_des(4:6,k)-q(4:6,k));
    cond_P(k)=fval;
    U(:,k)=u;
end
%--------------------------------------------------------------------------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 24, 14])
plot(T,Norm_error_position1,'b- ','LineWidth',2);hold on;grid on
plot(T,Norm_error_position2,'r--','LineWidth',2);hold on;grid on

legend('Moving platform','Passive prismatic joints');
xlabel('Time(s)','FontSize',14,'FontName','Times New Roman');
ylabel('Two-norm of the position error','FontSize',14,'FontName','Times New Roman')
set(gca,'fontsize',14)
%--------------------------------------------------------------------------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 24, 14])

plot(T,U(1,:),'b- ','LineWidth',2);hold on;grid on
plot(T,U(2,:),'r-- ','LineWidth',2);hold on;grid on
plot(T,U(3,:),'k:','LineWidth',2);hold on;grid on

legend('Actuator1','Actuator2','Actuator3');
xlabel('Time(s)','FontSize',14,'FontName','Times New Roman');
ylabel('Force in prismatic actuators (N)','FontSize',14,'FontName','Times New Roman');
set(gca,'fontsize',14)
%--------------------------------------------------------------------------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 24, 14])

plot(T,U(4,:),'b-','LineWidth',2);hold on;grid on
plot(T,U(5,:),'r-- ','LineWidth',2);hold on;grid on
plot(T,U(6,:),'k: ','LineWidth',2);hold on;grid on

legend('Actuator1','Actuator2','Actuator3');
xlabel('Time(s)','FontSize',14,'FontName','Times New Roman');
ylabel('Moment in revolute actuators (N.m)','FontSize',14,'FontName','Times New Roman');
set(gca,'fontsize',14)
%----------------------------------------------------------------- ---------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 24, 14])

plot(T,cond_P,'LineWidth',2);hold on;grid on

xlabel('Time(s)','FontSize',14,'FontName','Times New Roman');
ylabel('Reciprocaocal of the condition number of P','FontSize',14,'FontName','Times New Roman')
set(gca,'fontsize',14)
ax.GridColor = [0 0 0];
ax.GridLineStyle = '--';
ax.GridAlpha =.9;
ax.Layer = 'top';
%--------------------------------------------------------------------------