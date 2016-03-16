% findTag.m - find the location of an element of allLabels with
% respect to each image presentation.
% 
% Required inputs:
%
%   allLabels - cell array where each cell is a string corresponding to a
%       trial event.
%   tag - exact or partially exact string of the desired trial event.
%
% Optional inputs:
%
%   'look'
%       'before' or 'after' - specify whether the tag comes before or after
%           an image presentation
%   'compare'
%       'partial' or 'exact' - specify whether to search for the exact
%           string or the first N characters of the string
%   'treatDups'
%       'error', 'first' or 'last' - when multiple tags are found per image,
%           specify whether to display an error message, or treat the first
%           or last occurrence of the tag as the index

function tagIndexPerFile = findTag(imageIndices,allLabels,tag,varargin)

params = struct(...
    'look','before', ...
    'compare','exact', ...
    'nChar',3, ...
    'treatDups','error' ...
    );

params = structInpParse(params,varargin);

for i = 1:length(allLabels);
    startIndex = imageIndices{i};

    if strcmp(params.look,'before');
        toLook = [1 startIndex];
    else
        toLook = [startIndex length(allLabels{i})];
    end    
    
    tagIndex = nan(1,length(toLook)-1);% preallocate tagIndex
    currentLength = 0;
    for k = 1:length(toLook)-1;              
        extrLabels = allLabels{i}(toLook(k):toLook(k+1)-1);
        if strcmp(params.compare,'exact'); %if simply looking for the exact string
            findStr = strcmp(extrLabels,tag);
        else
            findStr = strncmpi(extrLabels,tag,params.nChar);
        end
            
        if sum(findStr) > 1;
            if strcmp(params.treatDups,'error');
                error(['More than one occurrence of tag ''%s'' for this image:' ...
                    , '\nFILE NUMBER: %d\nIMAGE INDEX: %d'],tag,i,k);
            else
                if strcmp(params.treatDups,'first');
                    tagIndex(k) = find(findStr == 1,1,'first') + toLook(k)-1;
                end
                if strcmp(params.treatDups,'last');
                    tagIndex(k) = find(findStr == 1,1,'last') + toLook(k)-1;
                end
            end
        elseif sum(findStr) == 1;
            tagIndex(k) = find(findStr == 1) + currentLength;
        end
%         currentLength = currentLength + length(extrLabels);
    end   
tagIndexPerFile{i} = tagIndex;
end % end per file