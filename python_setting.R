install.packages("reticulate", repos = "http://cran.us.r-project.org", dependencies = TRUE)

library(reticulate)
reticulate::install_miniconda()
conda_list()
use_condaenv("r-reticulate")

install.packages("tensorflow", repos = "http://cran.us.r-project.org")

library(tensorflow)
install_tensorflow()

install.packages("keras", repos = "http://cran.us.r-project.org")
library(keras)
