%% adds eye-link start time to output_patch struct

base_directory = '/Users/court/Documents/MATLAB/EDF2Mat/DataJodo/Valence/output_patch';
get_eyelink_start_time(base_directory);

%% gets all info associated with each file

patch_directory = '/Users/court/Documents/MATLAB/EDF2Mat/DataJodo/Valence/output_patch/fixed_patch_files';
[allLabels,allTimes,allEvents,id] = getFiles(fullfile(base_directory,'excel_files'));

store_patches = reformat_patch(patch_directory);
outputs = cellfun(@(x) get_image_indices(x),store_patches,'UniformOutput',false);
wantedTimes = cellfun(@(x) round(x(:,1:2)),outputs,'UniformOutput',false);

%% if separating by valence
image_type = 1; %1 for neg, 2 for pos
wantedTimes = cellfun(@(x) x(x(:,3) == image_type,1:2),outputs,'UniformOutput',false);

%% check correlation b/w travel delay duration and patch residence time
 
travel_delays = concatenateData(cellfun(@(x) x(:,4),outputs,'UniformOutput',false));
patch_res = concatenateData(cellfun(@(x) (x(:,2) - x(:,1)),outputs,'UniformOutput',false));

[rho,p] = corr(travel_delays,patch_res);

%%

all_orders = concatenateData(cellfun(@(x) get_targ_order(x),outputs,'UniformOutput',false));
targPercent(all_orders);



