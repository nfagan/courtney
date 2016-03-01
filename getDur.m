%first output is always looking duration associated with each image
%presentations; if there is only one additional output specified (2 total), 
%it will be pupil size; if there are two additional outputs specified (3
%total), the outputs will be pupil size and the duration of the first
%looking event - in that order!

function [data] = getDur(wantedTimes,allEvents,pos)

if nargin < 3; %default values, if pos isn't specified

    minX = -10e3;
    maxX = 10e3;
    minY = -10e3;
    maxY = 10e3;
    
else
    
    minX = pos.minX;
    maxX = pos.maxX;
    minY = pos.minY;
    maxY = pos.maxY;
    
end

% dursPerFile = cell(1,length(wantedTimes));

for i = 1:length(wantedTimes);
    
    oneTimes = wantedTimes{i}; %get one file's timing info
    oneFixEvents = allEvents{i}; %get one file's fixation events
    
    fixStarts = oneFixEvents(:,1); %separate columns of fixation events for clarity; start of all fixations
    fixEnds = oneFixEvents(:,2); %end of all fixations
    dur = oneFixEvents(:,3); %durations
    x = oneFixEvents(:,4);
    y = oneFixEvents(:,5);
    pupSize = oneFixEvents(:,6);
    
    step = 1; %for saving durations per image
    for j = 1:size(oneTimes,1); %for each image display time ...
        startTime = oneTimes(j,1);
        endTime = oneTimes(j,2);        
        
        k = 1; toLoop = 1; toEnd(1:2) = 0;
        
        while toLoop && k < length(fixStarts)-1
            cnd1 = startTime >= fixStarts(k) & startTime <= fixEnds(k); %true if start time is between a given row's start and end fix times
            cnd2 = startTime >= fixEnds(k) & startTime <= fixStarts(k+1); %true if start time is between one row's end time and the next row's start time
            
            cnd3 = endTime >= fixStarts(k) & endTime <= fixEnds(k); %same as above but for end times
            cnd4 = endTime >= fixEnds(k) & endTime <= fixStarts(k+1);
            
            if cnd1
                startInd = k; %index of first fixation event
                firstDur = fixEnds(k) - startTime; %length of the first fixation event
                toEnd(1) = 1; %we found the start index; keep looking for the end index
            elseif cnd2
                startInd = k+1;
                firstDur = dur(k+1);
                toEnd(1) = 1;
            end
            
            if cnd3
                endInd = k; %index of first travel bar selected
                lastDur = endTime - fixStarts(k); %length of last fixation event
                toEnd(2) = 1; %now the start and end indices are found, so stop looking
            elseif cnd4;
                endInd = k;
                lastDur = dur(k);
                toEnd(2) = 1;
            end
            
            if sum(toEnd) == 2; %stop looking if start and end indices are known
                toLoop = 0;
            else %otherwise keep looking
                k = k+1;
            end
        end
        
        allDurs(1) = firstDur;
        allDurs(2:1+((endInd-1)-startInd)) = dur(startInd+1:endInd-1);
        allDurs(end+1) = lastDur;       
        
        allPupil = pupSize(startInd:endInd);      
        
        allX = x(startInd:endInd); %get all x positions
        allY = y(startInd:endInd); %get all y positions
        
        checkXBounds = allX >= minX & allX <= maxX;
        checkYBounds = allY >= minY & allY <= maxY;
        checkBounds = checkXBounds & checkYBounds;
        
        allDurs(~checkBounds) = []; 
        allPupil(~checkBounds) = [];
        
        if ~isempty(allDurs); %get all outputs PER image presentation
            dursPerImage(step) = sum(allDurs); %get sum of all durations
            firstLook(step) = allDurs(1); %get first duration, only
            savePupilPerImage{step} = allPupil; %get pupil sizes
            nFixations(step) = length(allDurs); %get number of fixations
            step = step+1;
        end
        
        clear allDurs allX allY pupilSize firstDur;
        
    end
   
    savePupilPerImage = concatenateData(remEmpty(savePupilPerImage));
    
    if i < 2; %if i = 1, the stored outputs are equal to the per image outputs
        dursPerFile = dursPerImage;
        firstLookPerFile = firstLook;
        savePupilPerFile = savePupilPerImage;
        nFixationsPerFile = nFixations;
    else %otherwise, the stored output are the previously stored outputs concatenated with the new per image outputs
        dursPerFile = horzcat(dursPerFile,dursPerImage);
        firstLookPerFile = horzcat(firstLookPerFile,firstLook);
        savePupilPerFile = vertcat(savePupilPerFile,savePupilPerImage);
        nFixationsPerFile = horzcat(nFixationsPerFile,nFixations);
    end
    
    clear dursPerImage firstLook savePupilPerImage nFixations;
    
end
%%%% outputs

dursPerFile = dursPerFile'; %make column vectors, for consistency
firstLookPerFile = firstLookPerFile';
nFixationsPerFile = sum(nFixationsPerFile);

data.allDurations = dursPerFile; %store in a struct for final output
data.pupSize = savePupilPerFile;
data.firstLook = firstLookPerFile;
data.nFixations = nFixationsPerFile;

% varargout{1} = dursPerFile;
% 
% if nargout == 2;
%     varargout{2} = savePupilPerFile;
% elseif nargout == 3;
%     varargout{2} = savePupilPerFile;
%     varargout{3} = firstLookPerFile;
% else
%     varargout{2} = savePupilPerFile;
%     varargout{3} = firstLookPerFile;
%     varargout{4} = nFixationsPerFile;
% end
%             
            
            
