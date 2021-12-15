% watershed segmentation to improve upon ilastik
% potentially can generate ground truth images for DL training

segmented = '/home/shreyas/Documents/MATLAB/REU Project/images/SHR_HR_crop_seg_2.tif';
output_img = '/home/shreyas/Documents/MATLAB/REU Project/images/SHR_HR_crop_seg_2_cleaned.tif';
info = imfinfo(segmented);
sz = size(info, 1);

for i_idx=1:sz
    bw = convertToBw(imread(segmented,i_idx));
    bw = bwareaopen(bw, 100);
    bw = imfill(bw, 'holes');
    D = -bwdist(~bw);
    Ld = watershed(D);
    bw2 = bw;
    bw2(Ld == 0) = 0;
    mask = imextendedmin(D,5);
    D2 = imimposemin(D,mask);
    Ld2 = watershed(D2);
    bw3 = bw;
    bw3(Ld2 == 0) = 0;
    imwrite(bw3, output_img, 'WriteMode', 'append',  'Compression','none');
end


