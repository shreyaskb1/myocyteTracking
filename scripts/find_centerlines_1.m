  function centerLines = find_centerlines_1(fileName,fileFolder)
   
    imgName = fullfile(fileFolder, fileName);
    info = imfinfo(imgName);
    ctr = 1;
    ctr_b = 1;
    imgStackSize = size(info, 1);
    points = [];
    branchPoints = [];
    SIZE_X = 500;
    SIZE_Y = 500;
    
    filtered_slices = 9:10:799;
    filtered_slices = [1 filtered_slices]; 
    
    % iterate over all images in the stack
    for i_idx = 1:size(filtered_slices,2)
        
        % clean up image and find all centers of cells 
        % curr_image = floorNoiseRemoval(imgName, filtered_slices(i_idx));
        % curr_image = bwareaopen(curr_image, 100);
        % curr_image = imclose(curr_image, strel('disk',1));
        curr_image = imread(fullfile(fileFolder, fileName), filtered_slices(i_idx));
        % curr_image = imresize(curr_image, [SIZE_X SIZE_Y]);
        curr_image = ~imbinarize(curr_image);
        
        curr_image = WS_segmentation(curr_image);
        % figure, imshow(curr_image);
        
        
        CC = bwconncomp(curr_image);
        S = regionprops(CC, 'Centroid');
        
        % iterate over each cell in a given z-slice
        for j_idx=1:size(S,1)
            curr_pt = [S(j_idx).Centroid(1), S(j_idx).Centroid(2), i_idx];
            points(ctr,:) = curr_pt;
            ctr = ctr + 1;
        end

        
    end
    

    
    % create plot of center lines
    
    % figure;
    TOLERANCE_SQ = 400;

    BLOCK_SIZE = 10;
    
    total_z_depth = max(points(:,3));
    already_plotted = [];
    ap_ctr = 1;
    
    pts_to_plot = [];
    ptp_ctr = 1;
    tag = 1;
    
    for z=1:total_z_depth
        
        % find all the cells in the current slice and remove those that
        % have been plotted already
        pts_z = points(find(points(:,3)==z), :);
        
        if isempty(already_plotted) == 0
            common_rows = ismember(pts_z, already_plotted, 'rows');
            pts_z(common_rows==1, :) = [];
        end
        
        num_cells = size(pts_z, 1);
        
        % for each cell, traverse down the z-stack, connecting its center
        % to the center of a cell at most ten slices further down
        
        for cell_ctr = 1:num_cells
            curr_cell_x = pts_z(cell_ctr,1);
            curr_cell_y = pts_z(cell_ctr, 2);
            curr_slice = z;
            while curr_slice <= total_z_depth - BLOCK_SIZE + 1
                flag = 0;
                for i_idx = curr_slice+1:(curr_slice+BLOCK_SIZE+1)
                    all_cells = points(find(points(:,3)==i_idx), :);
                    ac_size = size(all_cells, 1);
                    for j_idx = 1:ac_size
                        next_cell_x = all_cells(j_idx, 1);
                        next_cell_y = all_cells(j_idx, 2);
                        dist = (curr_cell_x - next_cell_x)^2 + (curr_cell_y - next_cell_y)^2;
                        if dist <= TOLERANCE_SQ
                            pts_to_plot(ptp_ctr,:) = [curr_cell_x, curr_cell_y, curr_slice, tag];
                            pts_to_plot(ptp_ctr+1,:) = [next_cell_x, next_cell_y, all_cells(j_idx,3), tag];
                            curr_cell_x = next_cell_x;
                            curr_cell_y = next_cell_y;
                            curr_slice = i_idx;
                            already_plotted(ap_ctr, :) = [curr_cell_x, curr_cell_y, i_idx];
                            already_plotted(ap_ctr+1,:) = [next_cell_x, next_cell_y, all_cells(j_idx,3)];
                            ap_ctr = ap_ctr+2;
                            flag = 1;
                            ptp_ctr = ptp_ctr + 2;
                            break;
                        end
                    end
                    if flag == 1
                        break;
                    end
                end
                if flag == 0
                    curr_slice = curr_slice + BLOCK_SIZE;
                end
            end 
            tag = tag + 1;
        end
    end
  
    % draw the points from matrix
    pts_to_plot = unique(pts_to_plot, 'rows');
    new_ptp = [];
    num_lines = size(unique(pts_to_plot(:,4)),1);
    unique_lines = unique(pts_to_plot(:,4));
    unique_lines = sort(unique_lines);
    line_ctr = 1;
    idx_ctr = 1;
    CONNECTION_BLOCK_SIZE = 10;
    
    for i_idx=1:num_lines
        curr_tag = pts_to_plot((pts_to_plot(:,4)==i_idx),:);
        curr_tag = sortrows(curr_tag, 3);
        ct_size = size(curr_tag, 1);
        if ct_size > 0
            j_idx = 2;
            new_ptp(idx_ctr,:) = [curr_tag(1,1) curr_tag(1,2) curr_tag(1,3) line_ctr];
            idx_ctr = idx_ctr + 1;
            while j_idx <= ct_size
                if curr_tag(j_idx, 3) - curr_tag(j_idx-1,3) < CONNECTION_BLOCK_SIZE
                    new_ptp(idx_ctr, :) = [curr_tag(j_idx,1), curr_tag(j_idx,2), curr_tag(j_idx,3),line_ctr];
                    idx_ctr = idx_ctr + 1;
                else 
                    line_ctr = line_ctr + 1;
                    new_ptp(idx_ctr, :) = [curr_tag(j_idx,1), curr_tag(j_idx,2), curr_tag(j_idx,3), line_ctr];
                    idx_ctr = idx_ctr + 1;
                end
                j_idx = j_idx + 1;
            end
            line_ctr = line_ctr + 1;
        end
    end
    
    
    MINIMUM_CELL_LENGTH = 10;
    plotted_points = [];
    pp_ctr = 1;
    cell_tag = 1;
    Z_TOLERANCE = 5;
    centerpt_plot = figure; 
    tags = unique(new_ptp(:,4));
    pts_to_plot = new_ptp;
    for i_idx = 1:(line_ctr-1)
        curr_tag = pts_to_plot(find(pts_to_plot(:,4)==tags(i_idx)),:);
        curr_tag = sortrows(curr_tag, 3);
        ct_size = size(curr_tag, 1);
        if ct_size > 0
            if curr_tag(ct_size, 3) - curr_tag(1,3) >= MINIMUM_CELL_LENGTH
                flag = 0;
                for j_idx = 1:(ct_size-1)
                    fp = curr_tag(j_idx,1:3);
                    sp = curr_tag(j_idx+1,1:3);                
                    if abs(fp(3) - sp(3)) > BLOCK_SIZE
                        flag = 1;
                    end
                end
                if flag == 0
                    for k_idx = 1:(ct_size-1)
                        fp = curr_tag(k_idx,1:3);
                        sp = curr_tag(k_idx+1,1:3);
                        if abs(fp(3) - sp(3)) <= Z_TOLERANCE
                            line([fp(1), sp(1)], [fp(2), sp(2)], [fp(3), sp(3)]);
                            plotted_points(pp_ctr,:) = [fp cell_tag];
                            plotted_points(pp_ctr+1,:) = [sp cell_tag];
                            pp_ctr = pp_ctr + 2;
                            hold on;
                        end
                    end
                    cell_tag = cell_tag + 1;
                end 
            end
        end
        
    end
    
    
    
    % code to find branch-points 
    plotted_points = unique(plotted_points, 'rows');
    plotted_points_sorted = sortrows(plotted_points, 4);
    pp_sz = size(plotted_points_sorted,1);
    ax = gca;
    h = findobj(gca,'Type','line');
    
    pp = [];
    all_pts = [];
    for i_idx=1:size(h,1)
        curr_line = h(i_idx);
        all_pts(:,1) = curr_line.XData;
        all_pts(:,2) = curr_line.YData;
        all_pts(:,3) = curr_line.ZData;
        pp = vertcat(all_pts,pp);
    end
     
    pp(:,3) = 10*pp(:,3) - 11;
    pp = round(abs(pp));
    new_plot = zeros(max(pp(:,1)),max(pp(:,2)),max(pp(:,3)));
    
    for i_idx=1:size(pp,1)
        curr_pt = pp(i_idx,:);
        new_plot(curr_pt(1), curr_pt(2), curr_pt(3)) = 1;
        
    end
    
    branchPoints = branchpoints3(new_plot);
    hold on;
    plot3(branchPoints(:,1), branchPoints(:,2), branchPoints(:,3), 'r*');
    bpt_ctr = 1;
    for i_idx=1:size(plotted_points,1)
        curr_p = plotted_ploints(i_idx,:);
        close_points = [];
        ctr = 1;
        for j_idx = 1:size(plotted_points,1)
            next_p = plotted_points(j_idx,:);
            if abs(next_p(3) - curr_p(3)) < BLOCK_SIZE
                if isequal(next_p, curr_p) == 0
                    close_points(ctr,:) = next_p;
                end
            end
        end
        
        ctr = 0;
        for j_idx = 1:size(close_points,1)
            np = close_points(j_idx,:);
            dist = (curr_p(1)-np(1))^2 + (curr_p(2)-np(2))^2;
            if dist < TOLERANCE_SQ
                ctr = ctr + 1;
            end
        end
        
        if ctr > 1
            branchPoints(bpt_ctr,:) = curr_p;
        end
    end
    
end
