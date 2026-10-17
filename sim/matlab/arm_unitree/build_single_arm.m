function arm = build_single_arm()

    L1 = 0.038;
    L2 = 0.1032;
    L3 = 0.0805;
    L4 = 0.01;

    theta = [1.57, -1.1, 1.8, -2.5, -1.57];

    DH = [ theta(1), 0,   0,   pi/2;
           theta(2), 0,   0,  -pi/2;
           theta(3), L2,  0,   pi/2;
           theta(4), 0,   L3,  0;
           theta(5), 0,   L4,  0 ];

    for i = 1:5
        L(i) = Link(DH(i,:), 'standard');
        L(i).qlim = [-360 360]*pi/180;
    end

    arm = SerialLink(L, 'name', 'Arm');
end


