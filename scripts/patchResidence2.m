startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/courtney/latest_data/newoutputpatchfiles';
cd(startDir);
matFiles = dir('*.mat');
   
stp = 1; storeTravelDelay = []; nDecisions = []; storePatchResidence = [];
for i = 1:length(matFiles);

    patchInfo = load(matFiles(i).name); % load in one file and format
    patchInfo = patchInfo.output_patch;
    
    for k = 1:length(patchInfo)-1 % for each patch ...
        
        travelDelayDuration = patchInfo(k).travelDelayDuration;
        
        if ~isempty(travelDelayDuration) % the last patch will be invalid --
                                         % skip it      
                                                    % remove zeros from
                                                    % travel delay duration
                                                    % matrix
                                                    
            nTrials = patchInfo(k).trialStartTime(end,1); % NOT number of images seen
            
            errors = patchInfo(k).errorSquareDisplayed; % error index
            
            displayedTimes = patchInfo(k).targetsDisplayedTime; % raw values,
                                                                % before
                                                                % removing
                                                                % errors
            decisionTimes = patchInfo(k).decisionTime;
            
            if size(decisionTimes,1) < size(displayedTimes,1) % prepare to remove
                                                              % error
                                                              % trials, if
                                                              % necessary
                decisionTimes(end+1:size(displayedTimes,1),1) = NaN;
                decisionTimes(end,1) = travelDelayDuration(travelDelayDuration(:,1) ~= 0,2);
            end
            
            if size(errors,1) < nTrials && ~isempty(errors) % Create index of which displayed 
                                                            % times to reject
                errors(end+1:nTrials,:) = 0;
                errors = logical(errors(:,1));
            else
                errors = logical(zeros(1,nTrials));
            end
            
            decisionTimes(errors) = []; % get rid of errors
            displayedTimes(errors) = [];
            
            if size(displayedTimes,1) ~= (size(decisionTimes,1));
                disp(i); disp(k);
                error('Something''s up with the recording of decision times');
            end
            
                                                        % for the first
                                                        % data-point only,
                                                        % treat trialStart
                                                        % as the first
                                                        % fixDisplayedTime
            fixAchieved = patchInfo(k).fixationAchievedTimes;
            fixDisplayed = [patchInfo(k).trialStartTime(1,2);...
                patchInfo(k).fixationDisplayedTimes];
            
            patchTime = patchInfo(k+1).patchStartTime - patchInfo(k).patchStartTime;
                                                    
            storeTravelDelay(stp) = travelDelayDuration(travelDelayDuration(:,1) ~= 0,1); 
            nDecisions(stp) = length(decisionTimes);
            storePatchResidence(stp) = patchTime - (sum(fixAchieved - fixDisplayed));
            storeResponseTime(stp) = sum(decisionTimes - displayedTimes);
            
        stp = stp + 1; % update across .mat files
        end
    end
end
%% jittered scatter plot of travel delay vs. patch residence
newStp = 1; jitterAmt = .0001; plotTravelDelay = zeros(length(storeTravelDelay),1);
for k = 1:length(storeTravelDelay);
    if rand > .5
        plotTravelDelay(k,1) = storeTravelDelay(k) + jitterAmt*newStp;
        newStp = newStp + 1;
    else
        plotTravelDelay(k,1) = storeTravelDelay(k) - jitterAmt*newStp;
        newStp = newStp + 1;
    end
end

scatter(plotTravelDelay,storePatchResidence);

%%

[RHO,p] = corr(storeTravelDelay',storePatchResidence','type','Kendall','tail','right');
