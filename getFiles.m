function [allLabels,allTimes,allEvents] = getFiles(umbrellaDirectory)
cd(umbrellaDirectory);

allFiles = dir(umbrellaDirectory);

fileNames = {allFiles(:).name};

toRemove = zeros(length(allFiles),1);
for i = 1:length(allFiles); %remove all non-.xls files
    currentName = fliplr(char(fileNames{i}));
    
    if length(currentName) < 3 || ~strcmp(currentName(1:3),'slx')
        toRemove(i) = 1;
    else
        toRemove(i) = 0;
    end
end

allFiles(logical(toRemove)) = [];

extractedNames = {allFiles(:).name}; %get all unique ID numbers
for i = 1:length(extractedNames);
    currentName = fliplr(char(extractedNames{i}));
    
    spaceIndex = strfind(currentName,' ');
    idNumber = fliplr(currentName(5:spaceIndex-1));    
    idNumbers{i} = idNumber;    
end

idNumbers = unique(idNumbers);

allLabels = cell(1,length(idNumbers)); %preallocate cell arrays so code runs faster
allTimes  = cell(1,length(idNumbers));
allEvents = cell(1,length(idNumbers));

for j = 1:length(idNumbers); % for each set of data files / for each id number ...
    
    currentId = char(idNumbers{j});
    newFileNames = {allFiles(:).name}';
    newStruct = allFiles;
    
    toRemove2 = zeros(length(newFileNames),1);
    for k = 1:length(newFileNames); %remove from the newStruct all data files that DON'T have the current id
        
        toTestName = fliplr((char(newFileNames{k})));
        toCompareId = toTestName(5:length(currentId)+4);
        
        cnd1 = strcmp(toCompareId,fliplr(currentId));
        
        if cnd1
            toRemove2(k) = 0;
        else
            toRemove2(k) = 1;
        end
    end
    
    newStruct(logical(toRemove2)) = [];
    newStructNames = {newStruct.name};
    
    for h = 1:length(newStructNames); %identify efix vs. info files and load in accordingly
        toCheck = (char(newStructNames{h}));
        toCheck(5:end) = [];        
        
        if strcmp(toCheck,'Efix');
            fixationEvents = xlsread(newStruct(h).name);
        elseif strcmp(toCheck,'Info');
            [times,labels] = xlsread(newStruct(h).name);
        end
    end
    pause(.01);
    
    toRemove3 = zeros(length(labels),1);   
    for i = 1:length(labels); %remove numbered events from labels
    
        if strcmp(labels{i},'') == 1;
            toRemove3(i) = 1;
        else
            toRemove3(i) = 0;  
        end
    end
    
    labels(logical(toRemove3)) = [];
    times(logical(toRemove3),:) = [];
    
    %store labels, times, and events PER id number (set of files)
    
    allLabels{j} = labels;
    allTimes{j} = times;
    allEvents{j} = fixationEvents;
    
    clear labels times fixationEvents;
end