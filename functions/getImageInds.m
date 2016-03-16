function imageIndices = getImageInds(allLabels)

imageIndices = cell(1,length(allLabels));
for i = 1:length(allLabels)
    rows = 1:length(allLabels{i});
    imageIndices{i} = rows(strcmp(allLabels{i},'ImageDisplayed')); % get image start indices;
end

