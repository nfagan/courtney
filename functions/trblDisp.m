function trblDisp(varargin)

for k = 1:length(varargin);    
    toPrint = varargin{k};
    toPrint = num2str(toPrint);
    
    if k == 1
        toPrtStr = sprintf('File Number: %s',toPrint);        
    elseif k == 2
        toPrtStr = sprintf('Block Number: %s',toPrint);
    else
        toPrtStr = sprintf('Additional Variable %d: %s',(k-2),toPrint);
    end
    
    fprintf(toPrtStr);
    
end
    
    
    
    