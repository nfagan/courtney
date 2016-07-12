function binned = get_binned_fix_counts(data,binSize,varargin)

params = struct(...
    'showPlot',1 ...
    );
params = structInpParse(params,varargin);

stp = 1;

if isstruct(data) % if inputting the whole output struct of getDur2
    fixEventPSTH = data.fixEventPSTH;
    fixEventPSTH(isnan(fixEventPSTH)) = 0; % make missing values 0
    fixEventPSTH = sum(fixEventPSTH); % sum for each time bin (1ms)
else % if inputting the fixEventPSTH field of the data structure
    if size(data,1) > 1 % if the field has not yet been summed
        fixEventPSTH = sum(data);
    else
        fixEventPSTH = data;
    end
end

binned = zeros(1,length(fixEventPSTH)/binSize); % preallocate
for i = 1:length(fixEventPSTH)/binSize;
    
    extr = fixEventPSTH(1,stp:binSize*i);
    extr = sum(extr);
    
    binned(i) = extr;
    binned2(1,stp:binSize*i) = extr;
    
    stp = stp + binSize; % update start index
end


if params.showPlot
    figure;
    plot(binned);
end

% plot(1:length(binned2),binned2);


    