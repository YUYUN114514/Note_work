%% --- 辅助函数: DH前向运动学 ---
function pos = forward_kinematics(q, robot)
    T = robot.fkine(q); % 返回4x4矩阵
    pos = T(1:3,4)';     % 提取末端位置
end