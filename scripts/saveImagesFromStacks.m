input_path = '/home/shreyas/Documents/MATLAB/REU Project/images/TRACKING_IMAGES/Reslice_of_SHRT_final_Seq_ss1.tif';
output_path = '/home/shreyas/Documents/MATLAB/REU Project/images/SHRT_final_Seq_segmentations/images_long';
list = [785 821 890 920 1185];

for i_idx = 1:size(list,2)
    curr_img = imread(input_path, list(i_idx));
    img_resized = imresize(curr_img, [512 512]);
%     img = uint8(zeros(512));
%     img(1:size(img_resized,1), 1:size(img_resized,2)) = img_resized;
    img_name = sprintf("image_%d.png", list(i_idx));
    imwrite(img_resized, fullfile(output_path, img_name)); 
end