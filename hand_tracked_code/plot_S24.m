function [] = plot_S24()
    points = load('S24_points.mat').y;
    cells = get_cells();
    bpts = get_bpts();
    
    figure;
    for i=1:size(cells,1)
        plot_cells_1(cells(i,1), cells(i,2), points);
    end
    
    plot_bpts(bpts, points);
    
end

function [] = plot_cells_1 (startpt, endpt, points) 
    for i=startpt:endpt-1
        x = [points(i, 1), points(i+1, 1)];
        y = [points(i, 2), points(i+1, 2)];
        z = [points(i, 3) , points(i+1, 3)];
        plot3(x, y, z, "Color", "b");
        
        hold on;
    end
end

function [] = plot_bpts(bpts, points)
    for i = 1:size(bpts,1)
        x1 = points(bpts(i,1), :);
        plot3(x1(1), x1(2), x1(3), 'ro');
        x2 = points(bpts(i,2), :);
        x3 = points(bpts(i,3), :);
        line([x2(1), x3(1)],[x2(2), x3(2)],[x2(3), x3(3)]);
        hold on;
    end
    
end

function cells = get_cells()
cells = [
1,5
6,23
24,27
28,31
32,44
45,53
54,62
64,66
68,78
80,95
96,105
106,115
116,122
123,128
130,148
149,173
174,198
200,219
220,244
246,261
262,286
287,311
313,333
334,358
359,379
381,395
396,406
407,411
413,437
439,448
450,464
465,475
476,486
487,511
512,517
518,537
538,557
558,571
572,583
584,595
596,597
599,623
624,640
642,655
656,664
666,677
678,702
703,727
728,746
747,750
752,754
756,780
782,792
794,796
797,805
807,831
832,836
837,843
844,857
858,869
872,891
892,898
900,924
925,940
942,946
948,958
959,973
974,988
989,1013
1014,1038
1039,1063
1064,1079
1081,1103
1105,1119
1122,1134];
end

function bpts = get_bpts()
bpts = [5, 6, 32
23, 24,28
44, 54,45
63, 48,64
67, 66,59
79, 38,78
95, 96,106
122, 130,123
129, 91,128
199, 179,200
200, 221,218
245, 126,246
312, 291,313
380, 379,282
395, 407,396
412, 411,213
438, 439,424
449, 448,433
464, 476,465
517, 518,538
598, 585, 597
641, 640, 574
655, 656, 666
665, 355,664
746, 747,752
751, 724,750
755, 698,754
781, 782,770
793, 790,794
806, 764,805
843, 844,858
870, 869,794
871, 872,837
899, 813,898
941, 915,940
947, 929,946
958, 959,974
1080, 1079,668
1104, 1103,509
1120, 1119,1095
1121, 1122,1117];
end