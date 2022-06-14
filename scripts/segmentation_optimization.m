imgStack = 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES\S24_101_01_1a_eq_track1_CROPPED.tif';
points_imgStack = 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S24_101_01_1a_eq\handtracked_centerpoints.mat';

pts = load(points_imgStack).list; 
info = imfinfo(imgStack);
all_z = unique(pts(:,3),'rows');
curr_z = 1;
sz = size(info , 1);
all_acc = [];
all_fpr = [];

for strel_size = 1:10
    output = 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\strel_test_images\S24\strel.tif';
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
        SE = strel('disk',strel_size);
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
    bs = 10;
    ht = 30;
    [pts_5, bpts_5] = find_centerlines_1_toy('strel.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\strel_test_images\S24', bs, ht);
    
    cpts_handtracked_5 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S24_101_01_1a_eq\handtracked_centerpoints.mat').list;
    bpts_handtracked_5 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S24_101_01_1a_eq\handtracked_branchpoints.mat').all_bps_coords;
    
    % fixing z-coordinates
    
    for i_idx = 1:size(pts_5,1)
        if pts_5(i_idx,3) ~= 1
            pts_5(i_idx,3) = 10*pts_5(i_idx,3) - 11;
        end
    end
    for i_idx = 1:size(bpts_5,1)
        if bpts_5(i_idx,3) ~= 1
            bpts_5(i_idx,3) = 10*bpts_5(i_idx,3) - 11;
        end
    end    
    
    for i_idx = 1:size(pts_5,1)
        if pts_5(i_idx,3) ~= 1
            pts_5(i_idx,3) = 10*pts_5(i_idx,3) - 9;
        end
    end
    for i_idx = 1:size(bpts_5,1)
        if bpts_5(i_idx,3) ~= 1
            bpts_5(i_idx,3) = 10*bpts_5(i_idx,3) - 9;
        end
    end
    
    dt_1 = 600;
    dt_2 = 200;
    [accuracy_cp_5, cpfpr_5] = similarity_plotter(pts_5, cpts_handtracked_5, dt_1, dt_2, 0);
    dt_1 = 2000;
    dt_2 = 2000;
    [accuracy_bp_5, bpfpr_5] = similarity_plotter(bpts_5, bpts_handtracked_5, dt_1, dt_2, 0);
    acc_5 = [accuracy_cp_5, accuracy_bp_5];
    fpr_5 = [cpfpr_5, bpfpr_5];
    
    
    all_acc = [all_acc; acc_5];
    all_fpr = [all_fpr; fpr_5];
    delete 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\strel_test_images\S24\strel.tif';
end
    
disp(all_acc);
disp(all_fpr);
