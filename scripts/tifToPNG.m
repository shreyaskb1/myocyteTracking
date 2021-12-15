files = dir('*.png');
for f=1:size(files,1)
    input_img = imread(fullfile(files(f).folder, files(f).name));
    output_img = imresize(input_img, [512 512]);
    imgName = sprintf("Image_%d.png", f);
    imwrite(output_img, fullfile(files(f).folder, imgName));    
end

