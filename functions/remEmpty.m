function [varargout] = remEmpty(varargin)

for k = 1:length(varargin);
    toFix = varargin{k};
    
    initial = 1; fixCheck = 0;
    for j = 1:length(toFix);
        if ~isempty(toFix{j});
            fixed{initial} = toFix{j};
            initial = initial+1;
            fixCheck = 1;
        end
    end

    if fixCheck
        varargout{k} = fixed;
    else
        varargout{k} = [];
    end
end