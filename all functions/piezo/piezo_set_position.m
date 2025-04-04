function piezo_set_position(piezo,desired_pos)

    desired_pos = max(desired_pos,0);
    desired_pos = min(desired_pos,100);

    piezo.MOV('1',desired_pos);
    while(piezo.IsMoving())
%         pause (0.001);
    end