library(keras)
mnist <- dataset_mnist()
x_train <- mnist$train$x
y_train <- mnist$train$y
x_test <- mnist$test$x
y_test <- mnist$test$y

### inspect dimensionality of x_train
dim(x_train)

## display an image
n = 100
image <- x_train[n,,] # array_reshape(x_train[n,], c(28,28))
grid::grid.raster(image/255)

# reshape
x_train <- array_reshape(x_train, c(nrow(x_train), 28,28,1))
x_test <- array_reshape(x_test, c(nrow(x_test), 28,28,1))
dim(x_train)

# rescale
x_train <- x_train / 255
x_test <- x_test / 255

y_train <- to_categorical(y_train, 10)
y_test <- to_categorical(y_test, 10)

model <- keras_model_sequential() 
model %>% 
  layer_conv_2d(256, c(3,3), activation = 'relu', input_shape = c(28,28,1)) %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_conv_2d(128, c(3,3), activation = 'relu', input_shape = c(28,28,1)) %>% 
  layer_dense(units = 128, activation = 'relu') %>%
  layer_conv_2d(128, c(3,3), activation = 'relu', input_shape = c(28,28,1)) %>% 
  layer_dropout(rate = 0.3) %>%
  layer_global_average_pooling_2d() %>%
  layer_dense(units = 10, activation = 'softmax')

summary(model)

model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = optimizer_rmsprop(),
  metrics = c('accuracy')
)

history <- model %>% fit(
  x_train, y_train, 
  epochs = 30, batch_size = 128, 
  validation_split = 0.2
)


plot(history)


