function [U]=OptimalControl(M,G,P,k,P_2dot_des,P_1dot_des,P_des,L_2dot_des,L_1dot_des,L_des,q_1dot,q,U)
%--------------------------------------------------------------------------
Kd=20*eye(6);
Kp=20*eye(6);

V=[P_2dot_des(:,k);L_2dot_des(:,k)]+Kd*([P_1dot_des(:,k);L_1dot_des(:,k)]-q_1dot(:,k))+...
    Kp*([P_des(:,k);L_des(:,k)]-q(:,k));
U(:,k+1)=inv(P)*(M*V+G);
%--------------------------------------------------------------------------

