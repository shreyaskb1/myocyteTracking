function [] = plot_S12()
    points = load('S12_points.mat').S12_points;
    [c_1, c_2] = get_cells();
    figure;
    for i=1:size(c_1,1)
        plot_cells_1(c_1(i,1), c_1(i,2), points);
    end
   
    for i=1:size(c_2,1)
        plot_cells_2(c_2(i,1), c_2(i,2), c_2(i, 3), points);
    end
    
    plot3([points(48,2), points(50,2)], [points(48,3), points(50,3)], [points(48,4), points(50,4)]);
    plot3([points(50,2), points(52,2)], [points(50,3), points(52,3)], [points(50,4), points(52,4)]);
    plot_cells_1(52, 56, points);
    
    plot_cells_1(367, 376, points);
    plot_cells_1(378, 379, points);
    plot_cells_1(381, 381, points);
 
    plot3([points(376,2), points(378,2)], [points(376,3), points(378,3)], [points(376,4), points(378,4)]);
    plot3([points(379,2), points(381,2)], [points(379,3), points(381,3)], [points(379,4), points(381,4)]);

    branchpoints = get_branchpoints();
    plot_bpts(branchpoints, points);
    
end


function [] = plot_cells_1 (startpt, endpt, points) 
    for i=startpt:endpt-1
        x = [points(i, 2), points(i+1, 2)];
        y = [points(i, 3), points(i+1, 3)];
        z = [points(i, 4) , points(i+1, 4)];
        plot3(x, y, z, "Color", "b");
        
        hold on;
    end
end

function [] = plot_cells_2 (startpt, midpt, endpt, points)
    x1 = points(startpt, :);
    x2 = points(midpt, :);
    line([x1(2), x2(2)],[x1(3), x2(3)],[x1(4), x2(4)]);    
    hold on;
    plot_cells_1(midpt, endpt, points);
end

function [] = plot_bpts(bpts, points)
    for i = 1:size(bpts,1)
        x1 = points(bpts(i,1), :);
        plot3(x1(2), x1(3), x1(4), 'ro');
        x2 = points(bpts(i,2), :);
        x3 = points(bpts(i,3), :);
        line([x2(2), x3(2)],[x2(3), x3(3)],[x2(4), x3(4)]);
    end
    
end

function [cells_1, cells_2] = get_cells()
cells_1 = [1, 23
;25, 38
;40, 47
;60,64
;65,76
;102,127
;128,153
;154,179
;180,185
;212,217
;218,225
;226,236
;237,240
;241,244
;245,258
;265,270
;271,286
;287,290
;294,296 
;297,309
;309,312
;314,317
;319,339
;341,366
;390,404
;405,423
;424,431
;432,436
;438,454
;455,464
;465,474
;475,500
;502,521
;522,542
;543,554
;556,581
;582,591
;592,608
;609,625
;626,627
;630,632
;634,659
;661,663
;664,673
;675,693
;694,701
;702,703
;705,717
;719,735
;737,742
;743,769
;771,780
;781,803
;806,809
;811,828
;829,837
;839,846
;847,850
;852,877
;878,888
;891,906
;908,920
;922,946
;949,952
;954,979];

cells_2 = [
49, 57, 58
;77, 79, 89
;39, 90, 98
;24, 99, 101
;186, 188, 207
;187, 208, 211
;78, 259, 264];

end

function branchpoints = get_branchpoints()
branchpoints = [24, 23, 98;
39, 38,56;
47, 48,49;
51, 292,50;
59, 58,71;
64, 65,66;
76, 77,78;
185, 186,187;
217, 265,218;
225, 226,245;
236, 237,241;
264, 263,233;
270, 271,287;
291, 290,227;
293, 292,162;
296, 311,297;
310, 247,309;
313, 215,312;
318, 298,317;
340, 339,361;
377, 211,376;
380, 379,390;
389, 201,388;
423, 424,432;
437, 176,436;
454, 455,465;
501, 411,502;
555, 554,390;
591, 609,592;
628, 610,627;
629, 609,626;
633, 584,632;
660, 657,661;
674, 673,674;
704, 695,703;
718, 417,717;
736, 512,735;
743, 742,587;
770, 760,771;
804, 803,605;
805, 806,330;
810, 809,795;
828, 829,839;
851, 814,850;
889, 888,821;
890, 818,891;
907, 906,843;
921, 896,920;
947, 946,365;
948, 943,949;
953, 952,662];
end