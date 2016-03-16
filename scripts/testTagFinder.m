imageStarts = getImageInds(allLabels);
imageEnds = findTag(imageStarts,allLabels,'TravelBarSelected','look','after','treatDups','first');

posInds = findTag(imageStarts,allLabels,'pos_image');
negInds = findTag(imageStarts,allLabels,'neg_image');
socInds = findTag(imageStarts,allLabels,'soc_image');

%%

indsPerFile = constructRemInds('and',posInds);
indsPerFile = constructRemInds('and',indsPerFile,imageEnds);

%%

times = getImageTimes(allTimes,imageStarts,imageEnds,indsPerFile);

