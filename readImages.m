function [V, E, images] = readImages(folder, file_name, format, num_pts, method, register)

% read in the testile info
% formatSpec = '%s %f %f %d %d';
data = readtable([folder file_name], 'Delimiter', ' ', 'Format', format);
img_names = char(data{:,1});

% [optimizer, metric] = imregconfig('multimodal');

ransac_n = 30; % Max number of iterations
ransac_eps = 5; % Acceptable alignment error 

bw_images = [];
% read each image and gather needed data
for i = 1:size(img_names, 1) % for each image
    img = rgb2gray(imread([folder img_names(i,:)])); 
    bw_images(:,:,i) = img;
end

means = mean(mean(bw_images));
goal = (max(means)+min(means))/2;
[~,i] = min(abs(means-goal));

med_imgs = double(rgb2gray(imread([folder img_names(i,:)])));
mi_idx = i;

locs = [];
if strcmp(method, 'manual')
    locs = selectPoints(num_pts, med_imgs);
else
    w1 = round(size(med_imgs, 1)/num_pts);
    w2 = round(size(med_imgs, 2)/num_pts);

    for j = 1:2
        if j == 1
            np = ceil(num_pts/2);
        else
            np = floor(num_pts/2);
            med_imgs = mean(bw_images, 3);
        end
        
        min_val = min(min(med_imgs));
        max_val = max(max(med_imgs));
        step = (max_val-min_val)/(np-1);

        for i = min_val:step:max_val
            diff = abs(med_imgs-i);
            M = min(diff(:));
            I = find(diff == M);
            locs = [locs I(round(size(I, 1)/2))];
            [y,x] = ind2sub(size(med_imgs), I);
            med_imgs(max(y-w1,1):min(y+w1, size(med_imgs,1)), max(x-w2, 1):min(x+w2, size(med_imgs,2))) = 0;
        end
    end
end

V = [];
E = [];
images = uint8([]);


% read each image and gather needed data
for i = [mi_idx:size(img_names,1) mi_idx-1:-1:1] % for each image
    
    if i == mi_idx || i == mi_idx-1
        mi = imread([folder img_names(mi_idx,:)]);
    end
    
    exp = 1./data{i,2};
    log_exp = log(exp);
    img = imread([folder img_names(i,:)]);
    
    if register
        [xs, xd] = genSIFTMatches(img, mi);
        [~, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

        nr = size(img, 1);
        nc = size(img, 2);

        [~, warped_img] = backwardWarpImg(double(img), inv(H_3x3), [nc, nr]);
        images(:,:,:,i) = uint8(warped_img);
    else
        images(:,:,:,i) = img;
    end
        
    E(i) = log_exp;
    for c = 1:3             % for each channel

        reg = images(:,:,c,i);
        vals = reg(locs);
        V(:,i,c) = vals;
    end
%      figure();
%     imshowpair(images(:,:,:,i), mi, 'blend');

     mi = images(:,:,:,i);
end

