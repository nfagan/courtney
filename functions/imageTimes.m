function imageTimes(allTimes,valence,

imageStarts = getImageInds(allLabels);
imageEnds = findTag(imageStarts,allLabels,'TravelBarSelected','look','after','treatDups','first');

switch valence;
    case 'positive'
        inds = findTag(imageStarts,allLabels,'pos_image');
    case 'negative'
        inds = findTag(imageStarts,allLabels,'neg_image');
end

indsPerFile = constructRemInds('and',inds,imageEnds);

times = getImageTimes(allTimes,imageStarts,imageEnds,indsPerFile);


