# L05 Resampling ----
# Define and fit elastic net model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data/spotify_train.rda"))
load(here("data/spotify_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/spotify_rec_lm.rda"))
load(here("recipes/spotify_rec_lm_no.rda"))
load(here("recipes/spotify_rec_baseline.rda"))

# model specifications ----
en_spec <-
  linear_reg(penalty = tune(), mixture = tune()) |>
  set_engine("glmnet") |>
  set_mode("regression")

# define workflows ----
en_wflow_basic <-
  workflow() |> 
  add_model(en_spec) |> 
  add_recipe(spotify_rec_baseline)

en_wflow <-
  workflow() |> 
  add_model(en_spec) |> 
  add_recipe(spotify_rec_lm)

en_wflow_no <-
  workflow() |> 
  add_model(en_spec) |> 
  add_recipe(spotify_rec_lm_no)

# hyperparameter tuning values ----
hardhat::extract_parameter_set_dials(en_spec)

en_params <- parameters(en_spec)
en_grid <- grid_regular(en_params, levels = 5)

# fit workflows/models ----
set.seed(02272024)

en_tuned_basic <-
  en_wflow_basic |>
  tune_grid(
    spotify_folds,
    grid = en_grid,
    control = control_grid(save_workflow = TRUE)
  )

en_tuned <-
  en_wflow |>
  tune_grid(
    spotify_folds,
    grid = en_grid,
    control = control_grid(save_workflow = TRUE)
  )

en_tuned_no <-
  en_wflow_no |>
  tune_grid(
    spotify_folds,
    grid = en_grid,
    control = control_grid(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(en_tuned_basic, file = here("results/en_tuned_basic.rda"))
save(en_tuned, file = here("results/en_tuned.rda"))
save(en_tuned_no, file = here("results/en_tuned_no.rda"))
