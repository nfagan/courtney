function toJitter = addJitter(posProp,jitterAmt)

if size(posProp,1) ~= 2;
    error(['posProp needs to be a two-rowed matrix, where the second row is' ...
        , ' the choice-order']);
end

proportions = posProp(1,:);
toJitter = posProp(2,:);

uniqProp = unique(proportions);

for i = 1:length(uniqProp);
    stp = 0;
    for k = 1:length(proportions);
        if posProp(2,k) ~= 0;
            if proportions(k) == uniqProp(i);
                if rand < .5;
                    toJitter(k) = toJitter(k) + stp*(jitterAmt);
                else
                    toJitter(k) = toJitter(k) - stp*(jitterAmt);
                end
                stp = stp+1;
            end        
        end
    end   
end
            
            
    

