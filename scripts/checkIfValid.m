function isValid = checkIfValid(point, z_slice)
    CLOSE_ENOUGH = 500*500;
    x = point(1);
    y = point(2);
    lim = size(z_slice,1);
    isValid = 0;
    for i_idx=1:lim
        curr_x = z_slice(i_idx,1);
        curr_y = z_slice(i_idx,2);
        dist = (x-curr_x)^2 + (y-curr_y)^2;
        if dist <= CLOSE_ENOUGH
            isValid = 1;
            return;
        end
    end
end