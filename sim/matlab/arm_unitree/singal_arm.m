theta_singal = [0.5,0.7, 1.0, 1, -1];
q0 = [0,-1,0,0,0];
T05 = fk_arm(theta_singal);
% % === 位置 ===
pos = T05(1:3, 4);

% === 姿态（旋转矩阵） ===
R = T05(1:3, 1:3);

% === 欧拉角（ZYX：yaw-pitch-roll）===
eul = rotm2eul_zyx(R);
disp('末端位置 [x y z] (m):');
disp(pos.');

disp('末端姿态 - 旋转矩阵 R:');
disp(R);

disp('末端姿态 - 欧拉角 ZYX (rad):');
disp(eul);
% 逆运动学求解
q_sol = ik_arm_iterative(T05, q0);
T05_sol = fk_arm(q_sol);
disp('逆运动学解:');
disp(q_sol);
disp(T05);
disp(T05_sol);

%% ********DH参数法定义机械臂********
   
L1 = 0.038;   
L2 = 0.1032;  
L3 = 0.0805;
L4 = 0.01;
% D-H参数表
theta(1) =0.5;       D1 = 0;    A1 =0;           alpha1 =pi/2; 
theta(2) =0.7;       D2 = -L1;     A2 =0;          alpha2 =-pi/2;     
theta(3) =1.0;        D3 = L2;    A3 =0;          alpha3 =pi/2;     
theta(4) =1.0;       D4 = 0;     A4 =L3;         alpha4 =0;  
theta(5) =-1.0;      D5 = 0;     A5 =L4;         alpha5 =0; 

% DH法建立模型,关节转角，关节距离，连杆长度，连杆转角，modified
L(1) = Link([theta(1), D1, A1, alpha1], 'standard');
L(2) = Link([theta(2), D2, A2, alpha2], 'standard');
L(3) = Link([theta(3), D3, A3, alpha3], 'standard');
L(4) = Link([theta(4), D4, A4, alpha4], 'standard');
L(5) = Link([theta(5), D5, A5, alpha5], 'standard');


% 关节角度限幅——最大值与最小值
theta1min = -360;  theta1max = 360;
theta2min = -360;  theta2max = 360;
theta3min = -360;  theta3max = 360;
theta4min = -360;  theta4max = 360;
theta5min = -360;  theta5max = 360;

% 定义关节范围
L(1).qlim =[theta1min*deg2rad, theta1max*deg2rad];
L(2).qlim =[theta2min*deg2rad, theta2max*deg2rad];
L(3).qlim =[theta3min*deg2rad, theta3max*deg2rad];
L(4).qlim =[theta4min*deg2rad, theta4max*deg2rad];
L(5).qlim =[theta5min*deg2rad, theta5max*deg2rad];


% 生成机械臂
RoboArm_UR5 = SerialLink(L(1:5),'name','Ur5');

%正运动学解算
Ur5_T=RoboArm_UR5.fkine(theta(1:5));
%逆运动学解算
Ur5_Q=RoboArm_UR5.ikunc(Ur5_T);
disp(Ur5_Q);