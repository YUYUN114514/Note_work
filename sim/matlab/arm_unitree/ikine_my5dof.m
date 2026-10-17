function q = ikine_my5dof(T)
% 五自由度机械臂逆运动学
% 输入：
%   T - 4x4末端位姿矩阵
% 输出：
%   q - 5x1关节角向量 [q1;q2;q3;q4;q5]

%% DH参数
L1 = 0.1032;
L2 = 0.0805;
L3 = 0.01;

%% 提取末端位姿
px = T(1,4);
py = T(2,4);
pz = T(3,4);
R = T(1:3,1:3);

%% 求 q1
q1 = atan2(py, px);

%% 求肩肘平面距离
% 投影到肩关节坐标系
r = sqrt(px^2 + py^2);
s = pz;

% 二次方程辅助
A = L1; B = L2; C = sqrt(r^2 + s^2);

% q3 (肘关节) 肘上解
cos_q3 = (C^2 - A^2 - B^2)/(2*A*B);
cos_q3 = min(max(cos_q3,-1),1); % 避免数值误差
q3 = atan2(sqrt(1 - cos_q3^2), cos_q3);

% q2
phi = atan2(s, r);
psi = atan2(B*sin(q3), A + B*cos(q3));
q2 = phi - psi;

%% 求 q4 和 q5
% 先计算 R03
c1 = cos(q1); s1 = sin(q1);
c2 = cos(q2); s2 = sin(q2);
c3 = cos(q3); s3 = sin(q3);

R01 = [ c1, -s1, 0;
        s1,  c1, 0;
        0 ,   0, 1 ];
R12 = [ c2, 0, s2;
        s2, 0, -c2;
        0,  1, 0 ];
R23 = [ c3, 0, s3;
        s3, 0, -c3;
        0, 1, 0 ];

R03 = R01 * R12 * R23;

R35 = R03' * R; % 手腕旋转矩阵

% q4, q5 解算
q4 = atan2(R35(2,3), R35(1,3));
q5 = atan2(sqrt(R35(1,3)^2 + R35(2,3)^2), R35(3,3));

%% 输出
q = [q1; q2; q3; q4; q5];
end
