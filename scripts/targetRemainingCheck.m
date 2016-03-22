for i= 1:length(allLabels);
    toCmpStr = 'TargetRemaining: ';    
    store(i) = sum(strcmp(allLabels{i},toCmpStr));
    
    onlyRemLabels = allLabels{i}(strncmpi(allLabels{i},toCmpStr,length(toCmpStr)));
    lengths = [];
    for k = 1:length(onlyRemLabels);
        lengths(k) = length(onlyRemLabels{k});
    end
    storeMax(i) = max(lengths);
    
    rows = 1:length(allLabels{i});
    
    storeInds{i} = rows(strcmp(allLabels{i},toCmpStr));
    
    
    
    
%     TargetRemaining: 1  2  3  4  5  7  8  9 
    
end