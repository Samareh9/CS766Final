function [V, E, images] = readImages(file_name, point_locs)

% read in the testile info
formatSpec = '%s %f %f %d %d';
data = readtable(file_name, 'Delimiter', ' ', 'Format', formatSpec);
img_names = char(data{:,1});

V = [];
E = [];
images = [];

% read each image and gather needed data
for i = 1:length(img_names) % for each image
    exp = 1./data{i,2};
    log_exp = log(exp);
    img = imread(img_names(i,:));
    images(:,:,:,i) = img;
    E(i) = log_exp;
    for c = 1:3             % for each channel
        img_ch = img(:,:,c);
        vals = img_ch(point_locs);
        V(:,i,c) = vals;
        
%         E = [E;log_exp];
%         V = [V;vals'];
    end
end