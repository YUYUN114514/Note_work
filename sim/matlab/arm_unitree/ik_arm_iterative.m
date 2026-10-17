function q = ik_arm_iterative(T_des, q0)
% 带限位的通用迭代逆运动学 (Unitree G1 右臂 5-DOF)
% 输入：T_des - 4x4目标位姿, q0 - 初始关节角
% 输出：q - 符合限位要求的关节角

% --- 定义 Unitree G1 右臂关节限位 (Rad) ---
% 顺序：肩Pitch, 肩Roll, 肩Yaw, 肘Pitch, 腕Roll
q_min = [-3.0892; -2.2515; -2.6180; -1.0472; -1.9722];
q_max = [ 2.6704;  1.5882;  2.6180;  2.0944;  1.9722];
% q_min = [-3.14; -3.14; -3.14; -3.14; -3.14];
% q_max = [3.14; 3.14; 3.14; 3.14; 3.14];
if nargin < 2
    % 如果未提供初值，使用限位的中值，这比全零更能避开奇异点
    q = (q_min + q_max) / 2; 
else
    q = q0(:);
end

max_iter = 500;
eps_pos = 1e-6;   
eps_ori = 1e-3;   
alpha = 0.5;      % 步长

for k = 1:max_iter
    % 当前末端位姿
    T_curr = fk_arm(q);      
    p_curr = T_curr(1:3,4);
    R_curr = T_curr(1:3,1:3);
    p_des  = T_des(1:3,4);
    R_des  = T_des(1:3,1:3);
    
    % 计算误差
    e_p = p_des - p_curr;
    R_err = R_des * R_curr';
    e_ori_full = 0.5 * [R_err(3,2)-R_err(2,3);
                         R_err(1,3)-R_err(3,1);
                         R_err(2,1)-R_err(1,2)];
    e_ori = e_ori_full(1:2); 
    
    e = [e_p; e_ori];   
    
    % 收敛判断
    if norm(e_p) < eps_pos && norm(e_ori) < eps_ori
        break;
    end
    
    % 计算雅可比（使用下方定义的数值法函数）
    J = jacobian_fk(q); 
    
    % 迭代更新
    dq = alpha * pinv(J) * e; 
    q = q + dq;
    
    % --- 关键步骤：关节限位截断 ---
    % 将 q 限制在 [q_min, q_max] 范围内
    q = max(min(q, q_max), q_min);
end

if k == max_iter
    warning('IK 在达到最大迭代次数前未完全收敛，可能目标点在可达范围外或受限位影响。');
end
end