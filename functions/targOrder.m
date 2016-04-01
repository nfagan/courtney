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
%       [1] or [0] (default) -- choose whether or not to eliminate
%       trials that fall above the 'maxChoices' threshold.
%   'concatenate'
%       [1] (default) or [0] -- choose whether to concatenate across
%       data files, or keep allOrders specific to a given data file
%   'addLastChoice'
%       [1] (defalt) or [0] -- for environments in which seven choices were
%           recorded, specify whether to append an eigth value
%           corresponding to the valence of the last possible 'choice'.
%           This will ensure a proportion value can be calculated for the
%           seventh choice in these environments.


function [allOrders,varargout] = targOrder(allLabels,varargin)

params = struct(... %default values of params struct
    'maxChoices',8, ...
    'removeAbove',0, ...
    'concatenate',1, ...
    'addLastChoice',1, ...
    'compareWith','batch' ...
    );    

params = structInpParse(params,varargin);

allOrders = cell(1,length(allLabels));
allInds = cell(1,length(allLabels));
for i = 1:length(allLabels);
    oneFile = allLabels{i};    
    
    if strcmp(params.compareWith,'batch');
        batchInd = strcmp(oneFile,'EndBatch');
    elseif strcmp(params.compareWith,'colorOrder');
        batchInd = strncmpi(oneFile,'colorOrder: ',12);
    end
    
    cols = 1:length(oneFile);
    orderInds = cols(batchInd);
    
    if isempty(orderInds);
        error(['No start indices were found. Probably this is because the' ...
            , ' syntax for ''colorOrder:'' is different in this file: %d'],i);
    else        
        if strcmp(params.compareWith,'batch');
            orderInds(2,:) = 1;
            orderInds(2,2:end) = orderInds(1,1:end-1);
        elseif strcmp(params.compareWith,'colorOrder');
            orderInds(2,:) = [orderInds(1,2:end) length(oneFile)];
            orderInds = flipud(orderInds);
        end
        
        storeOrders = cell(1,size(orderInds,2));
        storeInds = cell(1,size(orderInds,2));
        
        for k = 1:size(orderInds,2);
            extrLabels = oneFile(orderInds(2,k):orderInds(1,k));
            
            check(k) = sum(strncmpi(extrLabels,'SelectedTarget:',15));
            check2(k) = sum(strcmp(extrLabels,'pos_image') | strcmp(extrLabels,'neg_image') | strcmp(extrLabels,'social_image') | strcmp(extrLabels,'nonsocial_image'));
            
            rows = 1:length(extrLabels);
            
            posInd = rows(strcmp(extrLabels,'pos_image'));
            negInd = rows(strcmp(extrLabels,'neg_image'));
            
            posInd(2,:) = 1; negInd(2,:) = 0; allInd = horzcat(posInd,negInd);
            [~,sortInd] = sort(allInd(1,:));
            
            intOrders = allInd(2,sortInd);
            intInds = allInd(1,sortInd);
            
            if length(intOrders) == 7 && params.addLastChoice
                lastAvailable = 4 - sum(intOrders);
                if lastAvailable > 1 || lastAvailable < 0;
                    error('Fewer than 4 positive or negative targets were presented');
                else   
                    intOrders(end+1) = lastAvailable;
                    intInds(end+1) = 0;
                end
            end
            
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
        

