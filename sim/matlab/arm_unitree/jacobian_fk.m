%% 雅可比矩阵计算（数值法）
function J = jacobian_fk(q)
    delta = 1e-8;
    n = length(q);
    J = zeros(5,n);
    T0 = fk_arm(q);
    p0 = T0(1:3,4);
    R0 = T0(1:3,1:3);
    
    for i = 1:n
        dq_vec = zeros(n,1);
        dq_vec(i) = delta;
        
        % 计算扰动后的正运动学
        Ti = fk_arm(q + dq_vec);
        pi = Ti(1:3,4);
        Ri = Ti(1:3,1:3);
        
        % 位置雅可比 (3行)
        J(1:3,i) = (pi - p0) / delta;
        
        % 姿态雅可比 (取前2个旋转向量分量)
        R_err = Ri * R0';
        J(4:5,i) = 0.5/delta * [R_err(3,2)-R_err(2,3);
                                R_err(1,3)-R_err(3,1)];
    end
end