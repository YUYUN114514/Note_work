% 力臂法重力补偿计算 MATLAB 文件
clear; clc;

% 1. 定义符号变量：直接定义 theta 为关节变量
syms theta1 theta2 theta3 theta4 theta5 theta6 real
theta = [theta1; theta2; theta3; theta4; theta5; theta6]; 

syms g real

% 2. DH 参数
A = [0 0 194 26 0 0];          % 连杆长度
alpha = [0 -pi/2 0 pi/2 -pi/2 -pi/2];  % 连杆扭转角
d = [0 0 4.4 118 0 0];         % 连杆偏移量

% 注意：我们将 theta0 (初始偏移) 移到数值计算阶段，不放在符号定义中
% 这样 jacobian 才能正常工作

g = 9.8;

% 3. DH 变换矩阵函数
DH = @(a, alpha, d, q)[
    cos(q), -sin(q), 0, a;
    sin(q)*cos(alpha), cos(q)*cos(alpha), -sin(alpha), -d*sin(alpha);
    sin(q)*sin(alpha), cos(q)*sin(alpha), cos(alpha), d*cos(alpha);
    0, 0, 0, 1
];

% 4. 计算各关节的变换矩阵
T = sym(zeros(4, 4, 6));
T(:,:,1) = DH(A(1), alpha(1), d(1), theta(1));
for i = 2:6
    T(:,:,i) = T(:,:,i-1) * DH(A(i), alpha(i), d(i), theta(i));
end

% 5. 连杆的质量
m = [5, 4, 3, 2, 1, 0.5]; 

% 6. 各连杆的质心位置
Pc = [
    0 0 0.1 1; 
    0 0 0.1 1; 
    0 0 0.1 1; 
    0 0 0.05 1; 
    0 0 0.05 1; 
    0 0 0.02 1; 
]';

% 7. 计算重力势能
U = 0;
for i = 1:6
    P0 = T(:,:,i) * Pc(:,i);   % 质心的世界坐标
    zi = P0(3);                % 取z坐标
    U = U + m(i) * g * zi;     % 累加势能
end

% 8. 求解重力补偿力矩
% === 修复点：现在 theta 是纯变量向量，jacobian 可以正常运行 ===
tau_g = jacobian(U, theta).';  % 注意：结果通常是行向量，建议转置为列向量以符合力矩习惯
% 或者保留你的写法: tau_g = jacobian(U, theta); 视后续使用习惯而定

disp('关节的重力补偿力矩表达式计算完成。');

% 9. 数值替换
% 准备数值：
theta0_val = [pi/2; -pi/2; pi; pi/2; pi; -pi/2]; % 初始位置数值
dtheta_val = [pi/4; pi/6; pi/3; pi/2; pi/3; pi/4]; % 你的测试增量

% 实际用于计算的关节角 = 初始 + 增量
current_theta_vals = theta0_val + dtheta_val;

% 代入数值
tau_num = subs(tau_g, theta.', current_theta_vals.'); % 将 theta 符号替换为实际数值

% 输出数值结果
disp('数值化后的关节重力补偿力矩：');
disp(double(tau_num)); % 转换为 double 类型以便阅读