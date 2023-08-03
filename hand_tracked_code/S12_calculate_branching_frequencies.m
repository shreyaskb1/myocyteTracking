fileName = 'S12_tracking_handtracked_color_points.tif';
points = load('S12_points.mat').S12_points;
num_slices = length(imfinfo(fileName));
layers = [];

for k = 1:size(points, 1)
    curr_pt = round(points(k, :));
    curr_slice = imread(fileName, curr_pt(4));
    clr = reshape(curr_slice(curr_pt(3), curr_pt(2), :), [1, 3]);
    
    if isequal(clr, [0, 255, 0])
        layers = [layers 1];
    elseif isequal(clr, [255, 0, 0])
        layers = [layers 2];
    elseif isequal(clr, [0, 0, 255])
        layers = [layers 3];
    elseif isequal(clr, [255, 255, 0])
        layers = [layers 4];
    elseif isequal(clr, [255, 0, 255])
        layers = [layers 5];
    elseif isequal(clr, [255, 255, 255])
        layers = [layers 6];
    else
        figure, imshow(curr_slice);
        hold on;
        plot(curr_pt(2), curr_pt(3), 'bo');
        color = input("Enter color:");
        layers = [layers color];
    end
end

points = [points layers'];

% calculate overall branching frequency 
branchpoints = [24, 23, 98;
39, 38,56;
47, 48,49;
51, 292,50;
59, 58,71;
64, 65,66;
76, 77,78;
185, 186,187;
217, 265,218;
225, 226,245;
236, 237,241;
264, 263,233;
270, 271,287;
291, 290,227;
293, 292,162;
296, 311,297;
310, 247,309;
313, 215,312;
318, 298,317;
340, 339,361;
377, 211,376;
380, 379,390;
389, 201,388;
423, 424,432;
437, 176,436;
454, 455,465;
501, 411,502;
555, 554,390;
591, 609,592;
628, 610,627;
629, 609,626;
633, 584,632;
660, 657,661;
674, 673,674;
704, 695,703;
718, 417,717;
736, 512,735;
743, 742,587;
770, 760,771;
804, 803,605;
805, 806,330;
810, 809,795;
828, 829,839;
851, 814,850;
889, 888,821;
890, 818,891;
907, 906,843;
921, 896,920;
947, 946,365;
948, 943,949;
953, 952,662];

slice_size = 10e-6;
non_bp_length = slice_size*(size(points, 1) - size(branchpoints, 1));
bp_frequency = size(branchpoints, 1) / non_bp_length;

% calculate within-layer and between-layer branching frequency 
same_layer = [];
diff_layer = [];

for idx=1:size(branchpoints,1)
    curr_bpt = branchpoints(idx,:);
    pt_1 = curr_bpt(2);
    pt_2 = curr_pt(3);
    if points(pt_1, 5) == points(pt_2, 5)
        same_layer = [same_layer; curr_bpt];
    else 
        diff_layer = [diff_layer; curr_bpt];
    end
end
    
within_layer_freq = size(same_layer, 1) / non_bp_length;
between_layer_freq = size(diff_layer, 1) / non_bp_length;

