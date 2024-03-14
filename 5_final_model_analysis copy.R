# Assess final model

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

# load data
load(here("data/spotify_test.rda"))

# load model
load(here("results/final_fit.rda"))

# generating predictions
spotify_test_res <- 
  predict(final_fit, new_data = spotify_test |>
            select(-track_popularity))

spotify_test_res <- 
  bind_cols(spotify_test_res, spotify_test |> 
              select(track_popularity))

# generating metrics
spotify_metrics <- metric_set(rmse, mae, mape, rsq)

spotify_metrics <- spotify_metrics(spotify_test_res, truth = track_popularity, estimate = .pred)

save(spotify_metrics, file = here("results/spotify_metrics.rda"))

# plotting
spotify_plot <- spotify_test_res |> 
  ggplot(aes(track_popularity, .pred)) +
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) +
  labs(
    x = "Actual Popularity",
    y = "Predicted Popularity",
    title = "Actual vs. Predicted Observations (Popularity)") +
  coord_obs_pred()

ggsave(filename = "results/spotify_plot.png", plot = spotify_plot)
