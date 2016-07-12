clear all;
% startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/latest_data';
startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/latest_data/newoutputpatchfiles';
cd(startDir);

matFiles = dir('*.mat');

for i = 1:length(matFiles);

    patchInfo = load(matFiles(i).name);
    patchInfo = patchInfo.output_patch;
    
    nTargetsSeen = [];
    stp = 1;
    for k = 1:length(patchInfo) % for each patch ...
        imageValences = patchInfo(k).imageValence;
        travelDelayDuration = patchInfo(k).travelDelayDuration;
        
        if ~isempty(travelDelayDuration);
            travelDelayDuration = travelDelayDuration(:,1);
            travelDelayDuration(travelDelayDuration == 0) = [];
            if ~isempty(imageValences);
                imageValences(imageValences(:,1) == 0,:) = [];
                imageValences = imageValences(:,1);
                nTargetsSeen(stp,1) = length(imageValences);

            else
                nTargetsSeen(stp,1) = 0;
            end
            nTargetsSeen(stp,2) = travelDelayDuration;
            stp = stp + 1;
        end
    end
    
    nTargetsSeenPerFile{i} = nTargetsSeen;

end

nTargetsSeenPerFile = concatenateData(nTargetsSeenPerFile);

%%

% histogram(nTargetsSeenPerFile);

% scatter(nTargetsSeenPerFile(:,2),nTargetsSeenPerFile(:,1));
sums = []; nums = [];
uniques = unique(nTargetsSeenPerFile(:,2));
for k = 1:length(uniques);
    extracted = nTargetsSeenPerFile(nTargetsSeenPerFile(:,2) == uniques(k),:);
    
    sums(k,:) = [uniques(k) sum(extracted(:,1))];
    nums(k,:) = [uniques(k) length(extracted(:,1))];
end

%% add jitter lAME
newStp = 1; jitterAmt = .0001;
for k = 1:length(nTargetsSeenPerFile);
    if rand > .5
        nTargetsSeenPerFile(k,2) = nTargetsSeenPerFile(k,2) + jitterAmt*newStp;
        newStp = newStp + 1;
    else
        nTargetsSeenPerFile(k,2) = nTargetsSeenPerFile(k,2) - jitterAmt*newStp;
        newStp = newStp + 1;
    end
end

scatter(nTargetsSeenPerFile(:,2),nTargetsSeenPerFile(:,1));

%%

% sums(:,2) = sums(:,2) ./ nums(:,2);
plot(sums(:,1),sums(:,2));

%% add patch residence

clear all;
% startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/latest_data';
startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/latest_data/newoutputpatchfiles';
cd(startDir);

matFiles = dir('*.mat');
   
for i = 1:length(matFiles);

    patchInfo = load(matFiles(i).name);
    patchInfo = patchInfo.output_patch;
    
    nTargetsSeen = [];
    stp = 1;
    for k = 1:length(patchInfo)-1 % for each patch ...
        imageValences = patchInfo(k).imageValence;
        travelDelayDuration = patchInfo(k).travelDelayDuration;
        
        fixAchieved = patchInfo(k).fixationAchievedTimes;
        fixDisplayed = [patchInfo(k).trialStartTime(1,2);patchInfo(k).fixationDisplayedTimes];
        patchResidence = patchInfo(k+1).patchStartTime - patchInfo(k).patchStartTime;
        
%         if size(displayedTimes,1) > size(decisionTimes,1)
%             disp(i); disp(k);
% %             error('sizes still don''t match'); 
%             displayedTimes = displayedTimes(1:size(decisionTimes,1));
%         elseif size(displayedTimes,1) ~= size(decisionTimes,1)
%             disp(i); disp(k);
%             error('sizes still don''t match'); 
%             
%         end
        
%         perPatchDiff = sum(decisionTimes - displayedTimes);
%         
%         if sign(perPatchDiff) == -1;
%             disp(i); disp(k); error('response time is negative');
%         end
        
        
        if size(fixAchieved,1) ~= size(fixDisplayed,1);
            fixAchieved(end+1,1) = patchInfo(k+1).trialStartTime(1,2);
        end
        
        if size(fixAchieved,1) ~= size(fixDisplayed,1);
            disp(k); disp(i);
        end
        
        totalPatchResidenceTime = patchResidence - sum((fixAchieved - fixDisplayed));
        
        if ~isempty(travelDelayDuration); % if patch is valid ...
            travelDelayDuration = travelDelayDuration(:,1);
            travelDelayDuration(travelDelayDuration == 0) = [];
            if ~isempty(imageValences);
                
                errorIndex = imageValences(:,1) == 0;
                imageValences(errorIndex,:) = [];
                imageValences = imageValences(:,1);
                nTargetsSeen(stp,1) = length(imageValences);
                
                %%%% response times
                
                displayedTimes = patchInfo(k).targetsDisplayedTime;
                decisionTimes = patchInfo(k).decisionTime;
                
                if size(displayedTimes,1) > size(decisionTimes,1)                    
                    displayedTimes = displayedTimes(1:size(decisionTimes,1));
                end
                
                if size(displayedTimes,1) ~= size(decisionTimes,1);
                    disp(i); disp(k); error('still doesn''t match');
                end
                    
                decisionTimes(decisionTimes == 0) = [];
                displayedTimes(decisionTimes == 0) = [];
                perPatchDiff = sum(decisionTimes - displayedTimes);
                
            else
                nTargetsSeen(stp,1) = 0;
            end
            nTargetsSeen(stp,2) = travelDelayDuration;
            nTargetsSeen(stp,3) = totalPatchResidenceTime;
            nTargetsSeen(stp,4) = perPatchDiff;
            stp = stp + 1;
        end
    end
    
    nTargetsSeenPerFile{i} = nTargetsSeen;

end

nTargetsSeenPerFile = concatenateData(nTargetsSeenPerFile);

%% add jitter lAME
newStp = 1; jitterAmt = .0001;
for k = 1:length(nTargetsSeenPerFile);
    if rand > .5
        nTargetsSeenPerFile(k,2) = nTargetsSeenPerFile(k,2) + jitterAmt*newStp;
        newStp = newStp + 1;
    else
        nTargetsSeenPerFile(k,2) = nTargetsSeenPerFile(k,2) - jitterAmt*newStp;
        newStp = newStp + 1;
    end
end

scatter(nTargetsSeenPerFile(:,2),nTargetsSeenPerFile(:,3));

ylim([]);

%%

% mdl = LinearModel.fit(nTargetsSeenPerFile(:,2),nTargetsSeenPerFile(:,3));

travelDuration = nTargetsSeenPerFile(:,2);
patchResidence = nTargetsSeenPerFile(:,3);

[RHO,p] = corr(travelDuration,patchResidence,'type','Kendall','tail','right');

    
    
    
    
