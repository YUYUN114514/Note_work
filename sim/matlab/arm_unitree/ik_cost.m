function e = ik_cost(q, T_des)

    T = fk_arm(q);

    pos_err = T(1:3,4) - T_des(1:3,4);
    R_err   = T(1:3,1:3)' * T_des(1:3,1:3);
    ori_err = rotm2axang(R_err);
    ori_err = ori_err(1:3) * ori_err(4);

    e = [pos_err; ori_err];
end
