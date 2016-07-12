%% adds eye-link start time to output_patch struct
% patch_directory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/pilot_data/outputpatchtest/fixed_patch_files';
% base_directory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/pilot_data/outputpatchtest';
base_directory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/testing_image_separation';
get_eyelink_start_time(base_directory);

%% load in and format patches + other data

base_directory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/testing_image_separation';
patch_directory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/testing_image_separation/fixed_patch_files';

[allLabels,allTimes,allEvents,id] = getFiles(fullfile(base_directory,'excel_files'));
store_patches = reformat_patch(patch_directory);
fixed_patches = cellfun(@(x) get_image_indices(x),store_patches,'UniformOutput',false);

%% separate by expressions, valences, travel delays

trialTypes.expressions = 'all';
trialTypes.valence = 'all';
trialTypes.travelDelay = 'all'; 

outputs = cellfun(@(x) get_wanted_times(x,trialTypes),fixed_patches,'UniformOutput',false);

empty_index = cellfun(@(x) isempty(x),outputs);
outputs(empty_index) = []; allEvents(empty_index) = [];

wantedTimes = cellfun(@(x) x(:,1:2),outputs,'UniformOutput',false)';
%% correlation

travel_delays = concatenateData(cellfun(@(x) x(:,4),outputs,'UniformOutput',false));
patch_res = concatenateData(cellfun(@(x) (x(:,2) - x(:,1)),outputs,'UniformOutput',false));

[rho,p] = corr(travel_delays,patch_res);
scatter(travel_delays,patch_res);

%%

all_orders = concatenateData(cellfun(@(x) get_targ_order(x),outputs,'UniformOutput',false));
targPercent(all_orders);

%%

data = getDur2(wantedTimes,allEvents);
binned = get_binned_fix_counts(data,100);

