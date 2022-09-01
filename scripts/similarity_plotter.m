function [accuracy,fp_rate] = similarity_plotter(points_1, points_2, dt_1, dt_2, flag_plot)
    similar = [];
    not_similar = [];

    DIST_THRESHOLD = dt_1;
    ctr_similar = 1;
    ctr_notsimilar = 1;
    dists = [];
    dist_ctr = 1;

    subset_1 = points_1;
    subset_2 = points_2;
    for i_idx = 1:size(subset_2,1)
        cp = subset_2(i_idx,:);
        cpx = cp(1);
        cpy = cp(2);
        cpz = cp(3);

        flag = 0;
        min_dist = 0;
        min_point_index = -1;
        for j_idx = 1:size(subset_1,1)
            np = subset_1(j_idx,:);
            npx = np(1);
            npy = np(2);
            npz = np(3);
            dist = (npx - cpx)^2 + (npy - cpy)^2 + (npz - cpz)^2;
            if dist <= DIST_THRESHOLD
                flag = 1;
                min_dist = dist;
                min_point_index = j_idx;
                break;
            end
        end

        if flag == 1
            similar(ctr_similar,:) = cp;
            ctr_similar = ctr_similar + 1;
            dists(dist_ctr) = min_dist;
            dist_ctr = dist_ctr + 1;
            subset_1(min_point_index,:) = [];
        else
            not_similar(ctr_notsimilar,:) = cp;
            ctr_notsimilar = ctr_notsimilar + 1;
        end
    end

    DIST_THRESHOLD = dt_2;
    dists = [];
    similar_fp = [];
    not_similar_fp = [];
    ctr_similar = 1;
    ctr_notsimilar = 1;
    
    subset_1 = points_1;
    subset_2 = points_2;
    
    for i_idx = 1:size(subset_1,1)
        cp = subset_1(i_idx,:);
        cpx = cp(1);
        cpy = cp(2);
        cpz = cp(3);

        flag = 0;
        min_dist = 0;
        min_point_index = -1;
        for j_idx = 1:size(subset_2,1)
            np = subset_2(j_idx,:);
            npx = np(1);
            npy = np(2);
            npz = np(3);
            dist = (npx - cpx)^2 + (npy - cpy)^2 + (npz - cpz)^2;
            if dist <= DIST_THRESHOLD
                flag = 1;
                min_dist = dist;
                min_point_index = j_idx;
                break;
            end
        end

        if flag == 1
            similar_fp(ctr_similar,:) = cp;
            ctr_similar = ctr_similar + 1;
            dists(dist_ctr) = min_dist;
            dist_ctr = dist_ctr + 1;
            subset_2(min_point_index,:) = [];
        else
            not_similar_fp(ctr_notsimilar,:) = cp;
            ctr_notsimilar = ctr_notsimilar + 1;
        end
    end

    if flag_plot == 1
        figure;
        hold on;
        if size(similar,1) > 0
            plot3(similar(:,1), similar(:,2), similar(:,3), 'g*', 'MarkerSize', 6);
        end
        hold on;
        if size(not_similar,1) > 0
            plot3(not_similar(:,1), not_similar(:,2), not_similar(:,3), 'r*', 'MarkerSize', 6);
        end
        hold on;
        if size(not_similar_fp,1) > 0
            plot3(not_similar_fp(:,1), not_similar_fp(:,2), not_similar_fp(:,3), 'b*', 'MarkerSize', 6);
        end
    end
    accuracy = size(similar,1)/(size(similar,1)+size(not_similar,1));
    fp_rate = size(not_similar_fp,1)/(size(similar_fp,1)+size(not_similar_fp,1));
end
