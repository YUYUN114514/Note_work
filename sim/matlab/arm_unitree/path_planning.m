% % ------------------ 关节轨迹规划示例 ------------------
clc; clear;
%% ********DH参数法定义机械臂********
deg2rad=pi/180;  %转化为角度制
rad2deg=180/pi;  %转化为弧度制
L1 = 0.038;   
L2 = 0.1032;  
L_off = 0.01578; % URDF中的横向偏置
L3 = 0.0805;
L4 = 0.01;

theta(1) =0;       D1 = 0;    A1 =0;           alpha1 =pi/2; 
theta(2) =-pi;       D2 = -L1;     A2 =0;          alpha2 =-pi/2;     
theta(3) =0;        D3 = L2;    A3 =L_off;          alpha3 =pi/2;     
theta(4) =0;       D4 = 0;     A4 =L3;         alpha4 =0;  
theta(5) =0;      D5 = 0;     A5 =L4;         alpha5 =0; 
% DH法建立模型,关节转角，关节距离，连杆长度，连杆转角，modified
L(1) = Link([theta(1), D1, A1, alpha1], 'standard');
L(2) = Link([theta(2), D2, A2, alpha2], 'standard');
L(3) = Link([theta(3), D3, A3, alpha3], 'standard');
L(4) = Link([theta(4), D4, A4, alpha4], 'standard');
L(5) = Link([theta(5), D5, A5, alpha5], 'standard');


% % 关节角度限幅——最大值与最小值
% theta1min = -3.08;  theta1max = 2.67;
% theta2min = -2.25;  theta2max = 1.58;
% theta3min = -2.61;  theta3max = 2.61;
% theta4min = -1.04;  theta4max = 2.09;
% theta5min = -1.97;  theta5max = 1.97;
% 
% % 定义关节范围
% L(1).qlim =[theta1min, theta1max];
% L(2).qlim =[theta2min, theta2max];
% L(3).qlim =[theta3min, theta3max];
% L(4).qlim =[theta4min, theta4max];
% L(5).qlim =[theta5min, theta5max];

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

% 初始关节角 q0 和目标关节角 qf
q0 = [0,-pi, 0, 0, -0];   % 初始角度（弧度）
qf = [-0.3,-2.7 0.3,0.4,-0.5];
% qf_pos = [-0.0812, -0.0213,0.1549,1.6143,-0.3555,0.9542]; % 目标位置和姿态
% qf_T05 = position_to_T05(qf_pos(1:3),qf_pos(4:6));%目标位置的转换矩阵
% % % === 位置 ===
% pos = qf_T05(1:3, 4);
% 
% % === 姿态（旋转矩阵） ===
% R = qf_T05(1:3, 1:3);
% 
% % === 欧拉角（ZYX：yaw-pitch-roll）===
% eul = rotm2eul_zyx(R);
% disp('末端位置 [x y z] (m):');
% disp(pos.');
% 
% disp('末端姿态 - 旋转矩阵 R:');
% disp(R);
% 
% disp('末端姿态 - 欧拉角 ZYX (rad):');
% disp(eul);
% qf = ik_arm_iterative(qf_T05, q0);

% 轨迹参数
T_total = 5;       % 总时间 (s)
dt = 0.05;         % 时间步长
t = 0:dt:T_total;  % 时间向量
nSteps = length(t);
nJoints = length(q0);

% 关节空间轨迹（五次多项式插值）
q_traj = zeros(nJoints, nSteps);
qd_traj = zeros(nJoints, nSteps);
qdd_traj = zeros(nJoints, nSteps);

for i = 1:nJoints
    % 五次多项式系数计算
    % q(t) = a0 + a1*t + a2*t^2 + a3*t^3 + a4*t^4 + a5*t^5
    % 约束: q(0)=q0, q(T)=qf, qd(0)=qd(T)=0, qdd(0)=qdd(T)=0
    M = [ 1, 0, 0,   0,    0,     0;
          0, 1, 0,   0,    0,     0;
          0, 0, 2,   0,    0,     0;
          1, T_total, T_total^2, T_total^3, T_total^4, T_total^5;
          0, 1, 2*T_total, 3*T_total^2, 4*T_total^3, 5*T_total^4;
          0, 0, 2, 6*T_total, 12*T_total^2, 20*T_total^3 ];

    b = [q0(i); 0; 0; qf(i); 0; 0]; % 边界条件
    a = M\b; % 多项式系数

    for k = 1:nSteps
        tau = t(k);
        q_traj(i,k) = a(1) + a(2)*tau + a(3)*tau^2 + a(4)*tau^3 + a(5)*tau^4 + a(6)*tau^5;
        qd_traj(i,k) = a(2) + 2*a(3)*tau + 3*a(4)*tau^2 + 4*a(5)*tau^3 + 5*a(6)*tau^4;
        qdd_traj(i,k)= 2*a(3) + 6*a(4)*tau + 12*a(5)*tau^2 + 20*a(6)*tau^3;
    end
end
% 1. 获取基于 URDF 的右机械臂关节限位 
% 顺序：Shoulder Pitch, Roll, Yaw, Elbow, Wrist Roll
% limits = [
%     -3.0892, 2.6704;  % Right Shoulder Pitch [cite: 38, 47]
%     -2.2515, 1.5882;  % Right Shoulder Roll [cite: 48]
%     -2.6180, 2.6180;  % Right Shoulder Yaw [cite: 50]
%     -1.0472, 2.0944;  % Right Elbow [cite: 52]
%     -1.9722, 1.9722   % Right Wrist Roll [cite: 53]
% ];
% 
% % 初始关节角 q0 和通过 IK 获取的目标关节角 qf_raw
% q0 = [0; -1; 0; 0; 0];   
% qf_pos = [-0.0812, -0.0213,0.1549,1.6143,-0.3555,0.9542]; 
% qf_T05 = position_to_T05(qf_pos(1:3), qf_pos(4:6));
% qf_raw = ik_arm_iterative(qf_T05, q0); % 原始逆解结果
% 
% % 轨迹参数
% T_total = 5;       
% dt = 0.05;         
% t = 0:dt:T_total;  
% nSteps = length(t);
% nJoints = length(q0);
% 
% q_traj = zeros(nJoints, nSteps);
% qd_traj = zeros(nJoints, nSteps);
% qdd_traj = zeros(nJoints, nSteps);
% 
% for i = 1:nJoints
%     % --- 逻辑 A: 计算最短路径目标角 ---
%     % 计算从 q0 到 qf 的最小周期性差异 (范围在 -pi 到 pi)
%     diff = qf_raw(i) - q0(i);
%     diff_shortest = mod(diff + pi, 2*pi) - pi;
%     
%     qf_candidate = q0(i) + diff_shortest;
%     
%     % --- 逻辑 B: 结合 URDF 限位进行校验 ---
%     % 检查“捷径”目标是否在物理限位内 
%     if qf_candidate >= limits(i, 1) && qf_candidate <= limits(i, 2)
%         qf_final = qf_candidate;
%     else
%         % 如果最短路径越界，则回退到原始 qf 并进行硬限位截断 
%         qf_final = max(limits(i, 1), min(limits(i, 2), qf_raw(i)));
%     end
%     
%     % --- 逻辑 C: 五次多项式系数计算 ---
%     % 约束: q(0)=q0, q(T)=qf_final, qd(0)=qd(T)=0, qdd(0)=qdd(T)=0
%     M = [ 1, 0, 0,   0,    0,     0;
%           0, 1, 0,   0,    0,     0;
%           0, 0, 2,   0,    0,     0;
%           1, T_total, T_total^2, T_total^3, T_total^4, T_total^5;
%           0, 1, 2*T_total, 3*T_total^2, 4*T_total^3, 5*T_total^4;
%           0, 0, 2, 6*T_total, 12*T_total^2, 20*T_total^3 ];
%     
%     b = [q0(i); 0; 0; qf_final; 0; 0]; 
%     a = M\b; 
%     
%     for k = 1:nSteps
%         tau = t(k);
%         q_traj(i,k) = a(1) + a(2)*tau + a(3)*tau^2 + a(4)*tau^3 + a(5)*tau^4 + a(6)*tau^5;
%         qd_traj(i,k) = a(2) + 2*a(3)*tau + 3*a(4)*tau^2 + 4*a(5)*tau^3 + 5*a(6)*tau^4;
%         qdd_traj(i,k)= 2*a(3) + 6*a(4)*tau + 12*a(5)*tau^2 + 20*a(6)*tau^3;
%     end
% end
%% ------------------ 可视化关节角 ------------------
figure('Name','Joint Space Trajectory');
for i = 1:nJoints
    subplot(nJoints,1,i);
    plot(t, q_traj(i,:), 'LineWidth', 1.5);
    ylabel(['q', num2str(i),' (rad)']);
    if i==1
        title('关节空间轨迹规划（五次多项式）');
    end
    grid on;
end
xlabel('Time (s)');


%% ------------------ 机械臂轨迹动画（SerialLink.plot + 末端轨迹） ------------------
figure('Name','Arm Animation');
axis equal;
grid on;
view(45,30);
xlabel('X'); ylabel('Y'); zlabel('Z');
hold on;

workspace = [-0.2,0.2,-0.7,0.1,-0.2,0.6];
trail = []; % 累积末端轨迹

for k = 1:5:nSteps
    qk = q_traj(:,k)';  % 当前关节角度（行向量）
    
    % 绘制机械臂，不使用 'trail'
    RoboArm_UR5.plot(qk, 'scale', 0.6, 'workspace', workspace);

    % 获取末端位置
    T_end = RoboArm_UR5.fkine(qk);   % SE3 对象
    T_mat = T_end.T;                  % 转换为 4x4 齐次矩阵
    P_end = T_mat(1:3,4);             % 末端坐标

    % 累积末端轨迹
    trail = [trail, P_end];

    % 绘制红色末端轨迹
    hold on;
    plot3(trail(1,:), trail(2,:), trail(3,:), 'r', 'LineWidth', 2);

    pause(0.05);
end