folderName = 'UnionSouth';

num_pts = 10;
folder = ['./Images/' folderName '/'];

% open images and get point values
[V, E, images] = readImages(folder, 'testfile', num_pts, 'auto', true); 
num_images = size(images,4);

responseCurve = figure();
hold on;
HDR = [];

for i = 1:3 % for each channel
    % calculate camera response function using gsolve
    Z = V(:,:,i);
    ln_t = E;
    smth = 50;
    w = weighting();
    w_adj = w/max(w);
    [g,lE] = gsolve(Z,ln_t,smth,w_adj);
    adj_E = lE' + ones(num_images, num_pts) .* E';
    
        plot(adj_E, Z', '.');
        plot(g, 0:255);
    
%   recover HDR map
    HDR(:,:,i) = constructHDR(squeeze(images(:,:,i,:)), g, ln_t, w);


end
xlabel('log of incoming irradiance');
ylabel('captured intensity');
hold off;

RGB = tonemap(HDR);
local = localtonemap(single(HDR));

imwrite(RGB, [folder 'HDR/HDR.png']);
% imwrite(local, [folder 'HDR/HDR-Local-WR.png']);
saveas(responseCurve, [folder 'HDR/CameraResponseCurve.png']);

