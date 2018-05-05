function [mask, dest_img] = backwardWarpImg(src_img, dest_to_src_homography, ...
dest_canvas_width_height)

row_max = dest_canvas_width_height(2);
col_max = dest_canvas_width_height(1);



dest_pts_vector = [repmat(1:col_max,1,row_max);  ...
    reshape(repmat(1:row_max, col_max, 1), [1 row_max*col_max]); ...
    ones(1, row_max*col_max)];

post_homog = dest_to_src_homography*dest_pts_vector;
post_norm = bsxfun(@rdivide, post_homog, post_homog(end, :));

X = 1:size(src_img,2);
Y = 1:size(src_img,1);
dest_img = zeros(row_max, col_max, 3);

for i = 1:3     % for each color
    V = src_img(:,:,i);
    Xq = reshape(post_norm(1,:), [col_max, row_max])';
    Yq = reshape(post_norm(2,:), [col_max, row_max])';
    Vq = interp2(X,Y,V,Xq,Yq);
    dest_img(:,:,i) = Vq;
end

mask = ~isnan(dest_img(:,:,1));

dest_img(isnan(dest_img)) = 0;