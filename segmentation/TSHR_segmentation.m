imgStack = 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES\S24_101_01_1a_eq_track1_CROPPED.tif';
output = 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES\S24_101_01_1a_eq_track1_CROPPED_SEGMENTED_filtered.tif';

points_imgStack = 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\s24_handtracked_points.mat';
pts = load(points_imgStack ).s24_points_adjusted; 
info = imfinfo(imgStack);
sz = size(info , 1);

for i_idx = 1:5
    currPts = floor(pts(find(pts(:,3)==i_idx),1:2));
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
        figure, imshow(segmentedImg);
        % imwrite(segmentedImg, output, 'WriteMode', 'append',  'Compression','none');
    
    else
%         segmentedImg = bw3;
%         figure, imshow(segmentedImg);
%         imwrite(segmentedImg, output, 'WriteMode', 'append',  'Compression','none');
%         imwrite(bw3, output, 'WriteMode', 'append',  'Compression','none');
    end
end


