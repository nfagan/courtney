% get_image_indices.m - function for reformatting the image presentation
% times such that they are in terms of eyelink time. 
%
% Run after running get_eyelink_start_time.m AND reformat_patch.m, and run 
% in a cellfun like this: all_outputs = cellfun(@(x) ...
% get_image_indices(patches),store_patches,'UniformOutput',false)

function fixed_patches = get_image_indices(patches)

first_image_time_patch = patches(1).imageDisplayedTime(1);

fixed_patches = patches;
for k = 1:length(patches)
    image_times = patches(k).imageDisplayedTime;
    image_times(:,2) = patches(k).travelBarSelectedTime;
%     valences = patches(k).imageValence(:,1);
    valences = patches(k).targetColor;
    travel_delays = patches(k).travelDelayDuration(:,1);
    expressions = patches(k).expression_names;
    
    all_errors = patches(k).all_errors;
    image_not_displayed_errors = image_times(:,1) == 0;
    all_errors = all_errors | image_not_displayed_errors;
    
    image_times(all_errors,:) = [];
    valences(all_errors,:) = [];
    travel_delays(all_errors,:) = [];
    expressions(all_errors,:) = [];
    
    
%     image_times(all_errors | image_times(:,1) == 0,:) = [];
%     valences(all_errors | valences == 0,:) = [];
%     travel_delays(all_errors | travel_delays == 0,:) = [];
%     expressions(all_errors | strcmp(expressions,'0')) = [];
    
    first_image_time_eyelink = patches(k).first_image_time(1);
    fixed_image_times = arrayfun(@(x) (first_image_time_eyelink + (x-first_image_time_patch)*1000),...
        image_times);

    n_images = size(travel_delays,1);
%     n_images = size(fixed_image_times,1);   % some patches end prematurely -- only include
                                            % data for which there is are
                                            % associated decision times
                                            
    fixed_patches(k).imageDisplayedTime = fixed_image_times(1:n_images,:);
    fixed_patches(k).imageValence = valences(1:n_images,:);
    fixed_patches(k).travelDelayDuration = travel_delays(1:n_images,:);
    fixed_patches(k).expressions = expressions(1:n_images,:);
    
end

