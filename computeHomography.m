function H = computeHomography(src_pts, dest_pts)

num_itms = size(src_pts,1);
col1 = ones(num_itms,1);
cols0 = zeros(num_itms,3);

odd_rows = [src_pts col1 cols0 ...
    -dest_pts(:,1).*src_pts(:,1) ... % -x_d*x_s
    -dest_pts(:,1).*src_pts(:,2) ... % -x_d*y_s
    -dest_pts(:,1)];                 % -x_d

even_rows = [cols0 src_pts col1 ...
    -dest_pts(:,2).*src_pts(:,1) ... % -y_d*x_s
    -dest_pts(:,2).*src_pts(:,2) ... % -y_d*y_s
    -dest_pts(:,2)];                 % -y_d

A = ones(num_itms*2, 9);
A(1:2:end,:) = odd_rows;
A(2:2:end,:) = even_rows;

[V, D] = eig(A'*A); 
[small_eig, loc] = min(diag(D));
h = V(:,loc)';
H = reshape(h,[3,3])';

