%% adds eye-link start time to output_patch struct

base_directory = '/Users/court/Documents/MATLAB/EDF2Mat/DataJodo/Valence/output_patch';
get_eyelink_start_time(base_directory);

%% gets all info associated with each file

patch_directory = '/Users/court/Documents/MATLAB/EDF2Mat/DataJodo/Valence/output_patch/fixed_patch_files';
[allLabels,allTimes,allEvents,id] = getFiles(fullfile(base_directory,'excel_files'));

store_patches = reformat_patch(patch_directory);
outputs = cellfun(@(x) get_image_indices(x),store_patches,'UniformOutput',false);
wantedTimes = cellfun(@(x) round(x(:,1:2)),outputs,'UniformOutput',false);

%%
patch_directory = '/Users/court/Documents/MATLAB/EDF2Mat/DataJodo/Valence/output_patch/fixed_patch_files';
base_directory = '/Users/court/Documents/MATLAB/EDF2Mat/DataJodo/Valence/output_patch';
[allLabels,allTimes,allEvents,id] = getFiles(fullfile(base_directory,'excel_files'));

store_patches = reformat_patch(patch_directory);
fixed_patches = cellfun(@(x) get_image_indices(x),store_patches,'UniformOutput',false);

trialTypes.expressions = {'affil'}; %neutral, threat, fear, affil
trialTypes.valence = [2];

[image_times,~,outputs] = cellfun(@(x) get_wanted_times(x,trialTypes),fixed_patches,'UniformOutput',false);
empty_index = cellfun(@(x) isempty(x),image_times);
image_times(empty_index) = []; allLabels(empty_index) = [];

%% check correlation b/w travel delay duration and patch residence time
 
travel_delays = concatenateData(cellfun(@(x) x(:,4),outputs,'UniformOutput',false));
patch_res = concatenateData(cellfun(@(x) (x(:,2) - x(:,1)),outputs,'UniformOutput',false));

[rho,p] = corr(travel_delays,patch_res);
scatter(travel_delays,patch_res);

%%

all_orders = concatenateData(cellfun(@(x) get_targ_order(x),outputs,'UniformOutput',false));
targPercent(all_orders);

%% 

for i=  1:length(fixed_patches)
    [image_times,~,outputs] = get_wanted_times(fixed_patches{i},trialTypes);
end



