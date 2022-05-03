function accuracies = plot_eval_all_stacks_tubes
    BS = 10;
    cp1 = find_centerlines_tubes('24mo_TSHR_13_SEGMENTED_filtered.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES',BS);
    
    for i_idx = 1:size(cp1,1)
        if cp1(i_idx,3) ~= 1
            cp1(i_idx,3) = 10*cp1(i_idx,3) - 13;
        end
    end
    
    cp2 =  find_centerlines_tubes('S12_tracking_SEGMENTED_filtered.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES',BS);
    
    for i_idx = 1:size(cp2,1)
        if cp2(i_idx,3) ~= 1
            cp2(i_idx,3) = 10*cp2(i_idx,3) + 1;
        end
    end
    
    cp3 =  find_centerlines_tubes('SHRT_final_Seq_ss1_SEGMENTED_filtered.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES',BS);
    
    for i_idx = 1:size(cp3,1)
        if cp3(i_idx,3) ~= 1
            cp3(i_idx,3) = 10*cp3(i_idx,3) - 13;
        end
    end
    
    cp4 =  find_centerlines_tubes('14mo_TSHR_48_tracking_SEGMENTED_1.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES',BS);
        
    for i_idx = 1:size(cp4,1)
        if cp4(i_idx,3) ~= 1
            cp4(i_idx,3) = 10*cp4(i_idx,3) - 11;
        end
    end
    
    cp5 =  find_centerlines_tubes('S24_101_01_1a_eq_track1_CROPPED_SEGMENTED_filtered.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES',BS);
    
    for i_idx = 1:size(cp5,1)
        if cp5(i_idx,3) ~= 1
            cp5(i_idx,3) = 10*cp5(i_idx,3) - 9;
        end
    end
    
    cpts_handtracked_1 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\24mo_TSHR_13\handtracked_centerpoints.mat').list;
    cpts_handtracked_2 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S12\handtracked_centerpoints.mat').list;
    cpts_handtracked_3 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\24mo_TSHR_13\handtracked_centerpoints.mat').list;
    cpts_handtracked_4 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\14mo_TSHR_48\handtracked_centerpoints.mat').list;
    cpts_handtracked_5 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S24_101_01_1a_eq\handtracked_centerpoints.mat').list;

    dt = 500;
    
    a_cp_1 = similarity_plotter(cp1, cpts_handtracked_1, dt);
    a_cp_2 = similarity_plotter(cp2, cpts_handtracked_2, dt);
    a_cp_3 = similarity_plotter(cp3, cpts_handtracked_3, dt);
    a_cp_4 = similarity_plotter(cp4, cpts_handtracked_4, dt);
    a_cp_5 = similarity_plotter(cp5, cpts_handtracked_5, dt);
    
    accuracies = [a_cp_1, a_cp_2, a_cp_3, a_cp_4, a_cp_5];
end