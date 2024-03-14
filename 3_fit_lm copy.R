# Model Tuning ----
# Define and fit linear regression model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data/spotify_train.rda"))
load(here("data/spotify_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/spotify_rec_baseline.rda"))
load(here("recipes/spotify_rec_lm.rda"))
load(here("recipes/spotify_rec_lm_no.rda"))

# model specifications ----
lm_spec <- 
  linear_reg() |>
  set_mode("regression") |>
  set_engine("lm")

# define workflows ----

lm_wflow_basic <-
  workflow() |>
  add_model(lm_spec) |> 
  add_recipe(spotify_rec_baseline)

lm_wflow <-
  workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(spotify_rec_lm)

lm_no_wflow <-
  workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(spotify_rec_lm_no)

# fit workflows/models ----
lm_fit_basic <-
  lm_wflow_basic |> 
  fit_resamples(
    resamples = spotify_folds,
    control = control_resamples(save_workflow = TRUE)
  )

lm_fit <- 
  lm_wflow |>
  fit_resamples(
    resamples = spotify_folds, 
    control = control_resamples(save_workflow = TRUE))

lm_fit_no <- 
  lm_no_wflow |>
  fit_resamples(
    resamples = spotify_folds, 
    control = control_resamples(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(lm_fit, file = here("results/lm_fit.rda"))
save(lm_fit_no, file = here("results/lm_fit_no.rda"))
save(lm_fit_basic, file = here("results/lm_fit_basic.rda"))


