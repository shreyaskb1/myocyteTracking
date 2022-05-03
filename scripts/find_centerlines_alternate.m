function all_cells = find_centerlines_alternate(fileName,fileFolder)
    ctr = 1;
    points = [];

%     filtered_slices = 9:10:799;
%     filtered_slices = [1 filtered_slices];
    

    numberOfimgs = size(filtered_slices, 2);

    for i_idx = 1:numberOfimgs
        curr_image = imread(fullfile(fileFolder, fileName), filtered_slices(i_idx));
        curr_image = ~imbinarize(curr_image);
        curr_image = WS_segmentation(curr_image);
        
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
    
    % re-adjust slice alignment
    for i_idx = 1:size(points,1)
        if points(i_idx,3) ~= 1
            points(i_idx,3) = 10*points(i_idx,3) - 11;
        end
    end
    
    figure;
    all_cells = create_cells(points);
    
end

function all_cells = create_cells(points)
    BLOCK_SIZE = 5;
    points = sortrows(points,3);
    
    all_z = unique(points(:,3),'rows');
    blocked_z = [];
    bz_ctr = 1;
    for i_idx = 1:BLOCK_SIZE:size(all_z,1)
        blocked_z(bz_ctr) = all_z(i_idx);
        bz_ctr = bz_ctr + 1;
    end
       
    all_cells = {};
    ctr = 1;
    for i_idx = 1:size(blocked_z,1)
        curr_z = blocked_z(i_idx);
        subset = points(points(:,3) == curr_z,:);
        for j_idx = 1:size(subset,1)
            curr_pt = subset(j_idx,:);
            next_pt = [curr_pt(1), curr_pt(2), curr_pt(3) + BLOCK_SIZE*10 - 1];
            line([curr_pt(1), next_pt(1)], [curr_pt(2), next_pt(2)], [curr_pt(3), next_pt(3)]);
            all_cells{ctr} = [curr_pt;next_pt];
            ctr = ctr + 1;
        end
    end
end

