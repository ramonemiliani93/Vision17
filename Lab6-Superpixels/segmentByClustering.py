import cv2 as cv
import numpy as np
from sklearn import mixture
from sklearn import cluster


#featureSpace : 'rgb', 'lab', 'hsv', 'rgb+xy', 'lab+xy' or 'hsv+xy'
#clusteringMethod: 'k-means', 'gmm', 'hierarchical' or 'watershed'
#numberOfClusters: integer > 2

def segmentByClustering(rgbImage, featureSpace, clusteringMethod, numberOfClusters):
    num_rows, num_cols = rgbImage.shape[:2]
    x_indices = np.arange(num_rows) # [0, 1, 2, ..., num_rows]
    y_indices = np.arange(num_cols) # [0, 1, 2, ..., num_cols]
    x_pos = np.tile(x_indices, (num_cols, 1)).transpose()  # [[0, 0, ...,, 0], [1, 1, ..., 1], ...]]
    y_pos = np.tile(y_indices, (num_rows, 1))  # [[0, 1, ...,, num_cols], [0, 1, ..., num_cols], ...]]

    #Convert image to according feature space
    if featureSpace == 'lab':
        im = cv.cvtColor(rgbImage, cv.COLOR_BGR2Lab)
        num_channels = 3
    elif featureSpace == 'hsv':
        im = cv.cvtColor(rgbImage, cv.COLOR_BGR2HSV)
        num_channels = 3
    elif featureSpace == 'rgb+xy':
        im = np.dstack((rgbImage, x_pos, y_pos))
        num_channels = 5
    elif featureSpace == 'lab+xy':
        im = np.dstack(((cv.cvtColor(rgbImage, cv.COLOR_BGR2Lab)), x_pos, y_pos))
        num_channels = 5
    elif featureSpace == 'hsv+xy':
        im = np.dstack(((cv.cvtColor(rgbImage, cv.COLOR_BGR2HSV)), x_pos, y_pos))
        num_channels = 5
    elif featureSpace == 'rgb':
        im = rgbImage
        num_channels = 3

    #Normalize image
    im_color = cv.normalize(im[:, :, :3].astype('double'), None, 0.0, 1, cv.NORM_MINMAX)
    if num_channels == 5:
        im_xy = cv.normalize(im[:, :, 3:].astype('double'), None, 0.0, 1, cv.NORM_MINMAX)
        im = np.dstack((im_color, im_xy))
    else:
        im = im_color

    #Clustering
    if clusteringMethod == 'k-means':
        im = im.reshape((-1, num_channels))
        im = np.float32(im) #cv.kmeans uses float32
        criteria = (cv.TERM_CRITERIA_EPS + cv.TERM_CRITERIA_MAX_ITER, 10, 1.0)
        ret, segmentation, centers = cv.kmeans(im, numberOfClusters, None, criteria, 10, cv.KMEANS_RANDOM_CENTERS)

    elif clusteringMethod == 'gmm':
        im = im.reshape((-1, num_channels))
        gm_model = mixture.GMM(numberOfClusters, covariance_type='full')
        gm_model.fit(im) #Train model
        segmentation = gm_model.predict(im) #array[(m x n), 1]


    elif clusteringMethod == 'hierarchical':
        # Resize image
        resize_factor = 0.2
        im = cv.resize(im, (0,0), fx=resize_factor, fy=resize_factor)
        num_rows, num_cols = im.shape[:2]

        im = im.reshape((-1, num_channels))
        ac_model = cluster.AgglomerativeClustering(numberOfClusters, affinity='euclidean')
        segmentation = ac_model.fit_predict(im)

    elif clusteringMethod == 'watershed':
        a=0


    # Reshape into image dimensions
    segmentation = segmentation.reshape(num_rows, num_cols)

    return segmentation
