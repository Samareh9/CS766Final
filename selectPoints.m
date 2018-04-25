function point_locs = selectPoints(num_pts, img)

imshow(img./255);
[x,y] = ginput(num_pts);
title(['Select ' num_pts ' points that vary in brighness']);

point_locs = round(sub2ind(size(img), y, x));