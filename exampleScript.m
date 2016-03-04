% --------------------------------
% load in files
% --------------------------------
% umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/test_data_2/DataLager/';
umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/test_data_2/DataKuro2';

[allLabels,allTimes,allEvents] = getFiles(umbrellaDirectory);
allOrders = targOrder(allLabels,'removeAbove',1);

% --------------------------------
% get valence
% --------------------------------

[positive,social] = firstVal(allLabels);
[allPos,allSoc] = concatenateData(positive,social);

% --------------------------------
% separate by trial / image type
% --------------------------------

wantedTimes = separateTrials3(allLabels,allTimes,'travel bar','neg',[1]); % separate based on trial events

% --------------------------------
% reject images that were displayed for too little time
% --------------------------------

threshold = 100; %ms
wantedTimes = durThresh(wantedTimes,threshold);

% --------------------------------
% ensure event files correspond to image times
% --------------------------------

[wantedTimes,allEvents,allLabels] = fixLengths(wantedTimes,allEvents,allLabels); %match lengths of all pertinent variables

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

%all 1097
% all valence = 509 | 2017
% all social = 588 

%neg - 276
%pos - 233
%soc - 353
%non - 235

%all - 7587 | 1097
%all valence - 3482 | 509
%all social - 4105 | 588

%neg - 1922
%pos - 1560
%soc - 2684 | 353
%non - 1421 | 235