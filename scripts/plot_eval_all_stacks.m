function accuracies = plot_eval_all_stacks
    % plotting 24mo_TSHR_13, same as plot 3
    bs = 8;
    ht = 25;
    [pts_1, bpts_1] = find_centerlines_1_toy('24mo_TSHR_13_SEGMENTED_filtered.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES', bs, ht);

    % plotting S12_tracking
    bs = 8;
    ht = 15;
    [pts_2, bpts_2] = find_centerlines_1_toy('S12_tracking_SEGMENTED_filtered.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES', bs, ht);

    % plotting SHRT_final_Seq_ss1
    [pts_3, bpts_3] = find_centerlines_1_toy('SHRT_final_Seq_ss1_SEGMENTED_filtered.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES', bs, ht);

    % plotting 14mo_TSHR_48
    [pts_4, bpts_4] = find_centerlines_1_toy('14mo_TSHR_48_tracking_SEGMENTED_1.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES', bs, ht);

    % plotting S24_101_01_1a_eq_track1
    bs = 8;
    ht = 20;
    [pts_5, bpts_5] = find_centerlines_1_toy('S24_101_01_1a_eq_track1_CROPPED_SEGMENTED_filtered.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES', bs, ht);

    % comparison with hand-annotated sets
    
    % plot 1
    cpts_handtracked_1 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\24mo_TSHR_13\handtracked_centerpoints.mat').list;
    bpts_handtracked_1 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\24mo_TSHR_13\handtracked_branchpoints.mat').all_bps_coords;
    
    % fixing z-coordinates
    for i_idx = 1:size(pts_1,1)
        if pts_1(i_idx,3) ~= 1
            pts_1(i_idx,3) = 10*pts_1(i_idx,3) - 13;
        end
    end
    for i_idx = 1:size(bpts_1,1)
        if bpts_1(i_idx,3) ~= 1
            bpts_1(i_idx,3) = 10*bpts_1(i_idx,3) - 13;
        end
    end
    
    dt = 1500;
    [accuracy_cp_1, cpfpr_1] = similarity_plotter(pts_1, cpts_handtracked_1, dt);
    [accuracy_bp_1, bpfpr_1] = similarity_plotter(bpts_1, bpts_handtracked_1, dt);
    
    acc_1 = [accuracy_cp_1, accuracy_bp_1];
    
    % plot 2 
    cpts_handtracked_2 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S12\handtracked_centerpoints.mat').list;
    bpts_handtracked_2 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S12\handtracked_branchpoints.mat').all_bps_coords;
    
    for i_idx = 1:size(pts_2,1)
        if pts_2(i_idx,3) ~= 1
            pts_2(i_idx,3) = 10*pts_2(i_idx,3) + 1;
        end
    end
    
    for i_idx = 1:size(bpts_2,1)
        if bpts_2(i_idx,3) ~= 1
            bpts_2(i_idx,3) = 10*bpts_2(i_idx,3) + 1;
        end
    end
    
    dt = 400;
    [accuracy_cp_2, cpfpr_2] = similarity_plotter(pts_2, cpts_handtracked_2, dt);
    [accuracy_bp_2, bpfpr_2] = similarity_plotter(bpts_2, bpts_handtracked_2, dt);
    acc_2 = [accuracy_cp_2, accuracy_bp_2];
    
    % plot 3 
    cpts_handtracked_3 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\24mo_TSHR_13\handtracked_centerpoints.mat').list;
    bpts_handtracked_3 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\24mo_TSHR_13\handtracked_branchpoints.mat').all_bps_coords;

    for i_idx = 1:size(pts_3,1)
        if pts_3(i_idx,3) ~= 1
            pts_3(i_idx,3) = 10*pts_3(i_idx,3) - 13;
        end
    end
    for i_idx = 1:size(bpts_3,1)
        if bpts_3(i_idx,3) ~= 1
            bpts_3(i_idx,3) = 10*bpts_3(i_idx,3) - 13;
        end
    end
    dt = 400;
    [accuracy_cp_3, cpfpr_3] = similarity_plotter(pts_3, cpts_handtracked_3, dt);
    dt = 2000;
    [accuracy_bp_3, bpfpr_3] = similarity_plotter(bpts_3, bpts_handtracked_3, dt);
    acc_3 = [accuracy_cp_3, accuracy_bp_3];

    % plot 4
    cpts_handtracked_4 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\14mo_TSHR_48\handtracked_centerpoints.mat').list;
    bpts_handtracked_4 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\14mo_TSHR_48\handtracked_branchpoints.mat').all_bps_coords;
    
    for i_idx = 1:size(pts_4,1)
        if pts_4(i_idx,3) ~= 1
            pts_4(i_idx,3) = 10*pts_4(i_idx,3) - 11;
        end
    end
    for i_idx = 1:size(bpts_4,1)
        if bpts_4(i_idx,3) ~= 1
            bpts_4(i_idx,3) = 10*bpts_4(i_idx,3) - 11;
        end
    end    
    dt = 400;
    [accuracy_cp_4, cpfpr_4] = similarity_plotter(pts_4, cpts_handtracked_4, dt);
    dt = 2000;
   [accuracy_bp_4, bpfpr_4] = similarity_plotter(bpts_4, bpts_handtracked_4, dt);
    acc_4 = [accuracy_cp_4, accuracy_bp_4];    
    % plot 5    
    cpts_handtracked_5 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S24_101_01_1a_eq\handtracked_centerpoints.mat').list;
    bpts_handtracked_5 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S24_101_01_1a_eq\handtracked_branchpoints.mat').all_bps_coords;
    
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
    
    dt = 200;
    [accuracy_cp_5, cpfpr_5] = similarity_plotter(pts_5, cpts_handtracked_5, dt);
    dt = 2000;
    [accuracy_bp_5, bpfpr_5] = similarity_plotter(bpts_5, bpts_handtracked_5, dt);
    acc_5 = [accuracy_cp_5, accuracy_bp_5];
    
    accuracies = [acc_1;acc_2;acc_3;acc_4;acc_5];
    

end