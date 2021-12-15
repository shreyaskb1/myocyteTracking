function centerLines = find_centerlines(fileName,fileFolder)
   
    imgName = fullfile(fileFolder, fileName);
    info = imfinfo(imgName);
    ctr = 1;
    ctr_b = 1;
    imgStackSize = size(info, 1);
    points = [];
    branchPoints = [];
    
    % iterate over all images in the stack
    for i_idx = 1:imgStackSize
        
        % clean up image and find all centers of cells 
        curr_image = floorNoiseRemoval(imgName, i_idx);
        curr_image = bwareaopen(curr_image, 100);
        curr_image = imclose(curr_image, strel('disk',1));
        
        % curr_image = avgNoiseRemoval(curr_image, fileName, fileFolder, i_idx);
        
        % curr_image = preProcess(curr_image, 0.5, 0, 0);
        
        CC = bwconncomp(curr_image);
        S = regionprops(CC, 'Centroid');
        
        % iterate over each cell in a given z-slice
        for j_idx=1:size(S,1)
            curr_pt = [S(j_idx).Centroid(1), S(j_idx).Centroid(2), i_idx];
            points(ctr,:) = curr_pt;
            ctr = ctr + 1;
        end
        
    end
    
    
    % find all branchpoints in the image stack 
    for i_idx=2:imgStackSize
        curr_image = floorNoiseRemoval(imgName, i_idx);
        curr_image = imclose(curr_image, strel('disk',1));
        curr_image = bwareaopen(curr_image, 100);
        CC = bwconncomp(curr_image);
        S = regionprops(CC, 'Centroid');
        bpts = findBranchpoints(points, S, i_idx);
        % if there exist branchpoints, add them to array of branchpoints
        for j_idx = 1:size(bpts,1)
            branchPoints(ctr_b,:) = bpts(j_idx,:);
            ctr_b = ctr_b + 1;
        end
    end

    % write center points and branch points to the image stack
    for i_idx = 1:imgStackSize
        curr_image = convertToBw(imread(imgName, i_idx));
        % curr_image = bwareaopen(imclose(curr_image, strel('disk',3)), 100);
        centerPoints = points(find(points(:,3)==i_idx), :);
        % branchpts = branchPoints(find(branchPoints(:,3)==i_idx), :);
        imshow(curr_image);
        hold(imgca, 'on');
        plot(imgca,centerPoints(:,1), centerPoints(:,2), 'r*')
        % plot(imgca,branchpts(:,1), branchpts(:,2), 'b*')
        hold(imgca,'off');
        F = getframe;
        outputFileName = 'img_stack_ANNOTATED.tif';
        img = F.cdata;
        imwrite(img, outputFileName, 'WriteMode', 'append',  'Compression','none');
    end
    
    % create plot of center lines
    
    total_size = size(points,1);
    first_layer = points(find(points(:,3)==1), :);
    first_layer_size = size(points(find(points(:,3)==1), :), 1);
    figure;
    TOLERANCE_SQ = 100;

    already_plotted = [];
    already_plotted_ctr = 1;
    BLOCK_SIZE = 10;
    
    total_z_depth = max(points(:,3));
    flag = 0;
    
    for i_idx = 1:first_layer_size
        curr_pt = first_layer(i_idx, :);
        curr_x = curr_pt(1);
        curr_y = curr_pt(2);
        curr_slc = 1;
        while curr_slc <= total_z_depth - BLOCK_SIZE - 1
           flag = 0;
           for j_idx = (curr_slc+BLOCK_SIZE+1):-1:(curr_slc+1)
           % for j_idx = curr_slc+1:(curr_slc+BLOCK_SIZE+1)
               layer = points(find(points(:,3)==j_idx),:);
               layer_sz = size(layer, 1);
               for k_idx = 1:layer_sz
                   next_pt = layer(k_idx, :);
                   next_x = next_pt(1);
                   next_y = next_pt(2);
                   dist = (curr_x - next_x)^2 + (curr_y - next_y)^2;
                   if dist <= TOLERANCE_SQ && flag == 0
                       line([curr_x, next_x], [curr_y, next_y], [curr_slc j_idx]);
                       flag = 1;
                       curr_x = next_x;
                       curr_y = next_y;
                       curr_slc = j_idx;
                       hold on;
                       break;
                   end
               end
               if dist <= TOLERANCE_SQ && flag == 0
                   break;
               end
           end
           curr_slc = j_idx+1;
        end
    end
    centerLines = points;
    
end



