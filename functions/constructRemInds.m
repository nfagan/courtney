function indsPerFile = constructRemInds(remType,varargin)

indsPerFile = cell(1,length(varargin{1}));
for i = 1:length(varargin{1});

oneTagInds = [];
for k = 1:nargin-1
    oneTagInds(k,:) = varargin{k}{i};
end

conditions = ~isnan(oneTagInds) & oneTagInds ~= 0;
oneTagInds = sum(conditions,1);

% oneTagInds = sum(~isnan(oneTagInds),1);

switch remType;
    case 'and'
        oneTagInds = oneTagInds == length(varargin);
    case 'or'
        oneTagInds = oneTagInds >= 1;
end

indsPerFile{i} = oneTagInds;

end