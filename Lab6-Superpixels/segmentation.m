function [ clusteredImage ] = segmentation( rgbImage, featureSpace, clusteringMethod, numberOfClusters )
%Función de segmentación

%%%%%%%%Input Validation%%%%%%%%
minargs = 4;  maxargs = 4;
narginchk(minargs, maxargs)

expectedFeatureSpace = {'rgb', 'lab', 'hsv', 'rgb+xy', 'lab+xy', 'hsv+xy'};
expectedClusteringMethod = {'k-means', 'gmm', 'hierarchical', 'watershed'};

validateattributes(rgbImage,{'numeric'},{'size',[NaN, NaN, 3]},1);

featureSpaceName = validatestring(featureSpace,expectedFeatureSpace,...
    mfilename,'Feature Space',2);

clusteringMethodName = validatestring(clusteringMethod,...
    expectedClusteringMethod,mfilename,'Clustering Method',3);

validateattributes(numberOfClusters,{'numeric'},{'scalar','>',2})

rgbImage = im2double(rgbImage);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch featureSpaceName
    case expectedFeatureSpace{1}
        Image = rgbImage;
    case expectedFeatureSpace{2}
        Image = rgb2lab(rgbImage);
    case expectedFeatureSpace{3}
        Image = rgb2hsv(rgbImage);
    case expectedFeatureSpace{4}
        Image = rgbImage;
        X = repmat(0:size(Image,2)-1,[size(Image,1) 1]);
        Y = repmat((0:size(Image,1)-1)',[1 size(Image,2)]);
        Image = cat(3,Image,X,Y);
    case expectedFeatureSpace{5}
        Image = rgb2lab(rgbImage);
        X = repmat(0:size(Image,2)-1,[size(Image,1) 1]);
        Y = repmat((0:size(Image,1)-1)',[1 size(Image,2)]);
        Image = cat(3,Image,X,Y);
    case expectedFeatureSpace{6}
        Image = rgb2hsv(rgbImage);
        X = repmat(0:size(Image,2)-1,[size(Image,1) 1]);
        Y = repmat((0:size(Image,1)-1)',[1 size(Image,2)]);
        Image = cat(3,Image,X,Y);
end
imageVector = (reshape(Image,size(Image,1)*size(Image,2),size(Image,3)));

switch clusteringMethodName
    case expectedClusteringMethod{1}
        [clusteredVector] = kmeans(imageVector, numberOfClusters);
    case expectedClusteringMethod{2}
        GMModel = fitgmdist(imageVector, numberOfClusters);
        [clusteredVector] = cluster(GMModel,imageVector);
    case expectedClusteringMethod{3}
        [clusteredVector] = clusterdata(imageVector,...
            'linkage','ward','savememory','on','maxclust', numberOfClusters);
    case expectedClusteringMethod{4}
        [clusteredVector] = kmeans(imageVector, numberOfClusters);
end

clusteredImage = (reshape(clusteredVector,...
    size(Image,1),size(Image,2)));

end

