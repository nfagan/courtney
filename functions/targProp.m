% targProp.m - function for calculating the proportion of remaining
% negative choices / proportion of remaining positive choices. Depends on
% output from targOrder.m
%
% Required inputs:
%
%   allOrders -- choice orders for each environment, as output by targOrder.m
%
% Optional inputs:
%
%   'toAnalyze'
%       'remaining' (default) -- posProp is the prop. remaining neg /
%           prop. remaining pos choices
%       'choiceFrequency' -- posProp is the frequency of each choice number
%
%   'treatDivZero'
%       [1] (default) -- Starting at the last positive choice for each
%           environment, all remaining proportion values will be undf, on
%           account of a divide by zero error. Matlab treats these undf values
%           as Inf. When 'treatDivZero' is [1], posProp will only contain
%           proportion values up until the last positive choice for an
%           environment. Otherwise, if 'treatDivZero' is a two-element vector,
%           where the first element is 1, these undf values will be replaced
%           by the value of the second element of the input vector. E.g., if
%           inputting 'treatDivZero',[1 0], undf values will be replaced by 0.
%   'choiceInd'
%       'on' or 'off' (default) -- Specify whether each cell of posProp has a
%           second row representing the choice number of each proportion
%           value. Useful / necessary for using certain features of
%           plotProp.m
%   'addOrigin'
%       1 or 0 (default) -- Specify whether to add the point (0,1) in every
%       environment.

function [posProp,varargout] = targProp(allOrders,varargin)

params = struct(... %default values of params struct
    'toAnalyze','remaining', ...
    'treatDivZero',[1], ... %remove div zero errors by default
    'choiceInd','off', ...
    'addOrigin',0 ...
    );    

params = structInpParse(params,varargin);

if strcmp(params.toAnalyze,'remaining');
    allNaNs = sum(isnan(allOrders),2) == size(allOrders,2); %get rid of trials with all NaNs
    fixedOrders = allOrders(~allNaNs,:);

    if isempty(fixedOrders) || length(fixedOrders) <= 2;
        error(['Not enough choice data to analyze. Consider changing' ...
            , ' ''maxChoices'' in targOrder.m to a smaller value, or' ...
            , ' ''toAnalyze'' (in this function) to ''choiceFrequency''']);
    else
        
        posProp = cell(size(fixedOrders,1),1);
        for k = 1:size(fixedOrders,1)
            oneRow = fixedOrders(k,:);
            oneRow = oneRow(~isnan(oneRow));

%             posN = sum(oneRow);
%             negN = length(oneRow) - posN;
            posN = 4;
            negN = 4;

            intN = 0; intP = 0;            
            oneProp = nan(1,size(fixedOrders,2));
            for h = 1:length(oneRow);
                if ~oneRow(h)
                    intN = intN + 1;
                elseif oneRow(h)
                    intP = intP + 1;
                end
            
            oneProp(h) = ((negN-intN)/negN)/((posN-intP)/posN);             
            
            end
            
            if params.treatDivZero(1) == 1 && length(params.treatDivZero) == 2;
                oneProp(oneProp == Inf | isnan(oneProp)) = params.treatDivZero(2);
            elseif params.treatDivZero(1) == 1 && length(params.treatDivZero) == 1;
                nonDivInd = (oneProp ~= Inf) & (~isnan(oneProp));
                oneProp = oneProp(nonDivInd);
            end
            
            posProp{k} = oneProp;
            
            if strcmp(params.choiceInd,'on');
                posProp{k}(2,:) = 1:size(posProp{k},2);
                if params.addOrigin
                    origLength = size(posProp{k},2);
                    posProp{k}(:,origLength+1) = 0;
                    posProp{k}(:,2:origLength+1) = posProp{k}(:,1:origLength);
                    posProp{k}(1,1) = 1; posProp{k}(2,1) = 0;
                end
            end
           
        end
    end

if strcmp(params.choiceInd,'on');
    posProp = uneqConcat(posProp,'treatNDim','perRow');
end

end
    
if strcmp(params.toAnalyze,'choiceFrequency');

    stp = 1;
    for j = 1:size(allOrders,2);
        oneChoiceN = allOrders(:,j);
        oneChoiceN = oneChoiceN(~isnan(oneChoiceN));

        if ~isempty(oneChoiceN);
            posProp(stp) = sum(oneChoiceN)/length(oneChoiceN);
            N(stp) = length(oneChoiceN);
            stp = stp+1;
        end
    end
end

if nargout > 1;
    if strcmp(params.toAnalyze,'remaining')
        error(['When looking at remaining proportions, only one output is' ...
            , ' allowed']);
    else        
        varargout{1} = N;
    end
end
    

