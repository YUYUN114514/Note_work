function eul = rotm2eul_zyx(R)
% 输出: [yaw pitch roll]

yaw   = atan2(R(2,1), R(1,1));
pitch = atan2(-R(3,1), sqrt(R(3,2)^2 + R(3,3)^2));
roll  = atan2(R(3,2), R(3,3));

eul = [yaw, pitch, roll];
end
