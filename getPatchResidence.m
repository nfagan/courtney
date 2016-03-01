function storeDifference = getPatchResidence(wantedTimes)

for j = 1:length(wantedTimes);
    oneTimes = wantedTimes{j};
    difference = oneTimes(:,2) - oneTimes(:,1);
    
    if j < 2;
        storeDifference = difference;
    else
        storeDifference = vertcat(storeDifference,difference);
    end
    
end
