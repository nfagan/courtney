% possible outputs include 'n images', 'proportion', 'raw counts', or
% 'average duration'. Define the region of interest as 'whole face' or 'roi'

function M = genTable(saveData,region)

global toExamine;
outputType = toExamine;

region = lower(region); outputType = lower(outputType); %make lowercase

switch region
    case 'roi'
        rg = 1;
    case 'whole face'
        rg = 2;
end

rows = size(saveData,1);
cols = size(saveData,2);

M = zeros(rows,cols);

for i = 1:rows;
    for j = 1:cols
        
        ex = saveData{i,j}{1,rg};
        
        switch outputType;
            case 'n images'
                ex2 = length(ex.allDurations);
            case 'proportion'
                ex2 = ex.proportion;
            case 'raw counts'
                ex2 = ex.nFixations;
            case 'average duration'
                ex2 = mean(ex.allDurations);
            case 'normalized proportion'
                ex2 = ex.proportion;
        end        
        
        M(i,j) = ex2;
        
    end
end

if strcmp(outputType,'normalized proportion');    
    toSub = repmat(M(:,1),1,(size(M,2)-1));
    M(:,2:end) = M(:,2:end) - toSub;
end
    


    