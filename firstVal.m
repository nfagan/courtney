function [storePos,storeSoc] = firstVal(allLabels)

storePos = cell(1,length(allLabels));
storeSoc = cell(1,length(allLabels));
for i = 1:length(allLabels);
    oneLabels = allLabels{i};
    pos = nan(length(oneLabels),1);
    soc = nan(length(oneLabels),1);    
    for k = 1:length(oneLabels);
        toCmp = oneLabels{k};
        
        if strcmp(toCmp,'BeginBatch');            
            j = 1; toEnd = 0;
            while j < (length(oneLabels)-k) && ~toEnd;
                toCmp2 = oneLabels{k+j};                
                if length(toCmp2) > 3;                    
                    toCmp2(4:end) = [];                                    
                    if strcmp(toCmp2,'pos');
                        pos(k) = 1;
                        soc(k) = 0;
                        toEnd = 1;
                    elseif strcmp(toCmp2,'neg');
                        pos(k) = 0;
                        soc(k) = 0;
                        toEnd = 1;
                    else
                        if strcmp(toCmp2,'soc');
                            pos(k) = 1;
                            soc(k) = 1;
                            toEnd = 1;
                        elseif strcmp(toCmp2,'non');
                            pos(k) = 0;
                            soc(k) = 1;
                            toEnd = 1;
                        end
                    end
                end
            j = j+1;   
            end
            
        end
        
    end
    pos = pos(~isnan(pos));
    soc = soc(~isnan(soc));

storePos{i} = pos;
storeSoc{i} = soc;
end
                
                
                
                
                
        
