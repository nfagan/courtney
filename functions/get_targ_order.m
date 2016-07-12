function all_orders = get_targ_order(outputs)

unique_patches = unique(outputs(:,5));

all_orders = nan(max(unique_patches),8);

for i = 1:max(unique_patches);
    one_patch = outputs(outputs(:,5) == i,:);
    valences = one_patch(:,3);
    
    valences(valences == 1) = 0;
    valences(valences == 2) = 1;
    
    all_orders(i,1:size(one_patch,1)) = valences;
    
end

all_orders(isnan(all_orders(:,1)),:) = [];