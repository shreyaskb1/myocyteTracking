close all;
clc;

stack1 = '/home/shreyas/Documents/MATLAB/REU Project/images/DL_segmentation/Reslice of 14mo_TSHR_48_tracking_SEGMENTED.tif';
stack2 = '/home/shreyas/Documents/MATLAB/REU Project/images/DL_segmentation/Reslice_of_14mo_TSHR_48_tracking_SEGMENTED.tif';

output = '14mo_agreement_colormap.tif';

info = imfinfo(stack1);
sz = size(info, 1);

STD_X = 512;
STD_Y = 512;

for i_idx = 1:sz
    img1 = imread(stack1, i_idx);
    img2 = imread(stack2, i_idx);
    img1 = imresize(img1, [STD_X STD_Y]);
    img2 = imresize(img2, [STD_X STD_Y]);
    newImg = imfuse(img1, img2);
    imwrite(newImg, output, 'WriteMode', 'append',  'Compression','none');
    
end

