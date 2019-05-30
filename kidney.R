
## clone the data
# URL=https://storage.googleapis.com/jp-mouse-kidney-patches/14112-labelled.tar.gz
# curl -O $URL
# mkdir -p data && mv 14112-labelled.tar.gz data/ && cd data/ && tar xvf 14112-labelled.tar.gz && cd ..


library(tensorflow)
use_python('/usr/local/bin/python')

library(keras)
####################################
# Make sure GPUs are used by keras
k = backend()
sess = k$get_session()
sess$list_devices()
####################################

setwd('~/lab-keras-r')
source("simple_cnn.R")
source("inception.R")

start <- Sys.time()
####################################
num_classes <- 1
class_mode = 'binary'
# image size to scale down to (original images are 100 x 100 px)
img_width <- 256L
img_height <- 256L
target_size <- c(img_width, img_height)
# RGB = 3 channels
channels <- 3L
####################################
# define training hyperparameters
lr=2e-4
batch_size <- 16L
epochs <- 10L



dir.train = "~/data/14112-labelled/train"
dir.val = "~/data/14112-labelled/val"
#dir.train <- '~/data/cat_dog/train_keras/'

# preprocessing_function <- function(x) {return(x - 115)}
# preprocessing_function <- inception_v3_preprocess_input
# rescale=1
preprocessing_function <- NULL 
rescale = 1/256

target_size <- c(256, 256)
class_mode <- 'binary'
classes = c('backgr', 'glom')

train_data_gen <- image_data_generator(preprocessing_function = preprocessing_function,
                                       brightness_range = c(0.8, 1.2),
                                       rotation_range = 90,
                                       width_shift_range = 0.2,
                                       height_shift_range = 0.2,
                                       shear_range = 0.2,
                                       zoom_range = c(0.8, 1.2),
                                       horizontal_flip = TRUE,
                                       vertical_flip = TRUE,
                                       fill_mode = "nearest",
                                       rescale=rescale,
)

val_data_gen <-image_data_generator(preprocessing_function = preprocessing_function,
                                    rescale=rescale,
                                    brightness_range = c(0.8, 1.2),)

train_image_array_gen <- flow_images_from_directory(dir.train, 
                                                    train_data_gen,
                                                    batch_size = batch_size,
                                                    target_size = target_size,
                                                    class_mode = class_mode,
                                                    classes = classes,
                                                    seed = 42,
                                                    shuffle = T,)

#############################
# validation images
val_image_array_gen <- flow_images_from_directory(dir.val, 
                                                    val_data_gen,
                                                    batch_size = batch_size,
                                                    target_size = target_size,
                                                    class_mode = class_mode,
                                                    classes = classes,
                                                    )

##################################

### let's inspect content of a training mini-batch
library(reticulate)
batch <- iter_next(train_image_array_gen)
batch <- iter_next(val_image_array_gen)
### the convention is that
# the 1st element of the batch is image array
# and the 2nd is label array
names(batch) <- c('images', 'labels')
# what is the dimensionality of image array in a mini-batch?
# what is the meaning of each dimension?
dim(batch$images)
max(batch$images)

# let's visualize an image from the batch
n = 2
grid::grid.raster(batch$images[n,,,])

# what is the label of this image?
batch$labels[n]
##################################
mean(train_image_array_gen$labels)

mean(val_image_array_gen$labels)

### model definition
# number of training samples
train_samples <- train_image_array_gen$n
# number of validation samples
valid_samples <- val_image_array_gen$n

####################################
# model <- build_model(img_width, img_height, channels,
#                      num_classes=1,
#                      final_activation='sigmoid')

model <- build_inception(img_width, img_height, channels, 
                         num_classes=1,
                         final_activation='sigmoid',
                         freeze_base=T)

for (layer in model$layers){print(layer$trainable)}

# for (layer in model$layers){layer$trainable=T} 

# compile
model %>% compile(
  loss = 'binary_crossentropy',
  optimizer = optimizer_adam(lr=lr, epsilon = 1e-6),
  metrics = 'accuracy'
)
# fit
history_ <- fit_generator(model,
                          # training data
                          train_image_array_gen,
                          ceiling(train_samples / batch_size), 
                          # epochs
                          epochs = as.integer(epochs),
                          workers = 1,
                          # validation data
                          validation_data = val_image_array_gen,
                          validation_steps = as.integer(valid_samples / batch_size)
                          # print progress
                          # verbose = 2,
                          # callbacks = list(
                          #   # save best model after every epoch
                          #   callback_model_checkpoint(file.path(path, "fruits_checkpoints.h5"), 
                          #                             save_best_only = TRUE),
                          #   # only needed for visualising with TensorBoard
                          #   callback_tensorboard(log_dir = file.path(path, "fruits_logs"))
                          # )
)

val_prediction = predict_generator(model, val_image_array_gen,
                  steps = ceiling(valid_samples / batch_size))

# install.packages('pROC')
library(pROC)
# auc(val_image_array_gen$labels, as.vector(val_prediction))
roc(val_image_array_gen$labels, as.vector(val_prediction), plot=T)

df_out <- history_$metrics %>% 
{data.frame(acc = .$acc[epochs], val_acc = .$val_acc[epochs], 
            elapsed_time = as.integer(Sys.time()) - as.integer(start))}



