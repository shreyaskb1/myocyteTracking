function [accuracy,fp_rate] = similarity_plotter(points_1, points_2, dt)
    similar = [];
    not_similar = [];

    DIST_THRESHOLD = dt;
    ctr_similar = 1;
    ctr_notsimilar = 1;
    dists = [];
    dist_ctr = 1;
    figure;

    for i_idx = 1:size(points_2,1)
        cp = points_2(i_idx,:);
        cpx = cp(1);
        cpy = cp(2);
        cpz = cp(3);

        subset = points_1;
        flag = 0;
        min_dist = 0;
        for j_idx = 1:size(subset,1)
            np = subset(j_idx,:);
            npx = np(1);
            npy = np(2);
            npz = np(3);
            dist = (npx - cpx)^2 + (npy - cpy)^2 + (npz - cpz)^2;
            if dist <= DIST_THRESHOLD
                flag = 1;
                min_dist = dist;
                break;
            end
        end

        if flag == 1
            similar(ctr_similar,:) = cp;
            ctr_similar = ctr_similar + 1;
            dists(dist_ctr) = min_dist;
            dist_ctr = dist_ctr + 1;
        else
            not_similar(ctr_notsimilar,:) = cp;
            ctr_notsimilar = ctr_notsimilar + 1;
        end
    end

    dists = [];
    
    for i_idx = 1:size(points_1,1)
        cp = points_1(i_idx,:);
        cpx = cp(1);
        cpy = cp(2);
        cpz = cp(3);

        subset = points_2;
        flag = 0;
        min_dist = 0;
        for j_idx = 1:size(subset,1)
            np = subset(j_idx,:);
            npx = np(1);
            npy = np(2);
            npz = np(3);
            dist = (npx - cpx)^2 + (npy - cpy)^2 + (npz - cpz)^2;
            if dist <= DIST_THRESHOLD
                flag = 1;
                min_dist = dist;
                break;
            end
        end

        if flag == 1
            similar_fp(ctr_similar,:) = cp;
            ctr_similar = ctr_similar + 1;
            dists(dist_ctr) = min_dist;
            dist_ctr = dist_ctr + 1;
        else
            not_similar_fp(ctr_notsimilar,:) = cp;
            ctr_notsimilar = ctr_notsimilar + 1;
        end
    end
    
    hold on;
    plot3(similar(:,1), similar(:,2), similar(:,3), 'g*');
    hold on;
    plot3(not_similar(:,1), not_similar(:,2), not_similar(:,3), 'r*');
    hold on;
    plot3(not_similar_fp(:,1), not_similar_fp(:,2), not_similar_fp(:,3), 'b*');

    accuracy = size(similar,1)/(size(similar,1)+size(not_similar,1));
    fp_rate = size(not_similar_fp,1)/(size(similar,1)+size(not_similar,1));
end
