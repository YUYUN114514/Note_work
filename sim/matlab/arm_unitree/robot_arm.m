% clc;
% clear;

% % 转换为 LaTeX 格式
% latex_T = latex(T);

deg2rad=pi/180;  %转化为角度制
rad2deg=180/pi;  %转化为弧度制

%% ********DH参数法定义机械臂********
   
% L1 = 0.038;   
% L2 = 0.1032;  
% L3 = 0.0805;
% L4 = 0.1;
% % D-H参数表
% theta(1) =0;       D1 = 0;    A1 =0;           alpha1 =pi/2; 
% theta(2) =1.81;       D2 = 0;     A2 =0;          alpha2 =-pi/2;     
% theta(3) =0;        D3 = L2;    A3 =0;          alpha3 =pi/2;     
% theta(4) =-3.14;       D4 = 0;     A4 =L3;         alpha4 =0;  
% theta(5) =-1.81;      D5 = 0;     A5 =L4;         alpha5 =0; 
%% ********DH参数法定义机械臂********
   
L1 = 0.038;   
L2 = 0.1032;  
L3 = 0.0805;
L4 = 0.01;
% D-H参数表
theta(1) =0;       D1 = 0;    A1 =0;           alpha1 =pi/2; 
theta(2) =-pi;       D2 = -L1;     A2 =0;          alpha2 =-pi/2;     
theta(3) =0;        D3 = L2;    A3 =0;          alpha3 =pi/2;     
theta(4) =0;       D4 = 0;     A4 =L3;         alpha4 =0;  
theta(5) =0;      D5 = 0;     A5 =L4;         alpha5 =0; 
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

% % 关节角度限幅——最大值与最小值
% theta1min = -3.08;  theta1max = 2.67;
% theta2min = -2.25;  theta2max = 1.58;
% theta3min = -2.61;  theta3max = 2.61;
% theta4min = -1.04;  theta4max = 2.09;
% theta5min = -1.97;  theta5max = 1.97;

% 定义关节范围
L(1).qlim =[theta1min, theta1max];
L(2).qlim =[theta2min, theta2max];
L(3).qlim =[theta3min, theta3max];
L(4).qlim =[theta4min, theta4max];
L(5).qlim =[theta5min, theta5max];

% 生成机械臂
RoboArm_UR5 = SerialLink(L(1:5),'name','Ur5');

%正运动学解算
Ur5_T=RoboArm_UR5.fkine(theta(1:5));
%逆运动学解算
Ur5_Q=RoboArm_UR5.ikunc(Ur5_T);

% % 加入teach指令，则可调整各个关节角度
figure
RoboArm_UR5.plot(theta(1:5),'scale',0.6,'trail','r','workspace',[-0.2,0.2,-0.7,0.1,-0.2,0.6]);
RoboArm_UR5.teach(theta(1:5));
title('五轴机械臂模型');