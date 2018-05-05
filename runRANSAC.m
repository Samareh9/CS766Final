function [inliers_id, src_to_dest_H]= runRANSAC(src_pt, dest_pt, ransac_n, ransac_eps)

matched_pts = [src_pt dest_pt];

best_inlier_count = 0;


for i = 1:ransac_n
    s = datasample(matched_pts, 4, 'Replace', false);
    H = computeHomography(s(:, 1:2), s(:, 3:4));
    exp_pt = applyHomography(H, src_pt);
    err = sum(abs(dest_pt - exp_pt), 2);
    inliers = err < ransac_eps;
    num_inliers = sum(inliers);
    if num_inliers > best_inlier_count
        best_inlier_count = num_inliers;
        src_to_dest_H = H;
        inliers_id = find(inliers == 1);
    end
end