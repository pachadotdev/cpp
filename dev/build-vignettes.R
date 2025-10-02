# Build vignettes for CRAN submission
# This script processes all .Rmd files in vignettes/ and creates the necessary
# files in inst/doc/ for CRAN package submission

# Load required libraries
library(knitr)
library(rmarkdown)

Sys.setenv("CPP4R_EVAL" = "true")

# Get all .Rmd files from vignettes directory
vignette_files <- list.files('vignettes', pattern = '\\.Rmd$', full.names = TRUE)

# Create inst/doc if it doesn't exist
dir.create('inst/doc', recursive = TRUE, showWarnings = FALSE)

# Process each vignette
for (file in vignette_files) {
  message('Processing: ', file)
  
  # Get basename without extension
  basename_file <- tools::file_path_sans_ext(basename(file))
  
  # Set working directory to vignettes for relative paths
  old_wd <- getwd()
  setwd('vignettes')
  
  tryCatch({
    # Knit to get .R file
    knitr::purl(basename(file), 
                output = file.path('..', 'inst', 'doc', paste0(basename_file, '.R')), 
                documentation = 0)
    
    # Render to HTML
    rmarkdown::render(basename(file), 
                      output_file = file.path('..', 'inst', 'doc', paste0(basename_file, '.html')),
                      quiet = TRUE)
  }, error = function(e) {
    message('Error processing ', file, ': ', e$message)
  })
  
  # Restore working directory
  setwd(old_wd)
}

# # Copy .Rmd files to inst/doc as well
# file.copy(vignette_files, 'inst/doc/', overwrite = TRUE)

# # Copy any additional files that vignettes might need
# additional_files <- c('vignettes/references.bib', 'vignettes/growth.Rds', 
#                       'vignettes/release.Rds', 'vignettes/sum.Rds')
# existing_additional <- additional_files[file.exists(additional_files)]
# if (length(existing_additional) > 0) {
#   file.copy(existing_additional, 'inst/doc/', overwrite = TRUE)
# }

# message('Vignette building complete!')
# message('Files created in inst/doc/:')
# print(list.files('inst/doc/'))
