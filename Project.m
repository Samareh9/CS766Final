function Project(folder, metadata_file, metadata_format, ...
    registration, num_pts, point_select, HDR_creation, ...
    HDR_mix_threshold, tonemap_type, output_folder, HDR_name, ...
    response_curve_save, response_curve_points)

output = [output_folder '/' HDR_name];

if registration
    output = [output '-registered'];
end

% open images and get point values
[V, E, images] = readImages(folder, metadata_file, metadata_format, ...
    num_pts, point_select, registration); 
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
    
    if response_curve_points
        plot(adj_E, Z', '.');
    end
    plot(g, 0:255);
    
%   recover HDR map
    HDR_orig(:,:,i) = constructHDR(squeeze(images(:,:,i,:)), g, ln_t, w, 'DandM');
    HDR_mod(:,:,i) = constructHDR(squeeze(images(:,:,i,:)), g, ln_t, w, 'modified');
    
    avg(:,:,i) = uint8(mean(images(:,:,i, :), 4));

end
xlabel('log of incoming irradiance');
ylabel('captured intensity');
hold off;

if strcmp(point_select, 'manual')
    output = [output '-manual'];
else
    output = [output '-auto'];
end

if ~strcmp(tonemap_type, 'local') %general or both
    RGB_orig = tonemap(HDR_orig);
    RGB_mod = tonemap(HDR_mod);
    diff = RGB_mod - RGB_orig;
    both = (diff>0) & (avg>HDR_mix_threshold);
    RGB = RGB_orig;
    RGB(both) = RGB_mod(both);
    
    if strcmp(HDR_creation, 'sat')
        imwrite(RGB_mod, [output '-local-mod.png']);
    elseif strcmp(HDR_creation, 'mix')
        imwrite(RGB, [output '-local-mix.png']);
    else %'D&M'
        imwrite(RGB_orig, [output '-local.png']);
    end
end
if ~strcmp(tonemap_type, 'general') %local or both
    local_orig = localtonemap(single(HDR_orig));
    local_mod = localtonemap(single(HDR_mod));
    diff = RGB_mod - RGB_orig;
    both = (diff>0) & (avg>HDR_mix_threshold);
    local = local_orig;
    local(both) = local_mod(both); 
    
    if strcmp(HDR_creation, 'sat')
        imwrite(local_mod, [output '-mod.png']);
    elseif strcmp(HDR_creation, 'mix')
        imwrite(local, [output '-mix.png']);
    else %'D&M'
        imwrite(local_orig, [output '.png']);
    end
end


if response_curve_save
    saveas(responseCurve, [output '-ResponseCurve.png'])
end 

close(responseCurve);
