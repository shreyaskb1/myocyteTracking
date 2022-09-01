img_path = 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES\S24_101_01_1a_eq_track1.tif';
seg_path = 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\segmentation\test_segmentations\S24_tracking_seg.tif';
info = imfinfo(img_path);
sz = size(info , 1);

for idx = 1:1
    currImg = imread(img_path, idx);
    % currImg = imadjust(currImg);
    img_b1 = imbinarize(currImg, 'adaptive');
    SE = strel('disk',2);
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
    bw3 = imclearborder(bw3);
    
    props = regionprops(bw3, 'all');
    [bw3, numberOfBlobs] = bwlabel(bw3, 8); 
    allBlobAreas = [props.Area];
    median_area = median(allBlobAreas, 'all');
    allow = ~isoutlier(allBlobAreas);
    keeperIndexes = find(allow);
    keeperBlobsImage = ismember(bw3, keeperIndexes);
    % figure, imshow(imoverlay(currImg,keeperBlobsImage));
    imwrite(keeperBlobsImage, seg_path, 'WriteMode', 'append',  'Compression','none'); 
end
