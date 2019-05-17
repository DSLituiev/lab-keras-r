library(keras)
# initialise model
build_model <- function(img_width, img_height, channels, 
                        num_classes=1,
                        final_activation='sigmoid'){
  model <- keras_model_sequential()
  
  # add layers
  model %>% 
    layer_conv_2d(filter = 32, kernel_size = c(3,3), padding = 'same', input_shape = c(img_width, img_height, channels)) %>%
    layer_activation_leaky_relu(alpha=0.5) %>%
    
    # Second hidden layer
    layer_conv_2d(filter = 16, kernel_size = c(3,3), padding = 'same') %>%
    layer_activation_leaky_relu(alpha=0.5) %>%
    layer_batch_normalization() %>%
    
    # Use max pooling
    layer_max_pooling_2d(pool_size = c(2,2)) %>%
    layer_dropout(0.25) %>%
    
    # Flatten max filtered output into feature vector 
    # and feed into dense layer
    layer_global_average_pooling_2d() %>%
    layer_dense(100) %>%
    layer_activation_leaky_relu(alpha=0.5) %>%
    layer_dropout(0.5) %>%
    
    # Outputs from dense layer are projected onto output layer
    layer_dense(num_classes) %>% 
    layer_activation(final_activation)
}

