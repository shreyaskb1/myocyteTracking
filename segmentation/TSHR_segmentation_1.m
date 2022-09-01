imgStack = 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES\24mo_TSHR_13.tif';
output = 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES\fully_segmented_images\24mo_TSHR_13_tracking_SEGMENTED_COMPLETE.tif';

points_imgStack = 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\24mo_TSHR_13\handtracked_centerpoints.mat';

pts = load(points_imgStack).list; 
info = imfinfo(imgStack);
all_z = unique(pts(:,3),'rows');
curr_z = 1;
sz = size(info , 1);

for i_idx = 1:sz
    
    if ismember(i_idx, all_z)
        currPts = floor(pts(find(pts(:,3)==i_idx),1:2));
    else
        [~,idx] = mink(abs(all_z-i_idx),2);
        closest_slices = all_z(idx);
        currPts = floor(pts(find(pts(:,3)==closest_slices(1)),1:2));
        currPts = [currPts; floor(pts(find(pts(:,3)==closest_slices(2)),1:2))];
    end
    currImg = imread(imgStack, i_idx);
    img_b1 = imbinarize(currImg, 'adaptive');
    SE = strel('disk',3);
    img_b2 = ~imclose(img_b1, SE);
    img_b3 = ~bwareaopen(~img_b2, 100);
    img_b3 = bwareaopen(img_b3, 1000);
    
    bw = img_b3;
    D = -bwdist(~bw);
    Ld = watershed(D);
    bw2 = bw;
    bw2(Ld == 0) = 0;
    mask = imextendedmin(D,2);
    D2 = imimposemin(D,mask);
    Ld2 = watershed(D2);
    bw3 = bw;
    bw3(Ld2 == 0) = 0;
    bw3 = bwareaopen(bw3, 100);
    if size(currPts, 1) > 0
        CC = bwconncomp(bw3);
        CC_sz = CC.NumObjects;
        pixelList = CC.PixelIdxList;
        segmentedImg = bwlabel(bw3, 8);
        X = zeros(CC_sz, 1);
        for j_idx=1:CC_sz
            [r, c] = ind2sub(size(currImg), pixelList{j_idx});
            rc = [c, r];
            hasCenterPt = sum(ismember(currPts, rc, 'rows'));
            if hasCenterPt > 0
                X(j_idx)=1;
            end
        end
        keeperIndexes = find(X);
        segmentedImg = ismember(segmentedImg, keeperIndexes);
        imwrite(segmentedImg, output, 'WriteMode', 'append',  'Compression','none')
    end
end


