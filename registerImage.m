% function registered_IMG = registerImage(fixed, adjust)

[xs, xd] = genSIFTMatches(img, mi);
ransac_n = 20; % Max number of iterations
ransac_eps = 3; % Acceptable alignment error 
[inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

nr = size(img, 1);
nc = size(img, 2);

[mask, warped_img] = backwardWarpImg(double(img), inv(H_3x3), [nc, nr]);
