function outputTimes = durThresh(wantedTimes,threshold)

wantedTimes = makeCell(wantedTimes);
outputTimes = cell(1,length(wantedTimes));

for i = 1:length(wantedTimes)
    oneTimes = wantedTimes{i};
    checkTimes = oneTimes(:,2) - oneTimes(:,1);
    rejectTimes = checkTimes < threshold;
    oneTimes(rejectTimes,:) = [];
    
    outputTimes{i} = oneTimes;
end
    
    