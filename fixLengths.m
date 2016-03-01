function [outputTimes,outputEvents,outputLabels] = fixLengths(wantedTimes,allEvents,allLabels)

initial = 1;

for j = 1:length(wantedTimes);    
    if ~isempty(wantedTimes{j});
        newWantedTimes{initial} = wantedTimes{j};
        newLabels{initial} = allLabels{j};
        newEvents{initial} = allEvents{j};
        initial = initial+1;
    end
end;

outputTimes = newWantedTimes;
outputLabels = newLabels;
outputEvents = newEvents;
