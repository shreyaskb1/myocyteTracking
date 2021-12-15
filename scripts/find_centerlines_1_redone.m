function branchpoints = find_centerlines_1_redone(fileName,fileFolder)
    ctr = 1;
    points = [];
    
    % set of annotated slices for this dataset (has been hardcoded)
    filtered_slices = 9:10:799;
    filtered_slices = [1 filtered_slices]; 
    radii = [];
    
    for i_idx = 1:size(filtered_slices,2)
        % read image from file and split cells, if necessary
        curr_image = imread(fullfile(fileFolder, fileName), filtered_slices(i_idx));
        
        % some preprocessing in order to use the bwconncomp function
        curr_image = ~imbinarize(curr_image);
        curr_image = WS_segmentation(curr_image);
        
        % find centroids of all the cells
        CC = bwconncomp(curr_image);
        S = regionprops(CC, 'Centroid');
        R = regionprops(CC, 'EquivDiameter');
        
        % save all centroids from all sub-images
        for j_idx=1:size(S,1)
            curr_pt = [S(j_idx).Centroid(1), S(j_idx).Centroid(2), i_idx];
            points(ctr,:) = curr_pt;
            radii(ctr) = 0.5*R(j_idx).EquivDiameter;
            ctr = ctr + 1;
        end
    end
    
    num_slices = size(filtered_slices,2);
    % points(points(:,3) ~= 1,3) = points(points(:,3) ~= 1,3)*10 - 11;
    
    % call function which assigns points to cells based on tolerance
    all_cells = create_cells(points, num_slices);
    
    % next section of code will plot cells whose length is at least 10
    % slices

    [plotted_points, centerpt_plot] = draw_cells(all_cells);
    
    sz_ac = size(all_cells,1);
    for i_idx = 1:sz_ac
        curr_pt = all_cells(i_idx,:);
        other_pts = all_cells(all_cells(:,4) ~= curr_pt(4),:);
        if ismember(curr_pt(1:3),other_pts(:,1:3),'rows')
            hold on;
            plot3(curr_pt(1),curr_pt(2),curr_pt(3),'ro');
        end
    end

    % draw branch-points by connecting points that are not in cell to the
    % closest ones that are
        
    branchpoints = draw_branchpoints_2(plotted_points, points, all_cells);
    
    hold on;
    plot3(branchpoints(:,1), branchpoints(:,2), branchpoints(:,3), 'ro');
    
end

function branchpoints = draw_branchpoints_3(plotted_points, points, all_cells)
    centerpt_tolerance = 500;
    branchpoints = [];
    branchpt_tolerance = 1000;
    branchpt_ctr = 1;
    sz_pp = size(plotted_points,1);
    
    for i_idx = 1:(sz_pp-1)
        curr_pt = plotted_points(i_idx,:);
        next_slc = plotted_points(plotted_points(:,3)==curr_pt(3)+1,:);
        ns_sz = size(next_slc,1);
        
        flag = 0;
        
        for j_idx=1:ns_sz
            next_pt = next_slc(j_idx,:);
            dist = (curr_pt(1) - next_pt(1))^2 + (curr_pt(2) - next_pt(2))^2;
            if dist < centerpt_tolerance
                flag = 1;
            end
        end
        
        if flag == 1
            ctr = 0;
            for j_idx=1:ns_sz
                next_pt = next_slc(j_idx,:);
                dist = (curr_pt(1) - next_pt(1))^2 + (curr_pt(2) - next_pt(2))^2;
                if dist < branchpt_tolerance
                    ctr = ctr + 1;
                end
            end
            
            if ctr >= 2
                branchpoints(branchpt_ctr,:) = curr_pt;
                branchpt_ctr = branchpt_ctr + 1;
            end
        else
            curr_slc = plotted_points(plotted_points(:,3)==curr_pt(3),:);
            cs_sz = size(curr_slc, 1);
            
            ctr_1 = 0;
            for j_idx=1:cs_sz
                next_pt = curr_slc(j_idx,:);
                dist = (curr_pt(1) - next_pt(1))^2 + (curr_pt(2) - next_pt(2))^2;
                if dist < branchpt_tolerance
                    ctr_1 = ctr_1 + 1;
                end
            end
            
            ctr_2 = 0;
            for j_idx=1:ns_sz
                next_pt = next_slc(j_idx,:);
                dist = (curr_pt(1) - next_pt(1))^2 + (curr_pt(2) - next_pt(2))^2;
                if dist < branchpt_tolerance
                    ctr_2 = ctr_2 + 1;
                end
            end          
            
            if ctr_1 - 1 == ctr_2
                branchpoints(branchpt_ctr,:) = curr_pt;
                branchpt_ctr = branchpt_ctr + 1;
            end
        end
    end
   
end

function branchpoints = draw_branchpoints_2(plotted_points, points, all_cells)

    % variable initializing for constants and tolerances
    sz_pp = size(plotted_points);
    Z_TOLERANCE = 5;
    XY_TOLERANCE = 2200;
    H_TOLERANCE = 2000;
    
    
    % to store the list of branchpoints
    branchpoints = [];
    bp_ctr = 1;
    
    % looping through the list of cells plotted 
    for i_idx = 1:sz_pp
        
        % take the current point and evaluate whether it is a branch or not
        
        curr_pt = plotted_points(i_idx,:);
        x = [];
        y = []; 
        
        % make sure that there are no branchpoints within a Z_TOLERANCE
        % range
        if ~isempty(branchpoints)
            x = branchpoints((curr_pt(3) > branchpoints(branchpoints(:,4)==curr_pt(4),3) - Z_TOLERANCE),:);
            y = branchpoints((curr_pt(3) <= branchpoints(branchpoints(:,4)==curr_pt(4),3) + Z_TOLERANCE),:);
        end
        
        z = intersect(x,y,'rows');
        
        if isempty(z)
            
            % search the list of possible branchpoints
            pts_to_search_z = plotted_points(plotted_points(:,3)==curr_pt(3),:);
            pts_to_search_tag = plotted_points(plotted_points(:,4)~=curr_pt(4),:);
            pts_to_search = intersect(pts_to_search_z, pts_to_search_tag, 'rows');
            pts_sz = size(pts_to_search,1);
            
            % loop over points that are in the same z-slice and part of a
            % different cell-tag and within a tolerable distance
            for j_idx=1:pts_sz
                next_pt = pts_to_search(j_idx,:);
                dist = (curr_pt(1) - next_pt(1))^2 + (curr_pt(2) - next_pt(2))^2;
                if dist < XY_TOLERANCE
                    hold on;
                    
                    % if found, plot and store the branch-point
                    line([curr_pt(1) next_pt(1)], [curr_pt(2) next_pt(2)], [curr_pt(3) next_pt(3)]);
                    
                    % if the branch is long enough to be an H-branch point,
                    % then mark it as two separate branchpoints. Otherwise,
                    % it is classified as a Y-point, and only one point,
                    % the midpoint of the points, is chosen
                    if dist > H_TOLERANCE
                        branchpoints(bp_ctr,:) = [curr_pt 0];
                        branchpoints(bp_ctr+1,:) = [next_pt 0];
                        bp_ctr = bp_ctr + 2;
                    else 
                        mid_x = 0.5*(curr_pt(1) + next_pt(1));
                        mid_y = 0.5*(curr_pt(2) + next_pt(2));
                        branchpoints(bp_ctr,:) = [mid_x mid_y curr_pt(3) curr_pt(4) 1];
                        bp_ctr = bp_ctr + 1;
                    end
                end
            end
        end
    end
end


function [plotted_points, centerpt_plot] = draw_cells(all_cells)
    MINIMUM_CELL_LENGTH = 10;
    plotted_points = [];
    pp_ctr = 1;
    
    num_cells = max(all_cells(:,4));
    centerpt_plot = figure;
    
    % loop over all the tagged cells
    for i_idx = 1:num_cells
        % enumerate cells with the current tag
        curr_cell = all_cells(all_cells(:,4)==i_idx,:);
        cc_sz = size(curr_cell,1);
        
        % if the cell is longer than 10 slices long, connect all the points
        % in the cell together - determine this by looking at the min and
        % max z-values that are found in the tagged cell's center-points
        
        if max(curr_cell(:,3)) - min(curr_cell(:,3)) >= MINIMUM_CELL_LENGTH
            curr_cell = sortrows(curr_cell,3);
            for j_idx = 1:(cc_sz-1)
                
                % connect consecutive points with a line and keep track of
                % what has been plotted
                fp = curr_cell(j_idx,:);
                sp = curr_cell(j_idx+1,:);
                line([fp(1), sp(1)], [fp(2), sp(2)], [fp(3), sp(3)]);
                plotted_points(pp_ctr,:) = fp;
                plotted_points(pp_ctr,:) = sp;
                plotted_points = unique(plotted_points,'rows');
                pp_ctr = size(plotted_points,1) + 1;
                hold on;
            end
        end    
    end
end

function all_cells = create_cells(points, num_cells)
    total_z_depth = max(points(:,3));
    HORIZONTAL_TOLERANCE = 500;
    BLOCK_SIZE = 20;
    all_cells = [];
    
    cell_counter = 1;
    tag = 1;
    
    % cycle through all layers and create list of tagged cells 
    for i_idx = 1:total_z_depth
        
        % keep track of cells and # of cells in the current slice
        pts_z = points(points(:,3)==i_idx,:);
        num_cells_in_slice = size(pts_z, 1);
    
        % for each cell in the slice, traverse down the z stack, tagging
        % points that are part of the cell based on horizontal tolerance
        for j_idx = 1:num_cells_in_slice
            
            % the current center-point coordinate, which is the  top of 
            % the cell that will be drawn with a unique tag
            
            top_cell = pts_z(j_idx,:);
            tc_x = top_cell(1);
            tc_y = top_cell(2);
            curr_slice = i_idx;
            

            % check if the center-point has been found to be part of
            % another cell first, and only proceed if it hasn't, or if this
            % is the first iteration/all_cells has nothing in it yet 
            
           
            if (isempty(all_cells)) || (~isempty(all_cells) && ~ismember(top_cell, all_cells(:,1:3),'rows'))   
                
            % traverse down, slice by slice, from top_cell, adding points
            % to the tag if they are within the appropriate horizontal
            % distance, and stop when there is no such cell within the next
            % BLOCK_SIZE slices (default: 10)
                found_one_cell = 0;
                while curr_slice < total_z_depth

                    % looking for the closest center-point in the z+ith
                    % slice in the block

                    found_cell = 0;

                    % look for the same cell within a 10-slice block, while
                    % limiting the extent of the end to the final slice 
                    % of the z-stack

                    for k_idx = (curr_slice+1):(min(curr_slice+BLOCK_SIZE,total_z_depth))

                        % slice in which it looks for a corresponding center
                        % point 
                        dist_min = 500*500;
                        index_min = 0;
                        next_z = points(points(:,3)==k_idx,:);
                        size_next_z = size(next_z,1);

                        % iterating over all cells in that slice to find such a
                        % point, if it exists
                        for n_idx = 1:size_next_z

                            % calculating horizontal distance to compare with
                            % tolerance

                            next_cell = next_z(n_idx,:);
                            dist = (tc_x - next_cell(1))^2 + (tc_y - next_cell(2))^2;

                            % looks for the closest such cell, if multiple
                            % exist
                            if (dist <= HORIZONTAL_TOLERANCE) && dist < dist_min
                                if (isempty(all_cells)) || (~isempty(all_cells) && ~ismember(next_cell, all_cells(:,1:3),'rows'))
                                     dist_min = dist;
                                    index_min = n_idx;
                                end
                            end
                        end

                        % save the minimum distance cell and exit the loop 
                        if dist_min <= HORIZONTAL_TOLERANCE
                            closest_pt = next_z(index_min,:);
                            found_cell = 1;
                            break;
                        end
                    end

                    % if found, note that it's been found, add it to the list
                    % of cells with the appropriate tag, and update the current
                    % slice and current cell
                    if found_cell == 1
                        all_cells(cell_counter,:) = [top_cell, tag];
                        all_cells(cell_counter+1,:) = [closest_pt, tag];
                        all_cells = unique(all_cells,'rows');
                        cell_counter = size(all_cells,1) + 1;
                        curr_slice = k_idx;
                        tc_x = closest_pt(1);
                        tc_y = closest_pt(2);
                        top_cell = closest_pt;
                        found_one_cell = 1;
                    % if not, move to the next cell in the slice while
                    % keeping the tag the same
                    else 
                        break;
                    end           
                end
                
                if found_one_cell == 1
                    tag = tag + 1;
                end
            end
        end
    end
end
