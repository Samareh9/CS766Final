% BEFORE RUNNING
% Before running your code:
%  1. Place all the relevantimages in one folder.  
%  2. Create a metadata file in that folder that lists the images by name, 
%     followed by the shutter speed x,  where 1/x is the amount of time
%     the shutter is open (e.g. 0.5 means 2 seconds and 2 means 1/2 second).
%  3. Change the following settings change the following settings

% SETTINGS

% Name of folder with images
folder_name = 'House';

% Relative path to the folder with images
folder = ['./Images/' folder_name '/'];

% Metadata file name that contains shutter speeds
metadata_file = 'testfile';

% Metadata file format for each line
%  %s = string
%  %f = double
% metadata_format = '%s %f %f %d %d'; <- this one is for the Church photos
metadata_format = '%s %f';

% Image Registration required?
%  true : select this if the images don't line up.
%  false : select this if the images already line up.  It's faster.
registration = false;

% Number of sample points
%  The greater the number of points, the more accuate, but the longer it
%  takes to manually select.  
point_num = 30;

% Point Selection
%  'auto' : automatic point selection
%  'manual' : select points by hand
point_select = 'auto';

% Type of tonemapping
%  'general' - uses tonemap() function
%  'local' - uses localTonemap() function
%  'both' - saves a copy of both
tonemap_type = 'both';

% HDR creation method
%  'D&M' = uses method proposed by Debevec & Malik.  Recommended
%  'sat' = uses modified method that avoids artifacts that appear due to
%           pixels that are saturated across all shutter speeds - think
%           sun in the picture.  Does lead to a flatter looking image
%  'mix' = attempts to preserve the higher saturation of 'D&M' while
%           using 'sat' for the saturated areas
HDR_creation = 'D&M';

% IF USING 'mix' HDR CREATION METHOD:  (if not, this value is not used)
%  Threshold for brighness above which the difference will be used to
%  replace 'D&M' pixels with 'sat' pixels.
HDR_mix_threshold = 230;

% Location to save final images
output_folder = [folder 'output'];

% Final image base name
HDR_name = 'HDR';

% Save a copy of the camera response curve?
response_curve_save = true;

% IF SAVING A COPY OF THE RESPONSE CURVE
% Show points that contributed to its estimation on the curve?
response_curve_points = true;


% CALL TO PROJECT METHOD - DO NOT CHANGE BELOW THIS LINE
mkdir_if_not_exist(output_folder);

Project(folder, metadata_file, metadata_format, ...
    registration, point_num, point_select, HDR_creation, ...
    HDR_mix_threshold, tonemap_type, output_folder, HDR_name, ...
    response_curve_save, response_curve_points);