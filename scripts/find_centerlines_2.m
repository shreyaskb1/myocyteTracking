function centerLines = find_centerlines_2(fileName,fileFolder)

    filtered_slices = 9:10:799;
    filtered_slices = [1 filtered_slices]; 
    ctr = 1;
    
    % mark all the center-points of the cells
    for z = 1:size(filtered_slices,2)

        curr_image = imread(fullfile(fileFolder, fileName), filtered_slices(z));
        curr_image = ~imbinarize(curr_image);
        
        curr_image = WS_segmentation(curr_image);        
        
        CC = bwconncomp(curr_image);
        S = regionprops(CC, 'Centroid');
        
        % iterate over each cell in a given z-slice
        for j_idx=1:size(S,1)
            curr_pt = [S(j_idx).Centroid(1), S(j_idx).Centroid(2), z];
            points(ctr,:) = curr_pt;
            ctr = ctr + 1;
        end        
    end
    
    % come up with list of initally connected cells 
    
    BLOCK_SIZE = 10;
    TOLERANCE_SQ = 400;
    total_z_depth = max(points(:,3));
    global branchpoints;
    branchpoints = [];
    global branchpointCounter;
    branchpointCounter = 1;
    
    figure;
    
    for i_idx = 1:total_z_depth
        curr_slice = points(points(:,3)==i_idx,:);
        cs_sz = size(curr_slice, 1);     
        for j_idx = 1:cs_sz
            curr_pt = curr_slice(j_idx,:);
            traverseDown(curr_pt, points, total_z_depth, BLOCK_SIZE, TOLERANCE_SQ);        
        end
    end
    
end

function [] = traverseDown(curr_pt, points, total_z_depth, BLOCK_SIZE, TOLERANCE_SQ)
    curr_slice = curr_pt(3);
    next_pts = [];
    ctr = 1;
    while curr_slice <= total_z_depth
        for z=(curr_slice+1):min(curr_slice+BLOCK_SIZE, total_z_depth)
            next_slice = points(points(:,3)==z,:);
            ns_sz = size(next_slice,1);
            for i_idx=1:ns_sz
                nc = next_slice(i_idx,:);
                dist = (nc(1) - curr_pt(1))^2 + (nc(2) - curr_pt(2))^2;
                if dist < TOLERANCE_SQ
                    next_pts(ctr,:) = nc;
                    hold on;
                    line([curr_pt(1) nc(1)], [curr_pt(2), nc(2)], [curr_pt(3), nc(3)]);
                end
            end
        end
    end
    
    if size(next_pts,1) > 1
        branchpoints(branchpointCounter,:) = next_pts;
        branchpointCounter = branchpointCounter + 1;
    end
    for j_idx = 1:size(next_pts,1)
        traverseDown(next_pts(j_idx), points, total_z_depth, BLOCK_SIZE, TOLERANCE_SQ);
    end
end