function [posProp,varargout] = targProp(allOrders,varargin)

params = struct(... %default values of params struct
    'toAnalyze','remaining', ...
    'treatDivZero',[1] ... %remove div zero errors by default
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
        
%         posProp = nan(size(fixedOrders,1),size(fixedOrders,2));
        posProp = cell(size(fixedOrders,1),1);
        for k = 1:size(fixedOrders,1)
            oneRow = fixedOrders(k,:);
            oneRow = oneRow(~isnan(oneRow));

            posN = sum(oneRow);
            negN = length(oneRow) - posN;

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
            
%             posProp(k,h) = oneProp;
            posProp{k} = oneProp;
           
        end
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
    

