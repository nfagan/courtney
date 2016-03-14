% --------------------------------
% load in files
% --------------------------------

% umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/test_data_2/DataLager/';
umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/test_data_2/DataKuro2';
[allLabels,allTimes,allEvents] = getFiles(umbrellaDirectory);

% --------------------------------
% proportions
% --------------------------------

[allOrders,orderInds] = targOrder(allLabels,'removeAbove',0,'maxChoices',8);
[posProp] = targProp(allOrders,'choiceInd','on','addOrigin',1,'treatDivZero',[1]);
n = plotProp(posProp,'plotType','scatter','jitterAmount',.0007);

%%
% [posProp] = targProp(allOrders,'choiceInd','off','addOrigin',1,'treatDivZero',[1 NaN]);
% n = plotProp(posProp,'plotType','hist','histEdges',[0:.05:2]);

% --------------------------------
% get valence
% --------------------------------

[positive,social] = firstVal(allLabels);
[allPos,allSoc] = concatenateData(positive,social);

% --------------------------------
% separate by trial / image type
% --------------------------------

[wantedTimes,imageIndices] = separateTrials3(allLabels,allTimes,'travel bar','neg',[]); % separate based on trial events

% --------------------------------
% reject images that were displayed for too little time
% --------------------------------

threshold = 100; %ms
wantedTimes = durThresh(wantedTimes,threshold);

% --------------------------------
% ensure event files correspond to image times
% --------------------------------

[wantedTimes,allEvents,allLabels,imageIndices] = fixLengths2(wantedTimes,allEvents,allLabels,imageIndices); %match lengths of all pertinent variables

% --------------------------------
% get looking durations, pupil sizes, etc.
% --------------------------------

% patchResidenceTime = getPatchResidence(wantedTimes);

pos.minX = 0;
pos.maxX = 300;
pos.minY = 0;
pos.maxY = 300;

data = getDur2(wantedTimes,allEvents,pos); %get the looking duration associated with each image, after defining positional boundaries

lookingDurations = data.allDurations;
pupilSize = data.pupilSize;
firstLook = data.firstLook;
nFixations = data.nFixations;
patchResidenceTime = data.patchResidence;

%%
aboveThreshold = lookingDurations > 100;

thresholdedDurations = lookingDurations(aboveThreshold);
firstLook = firstLook(aboveThreshold);


%% save results

% cd('____') %check the current directory to make sure you save into a sensible place!
csvwrite('durations.csv',lookingDurations);
csvwrite('pupilSize.csv',pupilSize);
csvwrite('firstLook.csv',firstLook);
csvwrite('nFixations.csv',nFixations);

%% for checking that each image presentation has a looking duration associated with it

nImages = checkLengths(wantedTimes); %check if separateTrials is working; compare this value with the length of 'durs'