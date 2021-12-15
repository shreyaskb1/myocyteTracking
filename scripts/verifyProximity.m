ctr = 1;
data = [];
distances = [];
dist_ctr = 1;

for i_idx = 9:10:799
    curr_slice_automatic = automatic(automatic(:,3)==i_idx,:);
    curr_slice_manual = manual(manual(:,3) == i_idx,:);
    sz_a = size(curr_slice_automatic, 1);
    sz_m = size(curr_slice_manual,1);
    num_captured = 0;
    if sz_a > 0 && sz_m > 0
        flag = 0;
        for j_idx = 1:sz_a
            curr_pt_a = curr_slice_automatic(j_idx,:);
            for k_idx = 1:size(curr_slice_manual,1)
                curr_pt_m = curr_slice_manual(k_idx,:);
                dist = (curr_pt_a(1) - curr_pt_m(1))^2 + (curr_pt_a(2) - curr_pt_m(2))^2;
                if dist < 400
                    num_captured = num_captured + 1;
                    distances(dist_ctr) = dist;
                    dist_ctr = dist_ctr + 1;
                    curr_slice_manual(k_idx,:) = [];
                    break;
                end
            end
        end
        str = sprintf("Num captured were %d out of total %d cells in slice %d", num_captured, sz_m, i_idx);
        if num_captured > -1
            disp(str);
            data(ctr,:) = [num_captured, sz_m, i_idx];
            ctr = ctr + 1;
        end
    end
end

x = 2;