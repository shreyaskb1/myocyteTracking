function similarityCenter = centerSimilarity(centerpts_1, centerpts_2)
    % assumes first list is smaller - pass in accordingly
    % points must be in [x, y, z] format
    IMAGE_X = 799;
    IMAGE_Y = 800;
    
    TOLERANCE = 400;
    sz_1 = size(centerpts_1, 1);
    similarityCenter = zeros(sz_1,1);
    ctr = 0;
    nonzero_dist = [];
    for i_idx=1:sz_1
        p1 = centerpts_1(i_idx,:);
        p2_slice_z = centerpts_2(centerpts_2(:,3)==p1(3),:);
        sz_p2z = size(p2_slice_z,1);
        min_dist = IMAGE_X^2 + IMAGE_Y^2;
        dist = min_dist;        
        for j_idx = 1:sz_p2z
            p2 = p2_slice_z(j_idx,:);
            dist = (p1(1) - p2(1))^2 + (p1(2) - p2(2))^2;
            if dist < min_dist
                min_dist = dist;
            end
        end
        
        if min_dist <= TOLERANCE
            disp(p1);
            disp(p2);
            ctr = ctr + 1;
            similarity = min_dist;
            nonzero_dist(ctr) = min_dist;
            
        else 
            similarity = 0;
        end
        similarityCenter(i_idx,:) = similarity;
    end
    
   % mean(similarityCenter(similarityCenter~=0))
    sum(similarityCenter~=0)/2671
    sqrt(mean(nonzero_dist))*0.4
end

