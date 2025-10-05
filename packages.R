# Install CRAN packages
cran_packages <- c(
  "afex", "bookdown", "boot", "broom", "broom.mixed", "car", "caret", "cobalt",
  "corrplot", "data.table", "dbarts", "devtools", "DiagrammeR", "DiagrammeRsvg",
  "dplyr", "DT", "DataExplorer", "DescTools", "factoextra", "flextable",
  "foreign", "gee", "geepack", "ggplot2", "ggpubr", "ggstance", "GGally",
  "gitcreds", "glmnet", "gt", "gtsummary", "Hmisc", "HSAUR2", "huxtable",
  "interactionR", "interactions", "janitor", "jtools", "kableExtra", "knitr",
  "lawstat", "lme4", "magrittr", "markdown", "MatchIt", "Matching", "Matrix",
  "mice", "miceadds", "misty", "mitools", "mlr3misc", "modelsummary", "MuMIn",
  "naniar", "nhanesA", "nnet", "olsrr", "optmatch", "pacman", "parallel",
  "plotrix", "plyr", "png", "psych", "purrr", "Publish", "randomForest",
  "ranger", "rattle", "readr", "remotes", "reshape2", "rio", "rmarkdown",
  "rms", "ROCR", "rpart", "rpart.plot", "rsimsum", "rsvg", "rticles",
  "RColorBrewer", "samplesizeCMH", "scoring", "shiny",
  "sjstats", "skimr", "stargazer", "stringr", "SuperLearner",
  "survey", "survival", "survminer", "svglite", "svyVGAM", "table1",
  "tableone", "texreg", "tidyverse", "tinytex", "tmle", "tweetrmd", "usethis",
  "VGAM", "VIM", "visdat", "mvnmle", "MissMech"
)

install.packages(setdiff(cran_packages, rownames(installed.packages())))

# Install GitHub packages
if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")

github_packages <- c(
  "osofr/simcausal",
  "tdhock/WeightedROC"
  # "warnes/SASxport"
)

for (repo in github_packages) {
  remotes::install_github(repo, upgrade = "never")
}

# unlink(list.dirs(".", 
#                  recursive = TRUE, 
#                  full.names = TRUE)[grepl("_cache$", 
#                                           list.dirs(".", recursive = TRUE))],
#        recursive = TRUE, force = TRUE)
