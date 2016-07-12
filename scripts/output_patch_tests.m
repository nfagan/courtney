cd('/Volumes/My Passport/NICK/Chang Lab 2016/courtney/new_task_data/output_patch_tests');
load('output_patch_test.mat');

%% check correspondence in image times and valences

timeFile = xlsread('Time test.xls'); %get image times -- old-way of doing it
ourTimes = cell2mat({output_patch(:).imageValence}'); %get image valences
ourTimes(ourTimes(:,1) == 0,:) = []; %get rid of skipped trials

check(:,1) = diff(timeFile(:,2));
check(:,2) = diff(ourTimes(:,2)).*1e3; %convert our times to ms

check = check(:,2) - check(:,1);

%% check correspondence between other events

[infoFile,labels] = xlsread('Info test.xls');

oldTags = strcmp('ImageDisplayed',labels); 
timeIndex = infoFile(oldTags,2); %get image displayed times, old way

newTimes = cell2mat({output_patch(:).imageDisplayedTime}'); %get our image displayed times
newTimes(newTimes(:,1) == 0,:) = []; % get rid of errors

% get our trial start time

trialStarts = cell2mat({output_patch(:).trialStartTime}');
trialStarts(trialStarts(:,1) == 0,:) = [];

%%

firstDifference = timeIndex(1) - infoFile(16,2);
ourDifference = newTimes(1) - trialStarts(1,2);








