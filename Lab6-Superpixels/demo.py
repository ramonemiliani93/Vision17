import cv2 as cv
import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt
from segmentByClustering import segmentByClustering


# im = cv.imread('Lab5Images/24063.jpg')
# cv.startWindowThread()
# cv.imshow('Test', im)
# cv.waitKey(0)
# cv.destroyAllWindows()
# cv.waitKey(1)

def segm_groundtruth(path):
    mat = sio.loadmat(path) #Dict
    cell = mat['groundTruth'][0][0] #First cell
    segm = cell[0][0][0] #Segmentation
    return segm

def bound_groundtruth(path):
    mat = sio.loadmat(path) #Dict
    cell = mat['groundTruth'][0][0] #First cell
    segm = cell[0][0][1] #Segmentation
    return segm


if __name__ == "__main__":
    segm_path = 'Lab5Images/24063.mat'
    im_path = 'Lab5Images/24063.jpg'
    im = cv.imread(im_path)

    segmentation = segmentByClustering(im, 'rgb', 'hierarchical', 3)

    plt.imshow(segmentation, extent=[0, 1, 0, 1], cmap='RdYlGn')
    plt.show()



    # segm_gt = segm_groundtruth(segm_path)
    # bound_gt = bound_groundtruth(segm_path)
    # #Plot
    # fig = plt.figure()
    # plt.subplot(2, 1, 1), plt.imshow(segm_gt)
    # plt.subplot(2, 1, 2), plt.imshow(bound_gt)
    # plt.show()





