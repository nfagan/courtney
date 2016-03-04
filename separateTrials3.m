%%%% for some trials, after neg_image / pos_image
%%%% for others, after last travel bar selected after image displayed.

% wantedTrials - 'Maxed Out' or 'Travel Bar'
% valence - 'pos','neg','all valence','social','nonsocial',
% 'all social','all'
function [varargout] = separateTrials3(allLabels,allTimes,wantedTrials,valence,ttUse)

storeIndices = cell(1,length(allLabels));
wantedTimes = cell(1,length(allLabels));
wantedTrials = lower(wantedTrials); %make lowercase

switch wantedTrials;
    case 'travel bar'
        toCompare = 'TravelBarSelected';
    case 'maxed out'
        toCompare = 'Image_State_Maxed_Out';
end;

for k = 1:length(allLabels);
    
oneFileLabels = allLabels{k};
oneFileTimes = allTimes{k};

%preallocate indices - makes code run faster
imageDisplayedIndex = zeros(length(oneFileLabels),1);
travelBarSelectedIndex = zeros(length(oneFileLabels),1);
posIndex = nan(length(oneFileLabels),1);
isSocial = nan(length(oneFileLabels),1);
wantTTUse = nan(length(oneFileLabels),1);

for j = 1:length(oneFileLabels)-3;
    
    toRid = 0;
    
    cnd1 = strcmp(char(oneFileLabels{j}),'ImageDisplayed');
    cnd2 = strcmp(char(oneFileLabels{j+3}),toCompare);
    
    if cnd2 && cnd1;
        
        testNeg = char(oneFileLabels{j-1});
        
        if length(testNeg) >= 3;
            if strcmp(testNeg(1:3),'neg');
                posIndex(j,:) = 0;
                isSocial(j,:) = 0;                
            elseif strcmp(testNeg(1:3),'pos');
                posIndex(j,:) = 1;
                isSocial(j,:) = 0;
            else
                if strcmp(testNeg(1:3),'non');
                    posIndex(j,:) = 0;
                    isSocial(j,:) = 1;                   
                elseif strcmp(testNeg(1:3),'soc');
                    posIndex(j,:) = 1;
                    isSocial(j,:) = 1;
                else                    
                    toRid = 1;
                end;
            end
        else
            toRid = 1;
        end;
        
        if ~toRid;
            imageDisplayedIndex(j,:) = 1;
            travelBarSelectedIndex(j+3,:) = 1;
            ttCnd1 = zeros(1,length(ttUse)); ttCnd2 = zeros(1,length(ttUse));
            if ~isempty(ttUse);
                for kk = 1:length(ttUse);            
                    ttUseStr = horzcat('TT_use: ',num2str(ttUse(kk)));
                    ttCnd1(kk) = strcmp(oneFileLabels{j-2},ttUseStr);

                    step = 0; maxWhile = length(oneFileLabels)-3;
                    while strcmp(oneFileLabels{j+3+step},'TravelBarSelected') ...
                            && (j+3+step) < maxWhile;
                        step = step+1;
                    end           

                    ttCnd2(kk) = strcmp(oneFileLabels{j+3+step},ttUseStr);                
                end                
                    if any(ttCnd1) || any(ttCnd2)
                        wantTTUse(j,:) = 1;
                    else
                        wantTTUse(j,:) = 0;
                    end
            end;
        end
            
    end

end;
indices = [];
allIndices = 1:length(oneFileLabels);
indices(:,1) = allIndices(logical(imageDisplayedIndex));
indices(:,2) = allIndices(logical(travelBarSelectedIndex));

startTimes = oneFileTimes(logical(imageDisplayedIndex),2);
startTimes(:,2) = oneFileTimes(logical(travelBarSelectedIndex),2);

posIndex = posIndex(~isnan(posIndex)); isSocial = isSocial(~isnan(isSocial));
wantTTUse = wantTTUse(~isnan(wantTTUse));

switch valence;
    case 'pos'        
        toKeep = posIndex & ~isSocial; %keep positive & nonsocial images
    case 'neg'
        toKeep = ~posIndex & ~isSocial; %keep negative & nonsocial images
    case 'all valence'
        toKeep = ~isSocial; %keep all positive and negative images
    case 'social'
        toKeep = posIndex & isSocial; %keep only social images
    case 'nonsocial'
        toKeep = ~posIndex & isSocial; %keep only nonsocial images
    case 'all social';
        toKeep = isSocial; %keep all social images
    case 'all'
        toKeep = ones(length(posIndex),1);
end;

if ~isempty(ttUse);
    toKeep = toKeep & wantTTUse;
end

toRemove = ~toKeep;
startTimes(toRemove,:) = []; %get rid of unwanted valence (or don't get rid of anything, if case 'all');
indices(toRemove,:) = [];

storeIndices{k} = indices;
wantedTimes{k} = startTimes;
clear startTimes;
end

check = concatenateData(wantedTimes);

if isempty(check);
    error('No trials match specified criteria');
end

varargout{1} = wantedTimes;

if nargout == 2;
    varargout{2} = storeIndices;    
end









    
    
    
    
    
    

