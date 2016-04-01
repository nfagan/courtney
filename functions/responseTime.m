% responseTimes.m - function for obtaining the amount of time between the
% initial display of a target and the selection of a target. Combines
% across data files. Requires external function concatenateData.m
%
% Required inputs:
%
%       allLabels - cell array containing each file's data flags.
%       allTimes - cell array containing each file's timing data, where
%           each cell corresponds to a label in allLabels.

function responseTimes = responseTime(allLabels,allTimes)

tag = 'TargetsDisplayed';  %index of start time
endTag = 'TargetRemaining'; %index of end time

responseTimes = cell(1,length(allLabels)); %preallocate cell for per-file response times
for i = 1:length(allLabels);
    oneLab = allLabels{i}; %one file's event labels
    oneTimes = allTimes{i}(:,2); %one file's timing data
    rows = 1:length(oneLab); %for indexing
    dispInd = rows(strncmpi(tag,oneLab,length(tag))); %find start tag
    remInd = zeros(length(dispInd),1); %preallocate removal index
    for k = 1:size(dispInd,2); %if label following start tag is not a valid end tag, 
                               %mark it for removal
        if ~strncmpi(oneLab(dispInd(1,k)+1),endTag,length(endTag));
            remInd(k) = 1;
        end
    end
    
    dispInd(logical(remInd)) = []; %get rid of bad times :)
    endInd = dispInd + 1; %ends are one label after starts
    
    starts = oneTimes(dispInd);
    ends = oneTimes(endInd);
    
    responseTimes{i} = ends - starts; 
    
%     check = responseTimes{i} == 4920;
%     if sum(check) == 1;
%         fprintf('file:%d; start: %d',i,dispInd(check));
%         error('dun goofed');
%     end
    
end

responseTimes = concatenateData(responseTimes); %combine across files