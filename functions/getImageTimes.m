function startEndTimes = getImageTimes(allTimes,imageStarts,imageEnds,inds)

for i = 1:length(imageStarts);
    oneStarts = imageStarts{i};
    oneEnds = imageEnds{i};
    oneInds = inds{i};    
    oneTimes = allTimes{i}(:,2);
    
    oneStarts(~oneInds) = [];
    oneEnds(~oneInds) = [];
    
    startEndTimes{i}(:,1) = oneTimes(oneStarts);
    startEndTimes{i}(:,2) = oneTimes(oneEnds);   
    
    
end