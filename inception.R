library(keras)

build_inception <- function(img_width, img_height, channels,
                            num_classes = 1,
                            final_activation='sigmoid',
                            freeze_base=F){

    input_shape=c(img_width, img_height, channels)

    base_model <- application_inception_v3(input_shape=input_shape,
                                      include_top = FALSE)

#    base_model <- application_vgg16(weights = 'imagenet', include_top = FALSE, 
#                                input_shape = input_shape)
    model <- keras_model_sequential() %>%
      base_model %>%
      layer_global_average_pooling_2d() %>% 
          layer_dropout(rate = 0.3) %>%
          layer_dense(units = num_classes,
                      activation = final_activation)

    if (freeze_base) freeze_weights(base_model)
    model
}

