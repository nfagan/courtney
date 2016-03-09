function varargout = makeCell(varargin)

for i = 1:length(varargin)
    toMake = varargin{i};    
    if ~iscell(toMake);
        toMake = {toMake};
    end    
    varargout{i} = toMake;
end