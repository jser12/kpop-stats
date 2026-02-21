library(magick)
library(tools)

img_path <- "logos/members"

convert_img <- function(dir_path, format = "png", resize = FALSE, img_size = 512) {
  # output directory for converted images
  dir_conv <- file.path(dir_path, format)
  
  # list image files based on format
  img_formats <- "\\.(png|webp|jpe?g|svg|gif)$"
  imgs_convert <- list.files(dir_path, pattern = img_formats, recursive = FALSE, full.names = TRUE, ignore.case = TRUE)
  if(length(imgs_convert) == 0) {stop("No images found in directory.")}
  
  # create output folder for particular format
  if(!dir.exists(dir_conv)) {dir.create(dir_conv)}
  
  # loop params
  replace <- ""
  i <- 0
  
  # convert images
  for (img_path in imgs_convert) {
    i <- i + 1
    remaining <- length(imgs_convert) - i
    
    new_file <- file.path(dir_conv, paste0(file_path_sans_ext(basename(img_path)), ".", format))
    
    # check if file exists
    if(file.exists(new_file) && replace != "all") {
      # skip file if exists and replace input was "none"
      if(replace == "none") {
        message("Skipping ", basename(new_file), " as it already exists. Files remaining: ", remaining)
        next
      }
      
      # Prompt whether to replace file(s)
      ans <- readline(paste0("File ", basename(new_file), " already exists. Replace? [Y/N/ALL/NONE]"))
      ans <- tolower(ans)
      
      # set replace param to "all" or "none" based on replace input (memory for future iterations)
      if (ans == "all") {
        replace <- "all"
      } else if (ans == "none") {
        replace <- "none"
        next
      # skip file if replace input is "n"
      } else if (ans == "n") {
        message("Skipping ", basename(new_file), " as it already exists. Files remaining: ", remaining)
        next
      }
    }
    
    # read image and adapt size
    img <- image_read(img_path)
    
    # resize image if enabled
    if(resize) {
      img <- img %>%
        image_scale(paste0(img_size, "x", img_size, ">")) %>%
        image_strip()
    } 
    
    # save image
    image_write(img, new_file, format = format, quality = 90)
    
    message(basename(img_path), " converted to ", basename(new_file), ". Files remaining: ", remaining)
    
  }
  
  message("[All files successfully converted.]")
}

convert_img(img_path, format = "png", resize = TRUE, img_size = 512)