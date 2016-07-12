function get_eyelink_start_time(base_directory)

cd(fullfile(base_directory,'excel_files'));

excel_dir = dir('*.xls');
excel_file_names = {excel_dir(:).name};
ids = unique(cellfun(@(x) get_id_court(x),excel_file_names,'UniformOutput',false));

for i = 1:length(ids)
    
    info_file_str = sprintf('Info %s.xls',ids{i});
    current_excel_file = excel_file_names(strcmp(excel_file_names,info_file_str));
    current_excel_file = fullfile(base_directory,'excel_files',current_excel_file{1});
    [info_time_ids,info_file] = xlsread(current_excel_file);
    
    patch_file_str = fullfile(base_directory,'patch_files',sprintf('output_patch_%s',ids{i}));
    patch_file = load(patch_file_str);
    
    try
        patch_file = patch_file.output_patch;
    catch
        patch_file = patch_file.ans; % sometimes output_patch is saved as 'ans'
    end
    
    first_image_time = min(info_time_ids(strcmp(info_file,'ImageDisplayed'),2));
    
%     patch_start_time = patch_file(1).patchStartTime;
%     
%     color_order_index = strncmpi(info_file,'colorOrder:',11);
%     first_color_order_time = min(info_time_ids(color_order_index,2))/1000;
%     
%     time_difference = first_color_order_time - patch_start_time;
    
    for j = 1:length(patch_file);
%         patch_file(j).time_difference = time_difference;
        patch_file(j).first_image_time = first_image_time;
    end
    
    output_patch = patch_file;
        
    new_file_name = sprintf('fixed_output_patch_%s.mat',ids{i});
    save_path = fullfile(base_directory,'fixed_patch_files',new_file_name);
    save(save_path,'output_patch');
end





