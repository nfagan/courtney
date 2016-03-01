function [outTimes,varargout] = fixLengths2(wantedTimes,varargin)

for j = 1:length(wantedTimes);
    
    if isempty(wantedTimes{j});
        remIndex(j) = 1;
    else
        remIndex(j) = 0;
    end
    
end

remIndex = logical(remIndex);

outTimes = wantedTimes;
outTimes(remIndex) = [];

for k = 1:length(varargin);
    toFix = varargin{k};
    toFix(remIndex) = [];
    varargout{k} = toFix;
end

        

