fastestViewTime = 2.4;
patchTimes = 0:300;
travelTimes = unique(storeTravelDelay);
rwdValues = [1:4 4+(2/3):(2/3):4+(8/3)];

responseTimes = storeResponseTime;

nSimulations = 100;

for j = 1:length(travelTimes);
    travelTime = travelTimes(j);

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
        store_gT(i) = gT;

    end
    
    meanRate(k,j) = mean(rate);

    end
    
end

for k = 1:length(travelTimes);
    shiftTimes(:,k) = patchTimes+travelTimes(k);
end
    
% g(T) expresses value of number of images seen
% is a constant value, per T (patch residence time)
% fastest duration for seeing one pic and returning to start = 2.4s

%% - plot 1c
for k = 1:size(meanRate,2);

hold on;
oneTravelTime = meanRate(:,k);
% plot(patchTimes,oneTravelTime);
plot(shiftTimes(:,k),oneTravelTime);

end

%% - get max rates and add to 1c;
hold on;

for k = 1:size(meanRate,2);

[maxRate(k),maxInd] = max(meanRate(:,k));
xCoord(k) = shiftTimes(maxInd,k);

end
plot(xCoord,maxRate,'k','Linewidth',2);

for i = 1:length(travelTimes);
    labels{i} = num2str(travelTimes(i));
end
d = length(labels);
labels{d+1} = 'Max Rate';
legend(labels,'location','southeast');

xlabel('Time in Patch (s)');
ylabel('Reward harvest rate');


%% - Fig 2a

figure;
plot(travelTimes,xCoord);

ylim([0 25]);
xlim([0 5.5]);

legend('Optimal');
ylabel('Time in patch (s)');
xlabel('Travel time (s)');


    
    
    
    
    
    