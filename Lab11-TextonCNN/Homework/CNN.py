from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation, Flatten, MaxPooling2D, Conv2D


def cnn_arch():
    model = Sequential()

    #Conv. 5x5x1x20, stride = 1. Input size: (1,128,128)
    model.add(Conv2D(20, kernel_size=(5,5),strides=(1,1), input_shape=(1,128,128), data_format="channels_first", name='C1'))
    model.add(Activation('relu')) # Input size: (20,124,124)

    #Conv. 9x9x20x70, stride = 2. Input size: (20,124,124)
    model.add(Conv2D(70, kernel_size=(9,9), strides=(2, 2), data_format="channels_first", name='C2'))
    model.add(Activation('relu')) # Input size: (70,58,58)
    model.add(MaxPooling2D(pool_size=(2,2), data_format="channels_first", name='S1')) # Input size: (70,58,58)

    # Conv. 3x3x70x100, stride = 1. Input size: (70,29,29)
    model.add(Conv2D(100, kernel_size=(3, 3), input_shape=(1,128,128), data_format="channels_first", name='C3'))
    model.add(Activation('relu')) # Input size: (100,27,27)
    model.add(MaxPooling2D(pool_size=(3,3), data_format="channels_first", name='S2')) # Input size: (100,27,27)

    # Conv. 9x9x100x25, stride = 1. Input size: (100,9,9)
    model.add(Conv2D(25, kernel_size=(9, 9), data_format="channels_first", name='C4'))
    model.add(Dropout(0.25)) # Input size: (25,1,1)

    model.add(Flatten()) # Input size: (25,1,1)
    model.add(Dense(25, activation='softmax', name='Softmax')) # Input size: (25)

    return model

