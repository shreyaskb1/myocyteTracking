function img = preProcess(curr_img, circ, area_min, area_max)
    labeledImage = bwlabel(curr_img);
    st=regionprops(labeledImage,'area','Perimeter');
    % Get areas and perimeters of all the regions into single arrays.
    allAreas = [st.Area];
    allPerimeters = [st.Perimeter];
    % Compute circularities.
    circularities = allPerimeters.^2 ./ (4*pi*allAreas);
    circularities = 1./circularities;
    
    % Find objects that have "round" values of circularities.
    roundObjects = find(circularities > circ); % Whatever value you want.
    % Compute new binary image with only the round objects in it.
    binaryImage = ismember(labeledImage, roundObjects) > 0;
    img = binaryImage;
    
end
