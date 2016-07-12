function store_patches = reformat_patch(start_directory)

cd(start_directory);
mat_files_dir = remDir(dir('*.mat')); 
store_patches = cell(length(mat_files_dir),1);

for i = 1:length(mat_files_dir)
    patch_info = load(mat_files_dir(i).name);
    patches = patch_info.output_patch;
    
    fields = fieldnames(patches);
    error_fields = fields(strncmpi(fields,'error',5));
    
    for k = 1:length(patches)
        if ~isempty(patches(k).travelBarSelectedTime);
            patches(k).('colorOrder') = patches(k).('colorOrder')'; % special case where
                                                        % color order was
                                                        % saved as row
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


