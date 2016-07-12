function patches = add_expressions(patches,expression_mapping)

file_format = 'xxx\ee';
start_ind = strfind(file_format,'\') + 1;

add_mapping = 1;

if nargin < 2
    expression_mapping = struct(...
        'fear',{{'fs','s'}}, ...
        'threat',{{'t','ft'}}, ...
        'neutral',{{'n','fn'}}, ...
        'affil',{{'a','fa'}} ...
        );
end

expression_words = fieldnames(expression_mapping);

for i = 1:length(patches)
    file_names = patches(i).imageFileName;
    
    for k = 1:length(file_names)
        if ~isempty(file_names{k}) && length(file_names{k}) > 2
            file_names{k} = file_names{k}(start_ind:start_ind+2);
            file_names{k} = file_names{k}(isstrprop(file_names{k},'alpha'));
        else
            file_names{k} = '0';
        end
    end
    
    if add_mapping
        for k = 1:length(expression_words)
            current_expression = expression_words{k};
            expression_letters = expression_mapping.(current_expression);
            for j = 1:length(expression_letters)
                letter_matches = strcmp(file_names,expression_letters{j});
                file_names(letter_matches) = {current_expression};
            end
        end
    end
    
    patches(i).expression_names = file_names;
    
end

