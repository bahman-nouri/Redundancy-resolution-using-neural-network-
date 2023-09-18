%--------------------------------------------------------------------------
clc;clear all;
%--------------------------------------------------------------------------
global px py teta f1 f2
%--------------------------------------------------------------------------
teta=30*pi/180;
%--------------------------------------------------------------------------
q_max=0.4;q_min=0.3;
%q_max=0.3;q_min=0.3;
x0=[0.31 0.3 0.33];
for i=1:3
    A(2*i-1,i)=+1;
    A(2*i  ,i)=-1;
end

for i=1:3
    B(2*i-1,1)=+q_max;
    B(2*i  ,1)=-q_min;
end
%--------------------------------------------------------------------------
i=0; j=0;
for px=-.1:.02:.1
    i=i+1;
    for py=-.1:.02:.1
        j=j+1;
        [x,fval]=fmincon(@Performance,x0,A,B,[],[],[],[]);
        X(i,j)=px;
        Y(i,j)=py;
        Fval1(i,j)=f1;
        Fval2(i,j)=f2;
        X1(i,j)=x(1);
        X2(i,j)=x(2);
        X3(i,j)=x(3);
    end
    j=0;
end
%--------------------------------------------------------------------------
[m,n]=size(X);
k=0;
for i=1:n
    for j=1:n
        k=k+1;
        input(:,k)=[X(i,j);Y(i,j)];
        output(:,k)=[X1(i,j);X2(i,j);X3(i,j)];
    end
    j=0;
end
%--------------------------------------------------------------------------
filename = 'Input.xlsx';
xlswrite(filename,input);

filename = 'Output.xlsx';
xlswrite(filename,output);
%--------------------------------------------------------------------------
subplot(1,2,2)

set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 13, 10])
[c,h]=contour(X,Y,Fval1);
clabel(c,h);
colorbar;
h=findobj('Type','patch');
set(h,'LineWidth',2);
%title('Reciprocal of condition number of forward jacobian matrix' ,'FontSize',12,'FontName','Times New Roman')
title('\theta=\pi/6\circ (Redundant)' ,'FontSize',12,'FontName','Times New Roman')
xlabel('x (m)','FontSize',12,'FontName','Times New Roman');
ylabel('y (m)','FontSize',12,'FontName','Times New Roman')
set(gca,'fontsize',12)
set(0, 'DefaultAxesFontWeight', 'normal', ...
    'DefaultAxesFontWeight', 'normal', ... % Not sure the difference here
    'DefaultAxesTitleFontWeight', 'normal') ;
%--------------------------------------------------------------------------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 13, 10])
[c,h]=contour(X,Y,Fval2);
clabel(c,h);
colorbar;
h=findobj('Type','patch');
set(h,'LineWidth',2);
title('\theta=\pi/6\circ (Redundant)' ,'FontSize',12,'FontName','Times New Roman')
%title('Redundant  \theta=0\circ' ,'FontSize',12,'FontName','Times New Roman')
xlabel('x (m)','FontSize',12,'FontName','Times New Roman');
ylabel('y (m)','FontSize',12,'FontName','Times New Roman')
set(gca,'fontsize',12)
set(0, 'DefaultAxesFontWeight', 'normal', ...
    'DefaultAxesFontWeight', 'normal', ... % Not sure the difference here
    'DefaultAxesTitleFontWeight', 'normal') ;
%--------------------------------------------------------------------------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 13, 10])
[c,h]=contourf(X,Y,X1);
%clabel(c,h);
meshz(X,Y,X1);
colorbar;
h=findobj('Type','patch');
set(h,'LineWidth',2);
title('Length of the passive prismatic joint 1','FontSize',12,'FontName','Times New Roman')
xlabel('x (m)','FontSize',12,'FontName','Times New Roman');
ylabel('y (m)','FontSize',12,'FontName','Times New Roman');
zlabel('\rho_{1}(m)','FontSize',12,'FontName','Times New Roman');
set(gca,'fontsize',12)
ax.FontWeight = 'normal';
set(0, 'DefaultAxesFontWeight', 'normal', ...
    'DefaultAxesFontWeight', 'normal', ... % Not sure the difference here
    'DefaultAxesTitleFontWeight', 'normal') ;
%--------------------------------------------------------------------------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 13, 10])
[c,h]=contourf(X,Y,X2);
%clabel(c,h);
meshz(X,Y,X2);
colorbar;
h=findobj('Type','patch');
set(h,'LineWidth',2);
title('Length of the passive prismatic joint 2','FontSize',12,'FontName','Times New Roman')
xlabel('x (m)','FontSize',12,'FontName','Times New Roman');
ylabel('y (m)','FontSize',12,'FontName','Times New Roman')
zlabel('\rho_{2}(m)','FontSize',12,'FontName','Times New Roman');
set(gca,'fontsize',12)
set(0, 'DefaultAxesFontWeight', 'normal', ...
    'DefaultAxesFontWeight', 'normal', ... % Not sure the difference here
    'DefaultAxesTitleFontWeight', 'normal') ;
%--------------------------------------------------------------------------
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 13, 10])
[c,h]=contourf(X,Y,X3);
%clabel(c,h);
meshz(X,Y,X3);
colorbar;
h=findobj('Type','patch');
set(h,'LineWidth',2);
title('Length of the passive prismatic joint 3','FontSize',12,'FontName','Times New Roman')
xlabel('x (m)','FontSize',12,'FontName','Times New Roman');
ylabel('y (m)','FontSize',12,'FontName','Times New Roman');
zlabel('\rho_{3}(m)','FontSize',12,'FontName','Times New Roman');
set(gca,'fontsize',12)
set(0, 'DefaultAxesFontWeight', 'normal', ...
    'DefaultAxesFontWeight', 'normal', ... % Not sure the difference here
    'DefaultAxesTitleFontWeight', 'normal') ;
%--------------------------------------------------------------------------