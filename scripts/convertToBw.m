
% to fix some image conversion problem between tif and binary image
function bw_img = convertToBw(x)
    x(find(x==1))=0;
    x(find(x==2))=1;
    x = ~im2bw(x, 0);
    bw_img = x;
end

