% plotting 24mo_TSHR_13, same as plot 3
bs = 50;
ht = 7;
[pts_1, bpts_1] = find_centerlines_1_toy('24mo_TSHR_13_tracking_SEGMENTED_FULL.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES', bs, ht);

% plotting S12_tracking
bs = 50;
ht = 6;
[pts_2, bpts_2] = find_centerlines_1_toy('S12_tracking_SEGMENTED_FULL.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES', bs, ht);

% plotting 14mo_TSHR_48
bs = 50;
ht = 5;
[pts_4, bpts_4] = find_centerlines_1_toy('14mo_TSHR_48_tracking_SEGMENTED_FULL.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES', bs, ht);

% plotting S24_101_01_1a_eq_track1
bs = 50;
ht = 5;
[pts_5, bpts_5] = find_centerlines_1_toy('S24_101_01_1a_eq_track1_CROPPED_SEGMENTED_FULL.tif', 'C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\images\TRACKING_IMAGES', bs, ht);

cpts_handtracked_1 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\24mo_TSHR_13\handtracked_centerpoints.mat').list;
bpts_handtracked_1 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\24mo_TSHR_13\handtracked_branchpoints.mat').all_bps_coords;

cpts_handtracked_2 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S12\handtracked_centerpoints.mat').list;
bpts_handtracked_2 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S12\handtracked_branchpoints.mat').all_bps_coords;

% plot 4
cpts_handtracked_4 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\14mo_TSHR_48\handtracked_centerpoints.mat').list;
bpts_handtracked_4 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\14mo_TSHR_48\handtracked_branchpoints.mat').all_bps_coords;


cpts_handtracked_5 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S24_101_01_1a_eq\handtracked_centerpoints.mat').list;
bpts_handtracked_5 = load('C:\Users\Shreyas Bharadwaj\Documents\REUProject\REU Project\results\S24_101_01_1a_eq\handtracked_branchpoints.mat').all_bps_coords;


% comparison of all center points
t1 = 850;
t2 = 200;
[acc, fpr] = similarity_with_interpolation(pts_1, cpts_handtracked_1, t1, t2)

t1 = 700;
t2 = 100;
[acc, fpr] = similarity_with_interpolation(pts_2, cpts_handtracked_2, t1, t2)

t1 = 700;
t2 = 100;
[acc, fpr] = similarity_with_interpolation(pts_4, cpts_handtracked_4, t1, t2)

t1 = 850;
t2 = 100;
[acc, fpr] = similarity_with_interpolation(pts_5, cpts_handtracked_5, t1, t2)

