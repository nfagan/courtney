function outputs = get_wanted_times(patch,trial_type_struct)

field_mapping = struct(...
    'expressions', 'expressions', ...
    'valence', 'imageValence', ...
    'travelDelay','travelDelayDuration' ...
    );

field_mapping_fields = fieldnames(field_mapping);
trial_struct_fields = fieldnames(trial_type_struct);

for i = 1:length(trial_struct_fields)
    if ~any(strcmp(trial_struct_fields{i},field_mapping_fields))
        error('The second input structure has an unrecognized field name');
    end
end

outputs = nan(1000,5); stp = 0;
for i = 1:length(patch)
    image_times = patch(i).imageDisplayedTime;
   for k = 1:length(trial_struct_fields)
       current_field = trial_struct_fields{k};
       field_to_match = field_mapping_fields(strcmp(current_field,field_mapping_fields));
       matching_field = field_mapping.(field_to_match{1});
       
       current_values = patch(i).(matching_field);
       wanted_values = trial_type_struct.(current_field);
       
       if k == 1;
           is_wanted = false(size(current_values,1),length(trial_struct_fields));
       end
       
       for j = 1:length(wanted_values)
           if sum(strcmp(wanted_values,'all')) == 0
               if iscell(wanted_values)
                   is_wanted(:,k) = strcmp(current_values,wanted_values{j}) | is_wanted(:,k);
               else
                   is_wanted(:,k) = current_values == wanted_values(j) | is_wanted(:,k);
               end
           else
               is_wanted(:,k) = true;
           end
       end
   end
   
   is_wanted = sum(is_wanted,2) == size(is_wanted,2);
   n_valid_images = sum(is_wanted);
   
   %%% output section
   
   if n_valid_images > 0
       outputs(stp+1:stp+n_valid_images,1) = round(image_times(is_wanted,1));   % image start time
       outputs(stp+1:stp+n_valid_images,2) = round(image_times(is_wanted,2));   % image stop time
       outputs(stp+1:stp+n_valid_images,3) = patch(i).imageValence(is_wanted,1);
       outputs(stp+1:stp+n_valid_images,4) = patch(i).travelDelayDuration(is_wanted,1);
       outputs(stp+1:stp+n_valid_images,5) = i;

       stp = stp + n_valid_images;
   end
end

outputs(isnan(outputs(:,1)),:) = []; % get rid of excess nans

if isempty(outputs)
    warning('No trials of the specified criteria were found');
end
