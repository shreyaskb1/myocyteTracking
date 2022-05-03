function all_cells = find_centerlines_tubes(fileName,fileFolder, BS)
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
    
    figure;
    all_cells = create_cells(points, BS);

end

function all_cells = create_cells(points, BS)
    BLOCK_SIZE = BS;
    z_slices = 1:BLOCK_SIZE:max(points(:,3));
    all_cells = [];
    for i_idx = 1:size(z_slices,2)
        this_slice = points(points(:,3)==z_slices(i_idx),:);
        sz_ts = size(this_slice,1);
        for j_idx = 1:sz_ts
            this_pt = this_slice(j_idx,:);
            line([this_pt(1), this_pt(1)],[this_pt(2), this_pt(2)],[this_pt(3), this_pt(3)+BLOCK_SIZE-1]);
            for k_idx = 1:BLOCK_SIZE
                all_cells = [all_cells; [this_pt(1), this_pt(2), this_pt(3)+k_idx-1]];
            end
            hold on;
        end
    end
    all_cells = unique(all_cells, 'rows');
end