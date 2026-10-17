%% ---------------- 机械臂关节位置 ----------------
function pts = fk_arm_points(q)
pts = zeros(6,3);  % 5关节 + 底座
T = eye(4);
pts(1,:) = [0 0 0];
L1 = 0.1032; L2 = 0.0805; L3 = 0.01;
DH = [0 pi/2 0 q(1);
      0 -pi/2 0 q(2);
      0 pi/2 L1 q(3);
      L2 0 0 q(4);
      L3 0 0 q(5)];
for i=1:5
    T = T * dh(DH(i,1), DH(i,2), DH(i,3), DH(i,4));
    pts(i+1,:) = T(1:3,4)';
end
end