


num_pts = 10;

% manually select points in image
% locs = selectPoints(num_pts,'img0065.ppm');

% open images and get point values
[V, E, images] = readImages('testfile', locs);
num_images = size(images,4);

%     figure();
%     hold on
%     plot(V, E, 'o');
%     hold off


figure();
hold on;

for i = 1:3 % for each channel
    % calculate camera response function using gsolve
    Z = V(:,:,i);
    ln_t = E;
    smth = 50;
    w = weighting();
    w_adj = w/max(w);
    [g,lE] = gsolve(Z,ln_t,smth,w_adj);
    adj_E = lE' + ones(num_images, num_pts) .* E';

        plot(g, 0:255);
%         plot(adj_E, Z', 'o');
    
%   recover HDR map
    HDR(:,:,i) = constructHDR(squeeze(images(:,:,i,:)), g, ln_t, w);


end
hold off;

RGB = tonemap(HDR);

figure();
imshow(RGB);