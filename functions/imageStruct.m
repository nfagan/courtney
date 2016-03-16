function imageStruct(allLabels)

starts = getImageInds(allLabels);
tags = {'TravelBarSelected','pos_image','neg_image','nonsocial_image', ...
    'social_image','TT_use: 1','TT_use: 3','TT_use: 5','TT_use: 7',...
    'TT_use: 9'};

fieldNs = {'end','pos','neg','nonsocial', ...
    'social','tt_use_1','tt_use_3','tt_use_5','tt_use_7','tt_use_9'};

for i = 1:length(tags);
    if i == 1;
        indices{i} = findTag(starts,allLabels,tags{i},'look','after','treatDups','first');
    else
        indices{i} = findTag(starts,allLabels,tags{i});
    end
end

for j = 1:length(tags);
    for i = 1:length(starts)
        for k = 1:length(starts{i});
            image{i}(k).('image_start') = starts{i}(k);
            image{i}(k).(fieldNs{j}) = indices{j}{i}(k);        
        end
    end
end



