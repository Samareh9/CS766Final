function result_img = showCorrespondence(src_img, dest_img, src_pts, dest_pts)

fh = figure();
axis off;
imagesc([src_img dest_img]);

w = size(src_img, 2);
src_dest_x = [src_pts(:,1) dest_pts(:,1)+w]';
src_dest_y = [src_pts(:,2) dest_pts(:,2)]';

hold on;
plot(src_dest_x, src_dest_y, 'r');
hold off;

result_img = saveAnnotatedImg(fh);

delete(fh);