function T05 = position_to_T05(position, eulerZYX)
% computeT05 计算五轴机械臂末端位姿矩阵
%
% 输入:
%   position   - 3x1 向量，末端位置 [x; y; z]
%   eulerZYX   - 3x1 向量，末端欧拉角 [yaw; pitch; roll] (ZYX 顺序，弧度)
%
% 输出:
%   T05        - 4x4 齐次变换矩阵

% 提取位置
x = position(1);
y = position(2);
z = position(3);

% 提取欧拉角
yaw   = eulerZYX(1);  % Z
pitch = eulerZYX(2);  % Y
roll  = eulerZYX(3);  % X

% 旋转矩阵 ZYX
Rz = [cos(yaw), -sin(yaw), 0;
      sin(yaw),  cos(yaw), 0;
      0,        0,        1];

Ry = [cos(pitch), 0, sin(pitch);
      0,          1, 0;
     -sin(pitch), 0, cos(pitch)];

Rx = [1, 0,         0;
      0, cos(roll), -sin(roll);
      0, sin(roll),  cos(roll)];

% 总旋转矩阵
R = Rz * Ry * Rx;

% 拼装齐次矩阵
T05 = [R, [x; y; z]; 0 0 0 1];

end
