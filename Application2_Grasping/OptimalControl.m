function [U]=OptimalControl(M,G,P,Q,f_ext,k,P_des_2dot,P_des_1dot,P_des,q_1dot,q)
%--------------------------------------------------------------------------
Kd=20*eye(6);
Kp=20*eye(6);

V=P_des_2dot(:,k)+Kd*(P_des_1dot(:,k)-q_1dot(:,k))+Kp*(P_des(:,k)-q(:,k));
U=inv(P)*(M*V+G-Q*f_ext);
%--------------------------------------------------------------------------

