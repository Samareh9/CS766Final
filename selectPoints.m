function point_locs = selectPoints(num_pts, img_name)

img = imread(img_name);
imshow(img);
[x,y] = ginput(num_pts);

point_locs = round(sub2ind(size(img), y, x));