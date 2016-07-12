function outputs = get_targ_colors(patch)

outputs = cell(length(patch),1);
for i = 1:length(patch)
    target_colors = patch(i).targetColor;
    decision_times = patch(i).decisionTime;
    errors = decision_times == 0;
    
    target_colors(errors) = [];
%     decision_times(errors) = [];
    
    dummy_var = zeros(size(target_colors,1),1); % because of how get_targ_order is structured,
                                                % include dummy variables
                                                % so that the size of
                                                % outputs is consistent
    
    outputs{i} = [dummy_var dummy_var target_colors dummy_var repmat(i,size(target_colors,1),1)];
    
end

outputs = concatenateData(outputs);