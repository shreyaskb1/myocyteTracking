
% finds branch points between the zth slice and the z-1th slice, z > 1
function branchPoints = findBranchpoints(points, S, z)
    CLOSE_ENOUGH = 100;
    previous_layer_indices = find(points(:,3)==(z-1));
    previous_layer = points(previous_layer_indices(:), :);
    branchPoints = [];

    limit_zprev = size(previous_layer, 1);
    limit_z = size(S, 1);
    ctr = 1;
    
    curr_layer = zeros(size(S,1), 3);
    for i=1:size(S,1)
        c = S(i).Centroid;
        curr_layer(i,:) = [c(1), c(2), z];
    end
    
    % one branch in z-1th slice becomes two in zth slice
    for i_idx=1:limit_zprev
        curr_pt_pl = previous_layer(i_idx,:);
        curr_x_pl = curr_pt_pl(1);
        curr_y_pl = curr_pt_pl(2);
        if checkIfValid(curr_pt_pl, curr_layer) == 0
            num_within_dist = 0;
            for j_idx = 1:limit_z
                curr_pt = S(j_idx).Centroid;
                x_diff = curr_pt(1) - curr_x_pl;
                y_diff = curr_pt(2) - curr_y_pl;
                dist = x_diff^2 + y_diff^2;
                if dist < CLOSE_ENOUGH
                    num_within_dist = num_within_dist + 1;
                end
            end
            
            if num_within_dist > 1
                branchPoints(ctr,:) = [curr_pt_pl];
                ctr = ctr + 1;
            end
        end
    end

    % two branches in z-1th slice become one in zth slice
    for i_idx=1:limit_z
        curr_pt = [S(i_idx).Centroid z];
        curr_x = curr_pt(1);
        curr_y = curr_pt(2);
        if checkIfValid(curr_pt,previous_layer) == 0
            num_within_dist = 0;
            for j_idx=1:limit_zprev
                curr_pt_pl = previous_layer(j_idx,:);
                curr_x_pl = curr_pt_pl(1);
                curr_y_pl = curr_pt_pl(2);
                
                x_diff = curr_x - curr_x_pl;
                y_diff = curr_y - curr_y_pl;
                dist = x_diff^2 + y_diff^2;
                if dist < CLOSE_ENOUGH
                    num_within_dist = num_within_dist + 1;
                end
            end
            
            if num_within_dist > 1
                branchPoints(ctr,:) = [curr_pt];
                ctr = ctr + 1;
            end
            
        end
    end
    
end
