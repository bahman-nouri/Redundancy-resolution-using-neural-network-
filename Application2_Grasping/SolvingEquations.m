%--------------------------------------------------------------------------
function [q,q_1dot]=SolvingEquations(M,G,P,Q,f_ext,u,k,dt,q,q_1dot)
%--------------------------------------------------------------------------
Xn=[q(:,k);q_1dot(:,k)];

A=[zeros(6) eye(6);zeros(6) zeros(6)];
B=[zeros(6,1);inv(M)*(P*u+Q*f_ext-G)];

f1=dt*(A*Xn+B);
f2=dt*(A*(Xn+1/2*f1)+B);
f3=dt*(A*(Xn+1/2*f2)+B);
f4=dt*(A*(Xn+f3)+B);

Xn=Xn+(f1+2*f2+2*f3+f4)/6;

q(:,k+1)=Xn(1:6);
q_1dot(:,k+1)=Xn(7:12);
%----------------------------------------------------------------------