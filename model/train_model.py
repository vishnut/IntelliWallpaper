import config
import json
import logging
import os
import PIL
import requests
from io import BytesIO
from keras.models import Sequential
from keras.layers import Conv2D, MaxPooling2D
from keras.layers import Activation, Dropout, Flatten, Dense
from keras.preprocessing.image import ImageDataGenerator
from PIL import Image
from random import shuffle

def load_json_from_file(file_name):
    if os.path.isfile(config.DATA_DIRECTORY + file_name):
        with open(config.DATA_DIRECTORY + file_name) as f:
            return json.load(f)

def save_training_images(images, category):
    shuffle(images)
    num_training = config.TRAINING_RATIO * len(images)
    for index, img_data in enumerate(images):
        if img_data and img_data['urls']:
            image_url = img_data['urls']['thumb']
            r = requests.get(image_url)
            image = Image.open(BytesIO(r.content))
            image = image.resize((config.RWIDTH, config.RHEIGHT), Image.ANTIALIAS)
            train_val = 'validation' if index > num_training else 'train'
            image.save('{0}{1}/{2}/{2}_{3:04d}.jpg'.format(config.TRAINING_DIRECTORY, train_val, category, index))
        else:
            logger.warn('Missing image data for index {0}. Data: {1}'.format(index, img_data))

def create_model():
    model = Sequential()
    model.add(Conv2D(32, (3, 3), input_shape=(128, 200, 3)))
    model.add(Activation('relu'))
    model.add(MaxPooling2D(pool_size=(2, 2)))
    
    model.add(Conv2D(32, (3, 3)))
    model.add(Activation('relu'))
    model.add(MaxPooling2D(pool_size=(2, 2)))
    
    model.add(Conv2D(64, (3, 3)))
    model.add(Activation('relu'))
    model.add(MaxPooling2D(pool_size=(2, 2)))

    model.add(Flatten())
    model.add(Dense(64))
    model.add(Activation('relu'))
    model.add(Dropout(0.5))
    model.add(Dense(1))
    model.add(Activation('sigmoid'))
    
    model.compile(loss='binary_crossentropy',
                  optimizer='rmsprop',
                  metrics=['accuracy'])
    return model

def train_model(model):
    batch_size = 16
    
    train_datagen = ImageDataGenerator(
            rescale=1./255,
            shear_range=0.2,
            zoom_range=0.2,
            horizontal_flip=True)
    
    test_datagen = ImageDataGenerator(rescale=1./255)
    
    train_generator = train_datagen.flow_from_directory(
            'data/train',
            target_size=(config.RHEIGHT, config.RWIDTH),
            batch_size=batch_size,
            class_mode='binary')
    
    validation_generator = test_datagen.flow_from_directory(
            'data/validation',
            target_size=(config.RHEIGHT, config.RWIDTH),
            batch_size=batch_size,
            class_mode='binary')
    
    model.fit_generator(
            train_generator,
            steps_per_epoch=2000 // batch_size,
            epochs=50,
            validation_data=validation_generator,
            validation_steps=800 // batch_size)
    return model

def set_up_logger():
    log = logging.getLogger('train_model')
    log.setLevel(logging.DEBUG)
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(formatter)
    log.addHandler(ch)
    return log

logger = set_up_logger()

if __name__ == '__main__':
    logger.info('Loading upvoted images') 
    good_images = load_json_from_file('good_images.json')
    logger.info('Saving {0} upvoted images as training and validation'.format(len(good_images)))
    save_training_images(good_images, 'good')
    logger.info('Loading downvoted images') 
    bad_images = load_json_from_file('bad_images.json')
    logger.info('Saving {0} downvoted images as training and validation'.format(len(bad_images)))
    save_training_images(good_images, 'bad') 
    logger.info('Images saved')
    logger.info('Creating keras model')
    keras_model = create_model()
    logger.info('Training model')
    trained_model = train_model(keras_model)
    logger.info('Saving model')
    trained_model.save_weights('model.h5')

