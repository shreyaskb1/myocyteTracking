function batch_optimize_parameters
    dt_1 = 900;
    dt_2 = 400;
    accs = [];
    fprs = [];
    cpts_handtracked_1 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\24mo_TSHR_13\handtracked_centerpoints.mat').list;
    idx = 1;
    hts = 2:5:50;
    for ht=2:5:50
        [pts_1, bpts_1] = find_centerlines_1_toy('24mo_TSHR_13_SEGMENTED_filtered.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES', 8, ht);
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
        [accuracy_cp_1, cpfpr_1] = similarity_plotter(pts_1, cpts_handtracked_1, dt_1, dt_2, 1);
        accs(idx) = accuracy_cp_1;
        fprs(idx) = cpfpr_1;
        idx = idx+1;
    end
    figure;
    plot(hts,accs, 'r');
    legend('Accuracy');
    figure;
    plot(hts,fprs, 'b');
    legend('False Positive Rate');

end