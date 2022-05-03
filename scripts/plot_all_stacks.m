close all;
clear;

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
