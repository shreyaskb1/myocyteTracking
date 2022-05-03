function [all_cells, bpts] = find_centerlines_1_toy(fileName,fileFolder,bs,ht)
    ctr = 1;
    points = [];


    info = imfinfo(fullfile(fileFolder, fileName));
    numberOfimgs = length(info);
    

    for i_idx = 1:numberOfimgs
        curr_image = imread(fullfile(fileFolder, fileName), i_idx);
        
        % find centroids of all the cells
        CC = bwconncomp(curr_image);
        S = regionprops(CC, 'Centroid');

        % save all centroids from all sub-images
        for j_idx=1:size(S,1)
            curr_pt = [S(j_idx).Centroid(1), S(j_idx).Centroid(2), i_idx];
            points(ctr,:) = curr_pt;
            ctr = ctr + 1;
        end
        
    end  
    
    % call function which assigns points to cells based on tolerance
    all_cells = create_cells(points, numberOfimgs, bs, ht);
    bpts = unique(find_branchpoints(all_cells),'rows');
    ac_actual = [];
    for i_idx = 1:size(all_cells,2)
        ac_actual = [ac_actual; all_cells{i_idx}];
    end
    ac_actual = unique(ac_actual, 'rows');
    all_cells = ac_actual;
end

function all_cells = create_cells(points, numberOfimgs, bs, ht) 
    total_z_depth = numberOfimgs;
    HORIZONTAL_TOLERANCE = ht;
    all_cells = {};
    ac_ctr = 1;
    figure;
    hold on;
    BLOCK_SIZE = bs;
    for i_idx = 1:total_z_depth-1
        pts_z = points(points(:,3)==i_idx,:);
        num_cells_in_slice = size(pts_z, 1);
        
        for j_idx = 1:num_cells_in_slice
            top_cell = pts_z(j_idx,:);
            tc_x = top_cell(1);
            tc_y = top_cell(2);
            
            for n_idx = 1:BLOCK_SIZE
                pts_next_z = points(points(:,3)==i_idx+n_idx,:);
                sz_pts_next_z = size(pts_next_z, 1);
                cell_found = 0;
                    for k_idx = 1:sz_pts_next_z
                        next_pt = pts_next_z(k_idx, :);
                        np_x = next_pt(1);
                        np_y = next_pt(2);
                        dist = (tc_x - np_x)^2 + (tc_y - np_y)^2;
                        if dist < HORIZONTAL_TOLERANCE^2
                            line([tc_x, np_x], [tc_y, np_y], [i_idx, i_idx+n_idx]);
                            all_cells{ac_ctr} = [top_cell; next_pt];
                            ac_ctr = ac_ctr + 1;
                            cell_found = 1;
                            hold on;
                        end
                    end
                if cell_found == 1
                    break;
                end
           end
        end
    end
end

function branchpoints = find_branchpoints(all_cells)
    branchpoints = [];
    bpt_ctr = 1;
    for i_idx = 1:size(all_cells,2)
        curr_line = all_cells{i_idx};
        curr_pt_1 = curr_line(1,:);
        curr_pt_2 = curr_line(2,:);
        
        for j_idx = (i_idx+1):size(all_cells,2)
            next_line = all_cells{j_idx};
            next_pt_1 = next_line(1,:);
            next_pt_2 = next_line(2,:);
            if isequal(curr_pt_1, next_pt_1)
                branchpoints(bpt_ctr,:) = curr_pt_1;
                bpt_ctr = bpt_ctr + 1;
            end
            
            if isequal(curr_pt_2, next_pt_2)
                branchpoints(bpt_ctr,:) = curr_pt_2;
                bpt_ctr = bpt_ctr + 1;
            end
        end
    end
    
    hold on;
    plot3(branchpoints(:,1), branchpoints(:,2), branchpoints(:,3), 'ro');
end
