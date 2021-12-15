function outputImg = floorNoiseRemoval(imgName, idx)
    MARGIN = 5;
    outputImg = logical(ones(800,800));
    for k_idx = max(1, idx - MARGIN):min(idx+MARGIN, 500)
        curr_image = imbinarize(imread(imgName, idx));
        outputImg = outputImg.*curr_image;
    end
end

