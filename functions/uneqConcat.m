% uneqConcat.m - function for concatenating cell arrays with
% different-dimensioned cells.
%
% Optional inputs:
%
%   'treatNDim' -- Decide how to respond when each cell is not a vector
%       'reshape' -- transform each matrix M into a 1-by-numel(M) vector
%       'perRow' -- storeVal is an M-by-N matrix where M is equal to the
%           number of rows in the first cell of cellArr
%       'perCol' -- storeVal is an M-by-N matrix where N is equal to the
%           number of cols in the first cell of cellArr

function storeVal = uneqConcat(cellArr,varargin)

params = struct(...
    'treatNDim','reshape' ...
    );

params = structInpParse(params,varargin);

if strcmp(params.treatNDim,'reshape');

for i = 1:length(cellArr)
    oneCell = cellArr{i};    
    if i == 1;
        storeVal = reshape(oneCell,1,numel(oneCell));
    else
        storeVal = horzcat(storeVal,reshape(oneCell,1,numel(oneCell)));
    end
end

end

if strcmp(params.treatNDim,'perRow');    
    for i = 1:length(cellArr)
        oneCell = cellArr{i};
        checkSize = size(oneCell);
        if checkSize(1) == 1;
                error(['The input array has only one row''s worth of data.' ...
                    , ' Rerun with ''treatNDim'' as ''reshape'' or ''perCol''']);
        else
            for j = 1:checkSize(1);
                if i == 1;
                    storeVal{j} = oneCell(j,:);
                else
                    storeVal{j} = horzcat(storeVal{j},oneCell(j,:));
                end
            end
        end
    end
    storeVal = concatenateData(storeVal);
end

if strcmp(params.treatNDim,'perCol');
    for i = 1:length(cellArr)
        oneCell = cellArr{i};
        checkSize = size(oneCell);
        if checkSize(2) == 1;
                error(['The input array has only one col''s worth of data.' ...
                    , ' Rerun with ''treatNDim'' as ''reshape'' or ''perRow''']);
        else
            for j = 1:checkSize(2);
                if i == 1;
                    storeVal{j} = oneCell(:,j);
                else
                    storeVal{j} = horzcat(storeVal{j},oneCell(:,j));
                end
            end
        end
    end
    storeVal = concatenateData(storeVal);
end 
            
        



