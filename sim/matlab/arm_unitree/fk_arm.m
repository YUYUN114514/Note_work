function T = fk_arm(q)

L1 = 0.038;   
L2 = 0.1032;  
L_off = 0.01578; % URDF中的横向偏置
L3 = 0.0805;
L4 = 0.01;
    DH = [ 0     pi/2   0     q(1);
           0    -pi/2   L1    q(2);
           L_off     pi/2   L2    q(3);
           L3    0      0     q(4);
           L4    0      0     q(5) ];

    T = eye(4);
    for i = 1:5
        T = T * dh(DH(i,1), DH(i,2), DH(i,3), DH(i,4));
    end
end

