# Train final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# parallel processing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# parallel processing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores - 2)

# load data
load(here("data/spotify_train.rda"))

# load model
load(here("results/boost_tuned.rda"))

# finalize workflow ----
final_wflow <- boost_tuned |> 
  extract_workflow(boost_tuned) |>  
  finalize_workflow(select_best(boost_tuned, metric = "rmse"))

# train final model ----
# set seed
set.seed(02272024)

final_fit <- fit(final_wflow, spotify_train)
save(final_fit, file = here("results/final_fit.rda"))


