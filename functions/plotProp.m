% plotProp.m - function for plotting proportion data generated by
% targProp.m
%
%   Inputs are specified in name-value pairs: 'paramName', 'value'.
%   Possible inputs are:
%
%       'plotType'
%           'scatter' - plot choice by prop. neg / prop. positive
%           'hist' - plot frequencies of proportions at each choice number
%       'jitterAmount'
%           e.g. .005 - specify amount by which each individual proportion
%           value is stepped away from its "actual" x-coordinate.
%       'histEdges'
%           [...] if plotting with 'plotType' 'hist', specify the edges of
%           the bins to be used by the histcounts function. By default, the
%           edges are [0:.5:2].
%       'color'
%           e.g. 'k'. Must be some value recognized by the scatter function
%       'colorMap'
%           e.g. 'cool'. Specify the colormap of the imagesc function,
%           which plots the hist data.
%
%   Important things to note: 
%
%   If plotting with 'plotType','scatter', ensure that posProp was generated 
%       with EITHER divide by zero errors removed, or divide by zero errors 
%       transformed to some real value. Also, ensure that 'choiceInd' was set to 'on'.
%   If plotting with 'plotType','hist', ensure that posProp was generated with divide
%       by zero errors transformed to NaNs, and with 'choiceInd' set to 'off'.
%       If you see an error in concatenateData when trying to plot a histogram, 
%       it is likely because posProp was generated incorrectly.

function varargout = plotProp(posProp,varargin)

params = struct(... %default values of params struct
    'plotType','scatter', ...
    'histEdges',[0:.5:2], ...
    'color','k', ...
    'colorMap','cool', ...
    'jitterAmount',.0005 ...
    ); 

params = structInpParse(params,varargin);

% plotColor = params.color;

hold on;

if strcmp(params.plotType,'scatter');
    
toJitter = addJitter(posProp,params.jitterAmount); %add jitter to x coord    
fitTest = fit(posProp(2,:)',posProp(1,:)','exp1');
plot(fitTest,toJitter,posProp(1,:));
% plot(fitTest,posProp(2,:),posProp(1,:));
    
xlabel('Choice Number');
ylabel('Prop. Remaining Negative Choices / Prop. Remaining Positive Choices');

if nargout >=1;
    varargout{1} = [];
end

end

if strcmp(params.plotType,'hist')
    posProp = concatenateData(posProp);
    
    for i = 1:size(posProp,2);
        oneChoice = posProp(:,i);
        oneChoice = oneChoice(~isnan(oneChoice));
        
        N(:,i) = histcounts(oneChoice,params.histEdges);
    end    
    
    if nargout >= 1;
        varargout{1} = N;
    end
    
    imagesc(N); colormap(params.colorMap); y2 = colorbar;
    
    set(gca,'ytick',1:size(N,1));
    toYLabel = cell(1,length(params.histEdges));
    for j = 1:length(params.histEdges);
        toYLabel{j} = num2str(params.histEdges(j));
    end    
    set(gca,'yticklabel',toYLabel);
    
    ylabel('Bins of (Prop. Neg Remaining) / (Prop. Pos Remaining)');
    xlabel('Choice Number');
    ylabel(y2,'Frequency');
    
end
    
    
    