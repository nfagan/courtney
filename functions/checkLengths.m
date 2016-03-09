function lengths = checkLengths(wantedTimes)

lengths = 0;

for j = 1:length(wantedTimes);
    d = wantedTimes{j};
    lengths = lengths + size(d,1);
end