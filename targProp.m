function [posProp,N] = targProp(allOrders,varargin)

params = struct(... %default values of params struct
    'toAnalyze','remaining' ...    
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

stp = 1;
for j = 1:size(allOrders,2);
    if strcmp(params.toAnalyze,'remaining');
        allNaNs = sum(isnan(allOrders),2) == size(allOrders,2);
        fixedOrders = allOrders(~allNaNs,:);
        if isempty(fixedOrders) || length(fixedOrders <= 2);
            error(['Not enough choice data to analyze. Consider changing' ...
                , ' ''maxChoices'' in targOrder.m to a smaller value, or' ...
                , ' ''toAnalyze'' (in this function) to ''choiceFrequency''']);
        else
            for k = 1:size(fixedOrders,1)
                oneRow = fixedOrders(k,:);
            end
        end
    end
    
    if strcmp(params.toAnalyze,'choiceFrequency');
        oneChoiceN = allOrders(:,j);
        oneChoiceN = oneChoiceN(~isnan(oneChoiceN));
        
        if ~isempty(oneChoiceN);
            posProp(stp) = sum(oneChoiceN)/length(oneChoiceN);
            N(stp) = length(oneChoiceN);
            stp = stp+1;
        end
    end
end
    

