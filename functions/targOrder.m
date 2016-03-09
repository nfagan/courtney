% targOrder.m - function for obtaining the order of choices in an
% environment.
%
% Required inputs:
%
%   allLabels -- event labels, as obtained from getFiles.m
%
% Optional inputs:
%
%   'maxChoices'
%       Integer value (e.g. [8]) -- Some environments appear to have many more
%           than 8 choices. We can choose whether to keep or reject
%           environments above this 'maxChoices' threshold.
%   'removeAbove'
%       [1] or [0] (0 by default) -- choose whether or not to eliminate
%       trials that fall above the 'maxChoices' threshold.
%   'concatenate'
%       [1] or [0] (1 by default) -- choose whether to concatenate across
%       data files, or keep allOrders specific to a given data file


function [allOrders,varargout] = targOrder(allLabels,varargin)

params = struct(... %default values of params struct
    'maxChoices',8, ...
    'removeAbove',0, ...
    'concatenate',1 ...
    );    

paramNames = fieldnames(params);

nArgs = length(varargin);
if round(nArgs/2)~=nArgs/2
   error('Name-value pairs are incomplete!')
end

for pair = reshape(varargin,2,[])
   inpName = pair{1};
   if any(strcmp(inpName,paramNames))
      params.(inpName) = pair{2};
   else
      error('%s is not a recognized parameter name',inpName)
   end
end

allOrders = cell(1,length(allLabels));
allInds = cell(1,length(allLabels));
for i = 1:length(allLabels);
    oneFile = allLabels{i}; orderInd = zeros(length(oneFile),1);
    for j = 1:length(oneFile)     
        oneLab = oneFile{j};
        if length(oneLab) >= 12;            
            if strcmp(oneLab(1:12),'colorOrder: ');
                orderInd(j) = 1;
            else
                orderInd(j) = 0;
            end
        else
            orderInd(j) = 0;
        end
    end
    cols = 1:length(oneFile);
    orderInds = cols(logical(orderInd));
    
    if isempty(orderInds);
        error(['No start indices were found. Probably this is because the' ...
            , ' syntax for ''colorOrder:'' is different in this file']);
        fprintf('file number = %d',i);
    else
        orderInds(2,:) = 0; orderInds(2,end) = length(oneFile);
        orderInds(2,1:end-1) = orderInds(1,2:end);
        storeOrders = cell(1,size(orderInds,2));
        storeInds = cell(1,size(orderInds,2));
        for k = 1:size(orderInds,2);
            extrLabels = oneFile(orderInds(1,k):orderInds(2,k));
            rows = 1:length(extrLabels);
            
            posInd = rows(strcmp(extrLabels,'pos_image'));
            negInd = rows(strcmp(extrLabels,'neg_image'));
            
            posInd(2,:) = 1; negInd(2,:) = 0; allInd = horzcat(posInd,negInd);
            [~,sortInd] = sort(allInd(1,:));
            
            intOrders = allInd(2,sortInd);
            intInds = allInd(1,sortInd);
            if length(intOrders) < params.maxChoices;
                intOrders(end+1:params.maxChoices) = NaN;
                intInds(end+1:params.maxChoices) = NaN;
            elseif length(intOrders) > params.maxChoices && ~params.removeAbove
                fprintf('File Number: %d\nLabels Index: %d\n',i,k);
                error(['There were %d choices in this ''environment'', which is more' ...
                    , ' than the specified maximum (%d). Increase the parameter' ...
                    , ' ''maxChoices'' to avoid this, or make the parameter' ...
                    , ' ''removeAbove'' = 1 to remove above-threshold ''environments'''] ...
                    , length(intOrders),params.maxChoices);
            else
                if length(intOrders) > params.maxChoices && params.removeAbove
                    intOrders = [];
                    intInds = [];
                end
            end
            
            storeOrders{k} = intOrders;
            storeInds{k} = intInds;
        end
            
    end
    
storeOrders = concatenateData(remEmpty(storeOrders));
storeInds = concatenateData(remEmpty(storeInds));

allOrders{i} = storeOrders;
allInds{i} = storeInds;
end

if params.concatenate
    allOrders = concatenateData(allOrders);
    allInds = concatenateData(allInds);
end

if nargout > 1;
    varargout{1} = allInds;
end
        

