function bw3 = WS_segmentation(segmented)
    bw = segmented;
    bw = bwareaopen(bw, 100);
    bw = imfill(bw, 'holes');
    D = -bwdist(~bw);
    Ld = watershed(D);
    bw2 = bw;
    bw2(Ld == 0) = 0;
    mask = imextendedmin(D,4);
    D2 = imimposemin(D,mask);
    Ld2 = watershed(D2);
    bw3 = bw;
    bw3(Ld2 == 0) = 0;   
end

