library(ggplot2)
library(tidyr)
library(dplyr)
library(readr)


# Plotting functions ------------------------------------------------------

plot_data_prep <- function(data) {
  data |> 
    drop_na(line_number) |> 
    mutate(act_scene = paste(act, scene)) |> 
    count(act_scene) |> 
    mutate(act_scene = factor(act_scene, levels = act_scene))
}

plot_play <- function(data, title) {
  plot_data_prep(data) |> 
    ggplot() +
    geom_col(mapping = aes(x = n, y = act_scene)) +
    scale_y_discrete(limits = rev) +
    labs(x= "Number of lines", y = "", title = title) +
    theme_minimal() +
    theme(plot.title.position = "plot")
}


# Read data ---------------------------------------------------------------

hamlet <- read_csv("data/hamlet.csv")
othello <- read_csv("data/othello.csv")
macbeth <- read_csv("data/macbeth.csv")
romeo_juliet <- read_csv("data/romeo_juliet.csv")


# Plots -------------------------------------------------------------------

plot_play(hamlet, "Hamlet")
ggsave("plots/hamlet.png", width = 5, height = 5, bg = "white")

plot_play(othello, "Othello")
ggsave("plots/othello.png", width = 5, height = 5, bg = "white")

plot_play(macbeth, "Macbeth")
ggsave("plots/macbeth.png", width = 5, height = 5, bg = "white")

plot_play(romeo_juliet, "Romeo and Juliet")
ggsave("plots/romeo_juliet.png", width = 5, height = 5, bg = "white")
