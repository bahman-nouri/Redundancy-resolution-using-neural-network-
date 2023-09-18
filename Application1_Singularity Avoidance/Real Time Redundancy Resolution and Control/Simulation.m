%--------------------------------------------------------------------------
clc;clear all;
%--------------------------------------------------------------------------
global b J m mp
%--------------------------------------------------------------------------
path = 'D:\Projects\Kinematically Redundant\7.1.2021\Application1_Singularity Avoidance';
filename1 = 'Input.xlsx';
fullpath = [path, '\', filename1];
input = xlsread(fullpath);

filename2='Output.xlsx';
fullpath = [path, '\', filename2];
output=xlsread(fullpath);
%--------------------------------------------------------------------------
net = newff(input,output,[2 10 3]);
Y = sim(net,input);
net.trainParam.epochs = 120;
net = train(net,input,output);
%--------------------------------------------------------------------------
b=.6;
J=.1;
m=.5;
mp=.1;
%--------------------------------------------------------------------------
tf=4;
k=0;
w=2*pi/4;
dt=0.005;
%--------------------------------------------------------------------------
U(:,3)=[0;0;0;0;0;0];
k=0;
for t=0:dt:2*dt
    k=k+1;
    T(k)=t;
    %----------------------------------------------------------------------
    P_des(:,k)     =[.1*sin(w*t);.1*cos(w*t);30*pi/180];
    P_1dot_des(:,k)=[.1*w*cos(w*t);-.1*w*sin(w*t);0];
    P_2dot_des(:,k)=[-.1*w^2*sin(w*t);-.1*w^2*cos(w*t);0];
    
    L_des(:,k)=sim(net,[P_des(1,k);P_des(2,k)]);
    q(:,k)=[P_des(:,k);L_des(:,k)];
    if t>=dt
        L_1dot_des(:,k)=(L_des(:,k)-L_des(:,k-1))/dt;
        q_1dot(:,3)=[P_1dot_des(:,k);L_1dot_des(:,k)];
    end
    if t>=2*dt
        L_2dot_des(:,k)=(L_1dot_des(:,k)-L_1dot_des(:,k-1))/dt;
    end
end

%--------------------------------------------------------------------------
for t=2*dt:dt:tf

    T(k)=t;
    %----------------------------------------------------------------------
    P_des(:,k)     =[.1*sin(w*t);.1*cos(w*t);30*pi/180];
    P_1dot_des(:,k)=[.1*w*cos(w*t);-.1*w*sin(w*t);0];
    P_2dot_des(:,k)=[-.1*w^2*sin(w*t);-.1*w^2*cos(w*t);0];
    
    L_des(:,k)=sim(net,[P_des(1,k);P_des(2,k)]);
    L_1dot_des(:,k)=(L_des(:,k)-L_des(:,k-1))/dt;
    L_2dot_des(:,k)=(L_1dot_des(:,k)-L_1dot_des(:,k-1))/dt;
     
    %----------------------------------------------------------------------
    [M,G,P,fval]=Mechanism(q,q_1dot,k);
    [U]=OptimalControl(M,G,P,k,P_2dot_des,P_1dot_des,P_des,L_2dot_des,L_1dot_des,L_des,q_1dot,q,U);
    [q,q_1dot]=SolvingEquations(M,G,P,U,k,dt,q,q_1dot);
    Norm_error_position(k)=norm(P_des(:,k)-q(1:3,k));
    cond_p(k)=fval;
    k=k+1;
end
%--------------------------------------------------------------------------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 24, 14])
plot(T,Norm_error_position,'LineWidth',2);hold on;grid on
%plot(T,P_des-q(1:3,2:end),'LineWidth',2);hold on;grid on
xlabel('Time(s)','FontSize',14,'FontName','Times New Roman');
ylabel('Norm of position error','FontSize',14,'FontName','Times New Roman')
set(gca,'fontsize',14)
% %--------------------------------------------------------------------------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 24, 14])

plot(T(:,3:end),L_des(1,3:end),'b- ','LineWidth',2);hold on;grid on
plot(T(:,3:end),L_des(2,3:end),'r-- ','LineWidth',2);hold on;grid on
plot(T(:,3:end),L_des(3,3:end),'k: ','LineWidth',2);hold on;grid on
% plot(T(:,3:end),L_1dot_des(:,3:end),'b- ','LineWidth',2);hold on;grid on
% plot(T(:,3:end),L_2dot_des(:,3:end),'b- ','LineWidth',2);hold on;grid on

legend('joint 1','joint 2','joint 3');
xlabel('Time(s)','FontSize',14,'FontName','Times New Roman');
ylabel('Length of passive prismatic joints (m)','FontSize',14,'FontName','Times New Roman')
set(gca,'fontsize',14)
%--------------------------------------------------------------------------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 24, 14])

plot(T(4:end),U(1,4:end-1),'b- ','LineWidth',2);hold on;grid on
plot(T(4:end),U(2,4:end-1),'r-- ','LineWidth',2);hold on;grid on
plot(T(4:end),U(3,4:end-1),'k:','LineWidth',2);hold on;grid on

legend('Actuator1','Actuator2','Actuator3');
xlabel('Time(s)','FontSize',14,'FontName','Times New Roman');
ylabel('Force in prismatic actuators (N)','FontSize',14,'FontName','Times New Roman');
set(gca,'fontsize',14)
%--------------------------------------------------------------------------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 24, 14])

plot(T(4:end),U(4,4:end-1),'b-','LineWidth',2);hold on;grid on
plot(T(4:end),U(5,4:end-1),'r-- ','LineWidth',2);hold on;grid on
plot(T(4:end),U(6,4:end-1),'k: ','LineWidth',2);hold on;grid on

legend('Actuator1','Actuator2','Actuator3');
xlabel('Time(s)','FontSize',14,'FontName','Times New Roman');
ylabel('Moment in revolute actuators (N.m)','FontSize',14,'FontName','Times New Roman');
set(gca,'fontsize',14)
%--------------------------------------------------------------------------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 24, 14])

plot(T(3:end),cond_p(3:end),'LineWidth',2);hold on;grid on

xlabel('Time(s)','FontSize',14,'FontName','Times New Roman');
ylabel('Reciprocaocal of the condition number of Jx','FontSize',14,'FontName','Times New Roman')
set(gca,'fontsize',14)
ax.GridColor = [0 0 0];
ax.GridLineStyle = '--';
ax.GridAlpha =.9;
ax.Layer = 'top';
%--------------------------------------------------------------------------