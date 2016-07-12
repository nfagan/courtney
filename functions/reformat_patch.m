% reformat_patch.m - function for formatting the fields of an output_patch
% struct such that every field has an equal number of rows (equivalent to
% the number of "trials" in a given patch). This way we can easily remove
% all data associated with each error trial.
%
% Run this function after running get_eyelink_start_time.m.

function store_patches = reformat_patch(start_directory)

cd(start_directory);

mat_files_dir = dir('*.mat'); store_patches = cell(length(mat_files_dir),1);

for i = 1:length(mat_files_dir)
    patch_info = load(mat_files_dir(i).name);
    patches = patch_info.output_patch;
    
    fields = fieldnames(patches);
    error_fields = fields(strncmpi(fields,'error',5));
    
    for k = 1:length(patches)
        if ~isempty(patches(k).travelBarSelectedTime);
            patches(k).('imageFileName') = patches(k).('imageFileName')';
            patches(k).('colorOrder') = patches(k).('colorOrder')'; % special cases where
                                                        % color order + image file names 
                                                        % were saved as row
                                                        % vector
            % find max number of trials, per patch
            store_lengths = zeros(1,length(fields));
            for j = 1:length(fields);
                store_lengths(j) = size(patches(k).(fields{j}),1);
            end    
            n_trials = max(store_lengths);
            for j = 1:length(fields); % make sure that all fields are the same
                                      % size, such that error indexes can
                                      % be used to remove the proper trials
                current_size = size(patches(k).(fields{j}),1);
                if current_size < n_trials
                    n_zeros_to_append = n_trials - current_size;
                    if ~iscell(patches(k).(fields{j}));
                        patches(k).(fields{j})(current_size+1:current_size+n_zeros_to_append,:) = 0;
                    else
                        patches(k).(fields{j})(current_size+1:current_size+n_zeros_to_append,:) = {'0'};
                    end
                end
            end
            all_errors = false(n_trials,length(error_fields));
            for j = 1:length(error_fields)
                all_errors(:,j) = patches(k).(error_fields{j})(:,1);
            end
            all_errors = sum(all_errors,2) >= 1;
            patches(k).all_errors = all_errors;
        end
    end
    check_empty = cellfun('isempty',{patches(:).travelBarSelectedTime})';
    patches(check_empty) = [];
    store_patches{i} = patches;
end

store_patches = cellfun(@(x) add_expressions(x),store_patches,'UniformOutput',false);


