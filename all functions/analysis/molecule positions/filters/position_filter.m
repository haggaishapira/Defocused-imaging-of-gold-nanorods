function pass = position_filter(x,y,borders,use_radius,max_radius,dim_vid,center_x,center_y)

    pass = 1;
    if use_radius
        rel_x = x-center_x;
        rel_y = y-center_y;
        rad = (rel_x^2 + rel_y^2)^0.5;
        if rad > max_radius
            pass = 0;
        end
    else
        if y < borders.top || y > borders.bottom || x < borders.left || x > borders.right
            pass = 0;
        end
    end