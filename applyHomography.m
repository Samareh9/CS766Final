function dest_pts = applyHomography(H, test_pts)

ones_col = ones(size(test_pts,1),1);

new_pts_tilde = H*[test_pts ones_col]';
new_pts = bsxfun(@rdivide, new_pts_tilde, new_pts_tilde(end, :));
dest_pts = new_pts(1:2,1:end)';