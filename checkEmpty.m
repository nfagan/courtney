function varargout = checkEmpty(varargin)

for k = 1:nargin;
    use = varargin{k};
    step = 1; index = [];
    for i = 1:length(use);
        if isempty(use(i));
            index(step) = i;
            step = step+1;
        end
    end
    varargout{k} = index;
end

