# Univariate/bivariate analysis ----

# Load packages
library(tidyverse)
library(here)
library(skimr)
library(janitor)

# Load data
spotify_data <- read_rds(here("data/spotify_songs.rds")) |>
  mutate(
    playlist_genre = factor(playlist_genre),
    playlist_subgenre = factor(playlist_subgenre),
    track_popularity_bins = cut(track_popularity, 
                                breaks = seq(0, 100, by = 10), 
                                include.lowest = TRUE)) |>
  relocate(track_popularity_bins) |>
  select(!c(track_id, track_name, track_album_id, track_artist, track_album_name,
            playlist_id, playlist_name, track_album_release_date))

write_rds(spotify_data, here("data/spotify_data.rds"))

## Target variable (`track_popularity`)

skim(spotify_data)
summary(spotify_data)

track_popularity_bar <- spotify_data |> 
  ggplot(aes(track_popularity_bins)) +
  geom_bar() +
  labs(
    x = "Track Popularity",
    y = "Frequency",
    title = "Track Popularity Distribution"
  )

track_popularity_density <- spotify_data |> 
  ggplot(aes(track_popularity)) +
  geom_density() +
  labs(
    x = "Track Popularity",
    y = "Frequency",
    title = "Track Popularity Density"
  )

ggsave(filename = "plots/track_popularity_bar.png", plot = track_popularity_bar)
ggsave(filename = "plots/track_popularity_density.png", plot = track_popularity_density)

## Exploring predictors

# genre - showing medium-to-strong variation
genre_boxplot <- spotify_data |> 
  ggplot(aes(playlist_genre, track_popularity)) +
  geom_boxplot()

subgenre_boxplot <- spotify_data |> 
  ggplot(aes(playlist_subgenre, track_popularity)) + 
  geom_boxplot() +
  facet_wrap(~ playlist_genre, scales = "free") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(
    title = "Track Popularity by Genre"
  )

ggsave(filename = "plots/genre_boxplot.png", plot = genre_boxplot)
ggsave(filename = "plots/subgenre_boxplot.png", plot = subgenre_boxplot)

# actual composition - variables that appear to show medium-to-strong correlation 
# w/ track_popularity: (danceability, energy, speechiness, acousticness, instrumentalness,
# liveness, tempo, duration_ms)
spotify_data |> 
  ggplot(aes(track_popularity_bins, duration_ms)) +
  geom_boxplot() 

## Exploring interactions between predictors
spotify_data |> 
  ggplot(aes(energy, acousticness)) +
  geom_jitter()

spotify_data |> 
  ggplot(aes(energy, instrumentalness)) +
  geom_jitter()


