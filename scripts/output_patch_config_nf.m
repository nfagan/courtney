%% SEC 1: adds eye-link start time to output_patch struct
% patch_directory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/pilot_data/outputpatchtest/fixed_patch_files';
% base_directory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/pilot_data/outputpatchtest';
% base_directory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/testing_image_separation';
base_directory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/social_control_data';
get_eyelink_start_time(base_directory);

%% SEC 2: load in and format patches + other data

% base_directory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/testing_image_separation';
base_directory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/social_control_data';
patch_directory = fullfile(base_directory,'fixed_patch_files');
excel_directory = fullfile(base_directory,'excel_files');

[allLabels,allTimes,allEvents,id] = getFiles(excel_directory);
store_patches = reformat_patch(patch_directory);
fixed_patches = cellfun(@(x) get_image_indices(x),store_patches,'UniformOutput',false);

%% SEC 3: separate by expressions, valences, travel delays

trialTypes.expressions = 'all';     % {'neutral', 'threat', 'fear', 'affil'} | 'all'
trialTypes.valence = 'all';         % [1,2] | 'all'
trialTypes.travelDelay = 'all';     % [.5, 1 ...] | 'all'

outputs = cellfun(@(x) get_wanted_times(x,trialTypes),fixed_patches,'UniformOutput',false);

empty_index = cellfun(@(x) isempty(x),outputs);
outputs(empty_index) = []; allEvents(empty_index) = [];

wantedTimes = cellfun(@(x) x(:,1:2),outputs,'UniformOutput',false)';
%% SEC 4: correlation b/w travel delay duration and patch residence time

travel_delays = concatenateData(cellfun(@(x) x(:,4),outputs,'UniformOutput',false));
patch_res = concatenateData(cellfun(@(x) (x(:,2) - x(:,1)),outputs,'UniformOutput',false));

[rho,p] = corr(travel_delays,patch_res);
scatter(travel_delays,patch_res);

%% SEC 5: order of target selection in a patch

orders_outputs = cellfun(@(x) get_targ_colors(x),store_patches,'UniformOutput',false);

all_orders = concatenateData(cellfun(@(x) get_targ_order(x),orders_outputs,'UniformOutput',false));
targPercent(all_orders);

%%

data = getDur2(wantedTimes,allEvents);
binned = get_binned_fix_counts(data,100);

