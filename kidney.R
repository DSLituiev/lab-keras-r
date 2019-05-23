
library(reticulate)
use_python('/usr/local/bin/python')
#install.packages('keras')

library(keras)
input <- layer_input(shape=c(256, 256, 3))
base.inception <- application_inception_v3(include_top = F)
base.inception.output <-  input %>% base.inception


inception.output <- base.inception.output %>%
  layer_global_average_pooling_2d() %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 1, activation = 'sigmoid')

inception <-  keras_model(input, inception.output)
summary(inception)

inception %>% compile(loss='binary_crossentropy', optimizer='Adam')

dir.train = "14112-labelled/train"
img.gen.obj.train <-image_data_generator(preprocessing_function = function(x){x/256 })
img.gen.train <- img.gen.obj.train$flow_from_directory(dir.train, batch_size = as.integer(8),
                                                       shuffle = T)

dir.val = "14112-labelled/val"
img.gen.obj.val <-image_data_generator(preprocessing_function = function(x){x/256 })
img.gen.val <- img.gen.obj.val$flow_from_directory(dir.val, batch_size = as.integer(8))

### let's inspect content of a training mini-batch
library(reticulate)
batch <- iter_next(train_image_array_gen)
### the convention is that
# the 1st element of the batch is image array 
# and the 2nd is label array
names(batch) <- c('images', 'labels')
# what is the dimensionality of image array in a mini-batch?
# what is the meaning of each dimension?
dim(batch$images)


# let's visualize an image from the batch
n = 2
grid::grid.raster(batch$images[n,,,])
# what is the label of this image?
batch$labels[n]

inception$fit_generator(img.gen.train,
                        validation_data = img.gen.val,
                        validation_steps=8)

summary(inception)
