function findTag(allLabels,imageIndices,tag,varargin)

params = struct(...
    'look','before', ...
    'compare','exact' ...
    );

params = structInpParse(params,varargin);

if length(allLabels) ~= length(imageIndices);
    error(['length of per-file labels and per-file image indices must be consistent.' ...
        , ' You should probably check to see whether you''re removing empty cells of imageIndices.']);
end

for i = 1:length(imageIndices);
    oneInds = imageIndices{i};
    oneLabels = allLabels{i};
    
    if strcmp(params.look,'before');
        oneInds = vertcat([1 1],oneInds);
        for j = 1:size(oneInds,1)-1;
            currentBounds = [oneInds(j,1) oneInds(j+1,1)];
        end
        
    
    
end
    
    
   



