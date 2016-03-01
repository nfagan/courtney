%first output is always looking duration associated with each image
%presentations; if there is only one additional output specified (2 total), 
%it will be pupil size; if there are two additional outputs specified (3
%total), the outputs will be pupil size and the duration of the first
%looking event - in that order!

function data = getDur2(wantedTimes,allEvents,pos)

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

dursPerFile = cell(1,length(wantedTimes));
sizePerFile = cell(1,length(wantedTimes));
nFixPerFile = cell(1,length(wantedTimes));
firstLookPerFile = cell(1,length(wantedTimes));
patchResidencePerFile = cell(1,length(wantedTimes));

for i = 1:length(wantedTimes);
    
    oneTimes = wantedTimes{i}; %get one file's timing info
    oneFixEvents = allEvents{i}; %get one file's fixation events
    
    fixStarts = oneFixEvents(:,1); %separate columns of fixation events for clarity; start of all fixations
    fixEnds = oneFixEvents(:,2); %end of all fixations
    dur = oneFixEvents(:,3); %durations
    x = oneFixEvents(:,4);
    y = oneFixEvents(:,5);
    pupSize = oneFixEvents(:,6);
    
    rowN = 1:length(fixStarts); %for indexing
    step = 1; %for saving per image
    
    dursPerImage = cell(1,length(oneTimes));
    sizePerImage = cell(1,length(oneTimes));
    nFixPerImage = cell(1,length(oneTimes));
    firstLookPerImage = cell(1,length(oneTimes));
    patchResidencePerImage = cell(1,length(oneTimes));
    
    exclude = 0;
    
    for j = 1:size(oneTimes,1); %for each image display time ...
        
        if oneTimes(j,2) < max(fixEnds); % if
            
            startEndTimes = [oneTimes(j,1) oneTimes(j,2)];
            timeIndex = zeros(1,2); firstLastDur = zeros(1,2);        

            for k = 1:2;

                toFindTime = startEndTimes(k);        
                testIndex = toFindTime >= fixStarts & toFindTime <= fixEnds;                      

                if sum(testIndex) == 1;
                    timeIndex(k) = rowN(testIndex);                
                    if k == 1;                    
                        firstLastDur(k) = fixEnds(timeIndex(k)) - toFindTime;          
                    else
                        firstLastDur(k) = toFindTime - fixStarts(timeIndex(k));
                    end
                else
                    lastGreater = find(toFindTime <= fixStarts,1,'first');
                    if k == 1;                    
                        timeIndex(k) = lastGreater;
                        firstLastDur(k) = dur(timeIndex(k));            
                    else                    
                        timeIndex(k) = lastGreater-1;
                        firstLastDur(k) = dur(timeIndex(k));
                    end
                end

            end

            startIndex = timeIndex(1);
            endIndex = timeIndex(2);

            if startIndex ~= endIndex        
                allDurs = dur(startIndex:endIndex);
                allDurs(1) = firstLastDur(1); allDurs(end) = firstLastDur(2); %replace first and last durations with adjusted durations;        
            else
                allDurs = firstLastDur(1);
            end

            allPup = pupSize(startIndex:endIndex);      
            allX = x(startIndex:endIndex);
            allY = y(startIndex:endIndex);   

            checkXBounds = allX >= minX & allX <= maxX;
            checkYBounds = allY >= minY & allY <= maxY;
            checkBounds = checkXBounds & checkYBounds;

            allDurs(~checkBounds) = [];
            allPup(~checkBounds) = [];        

            if ~isempty(allDurs);                
                dursPerImage{step} = sum(allDurs);
                sizePerImage{step} = mean(allPup);
                nFixPerImage{step} = length(allPup);
                firstLookPerImage{step} = allDurs(1);
                patchResidencePerImage{step} = startEndTimes(2) - startEndTimes(1);
                step = step+1;
            end
        
        else
            exclude = exclude+1;            
        end %end if
        
    end
    
    [dursPerImage,sizePerImage,nFixPerImage,firstLookPerImage,patchResidencePerImage] = ...
        concatenateData(dursPerImage,sizePerImage,nFixPerImage,firstLookPerImage,patchResidencePerImage);
    
    patchResidencePerFile{i} = patchResidencePerImage;
    dursPerFile{i} = dursPerImage;
    sizePerFile{i} = sizePerImage;
    nFixPerFile{i} = nFixPerImage;
    firstLookPerFile{i} = firstLookPerImage;    
    allExclude{i} = exclude;
    
end

[saveDurs,savePupil,saveNFix,saveFirstLook] = concatenateData(dursPerFile,sizePerFile,nFixPerFile,firstLookPerFile);
savePatchResidence = concatenateData(patchResidencePerFile);

allExclude = sum(concatenateData(allExclude));
%%%% outputs
data.allDurations = saveDurs;
data.firstLook = saveFirstLook;
data.pupilSize = savePupil;
data.nFixations = sum(saveNFix);
data.patchResidence = savePatchResidence;
data.excluded = allExclude;
