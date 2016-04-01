fastestViewTime = 2.4;
patchTimes = 0:30;
travelTimes = .5:.5:5;
rwdValues = [1:4 4+(2/3):(2/3):4+(8/3)];
% rwdValues = [.5:.5:2 2+(1/3):(1/3):2+(8/3)];

responseTimes = responseTime(allLabels,allTimes);
nSimulations = 100;

for k = 1:length(patchTimes)% loop for each patch time ...
    patchRTime = patchTimes(k); %pulling out one time, for example ...
    rate = zeros(1,nSimulations);
    for i = 1:nSimulations
        resampledResponseTimes = datasample(responseTimes,length(responseTimes));
        meanResponse = mean(resampledResponseTimes)/1000;
        nImages = floor((patchRTime)/(fastestViewTime+meanResponse));
        if nImages > 8;
            nImages = 8;
        end
        if nImages == 0
            gT = 0;
        else
            gT = (rwdValues(nImages));
        end
        rate(i) = gT/(patchRTime+travelTime);
        store_gT(i,k) = gT;
    end
end

meanGT = mean(store_gT);

%%

plot(patchTimes,meanGT);

newMean = meanGT(1:8:end);
newPatch = patchTimes(1:8:end);
xlabel('Time in patch (s)');
ylabel('Reward harvested');



% plot(newPatch,newMean);

%%

newFit = fit(patchTimes',meanGT','linearinterp');

plot(newFit,patchTimes,meanGT);