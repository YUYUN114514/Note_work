% %% ********DH参数法定义机械臂********
% RightArm = build_single_arm();
% LeftArm  = build_single_arm();
% 
% % torso 坐标系下的肩部基座
% R_base_rot = trotx(-pi/2);   % 把 z 轴“放倒”
% RightArm.base = transl(0, -0.20, 0.25) * R_base_rot;
% LeftArm.base  = transl(0, +0.20, 0.25) * R_base_rot;
% 
% qR = [1.57, -1.1, 1.8, -2.5, -1.57];
% qL = [-1.57, 1.1, -1.8, 2.5, 1.57];
% 
% figure; hold on; grid on; view(3);
% 
% RightArm.plot(qR, ...
%     'workspace',[-0.6 0.6 -0.6 0.6 -0.1 1.0], ...
%     'scale',0.6, ...
%     'trail','r');
% 
% LeftArm.plot(qL, ...
%     'workspace',[-0.6 0.6 -0.6 0.6 -0.1 1.0], ...
%     'scale',0.6, ...
%     'trail','b');
% 
% title('双臂机械臂 DH 模型（URDF 一致）');
% 
% %正运动学解算
% T_R = RightArm.fkine(qR);
% T_L = LeftArm.fkine(qL);
% 
% %逆运动学解算
% qR_ik = RightArm.ikunc(T_R);
% qL_ik = LeftArm.ikunc(T_L);
% 
% RightArm.teach(qR);
% LeftArm.teach(qL);
% % % clear; clc; close all;
% % % 
% % % % ===== DH =====
L(1) = Link([0 0 0  pi/2], 'standard');
L(2) = Link([0 0 0 -pi/2], 'standard');
L(3) = Link([0 0 0.1032  pi/2], 'standard');
L(4) = Link([0 0 0.0805 0], 'standard');
L(5) = Link([0 0 0.01   0], 'standard');

RightArm = SerialLink(L, 'name', 'RightArm');
LeftArm  = SerialLink(L, 'name', 'LeftArm');
% % % 
% % % % ===== 基座 =====
% % % Rfix = trotx(-pi/2);
% % % RightArm.base = transl(0, -0.25, 0.3) * Rfix;
% % % LeftArm.base  = transl(0, +0.25, 0.3) * Rfix;
% % % 
% % % % ===== 初始角 =====
% % % qR = zeros(1,5);
% % % qL = zeros(1,5);
% % % 
% % % % ===== 只 plot 一次 =====
% % % figure;
% % % RightArm.plot(qR, 'workspace', [-1 1 -1 1 -0.2 1], 'delay', 0);
% % % LeftArm.plot(qL,  'workspace', [-1 1 -1 1 -0.2 1], 'delay', 0);
% % % 
% % % view(3);
% % % axis equal;

shoulder_dist = 0.20;  % 两肩间距（按 URDF 实际改）

LeftArm.base  = transl(0,  shoulder_dist/2, 0);
RightArm.base = transl(0, -shoulder_dist/2, 0);

qL = zeros(1,5);
qR = zeros(1,5);

figure
LeftArm.plot(qL);     % 第一次创建场景
RightArm.plot(qR);    % 会自动叠加（同一个 RTB 场景）

