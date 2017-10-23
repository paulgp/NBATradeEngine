
## This file takes the output from import.R and cleans the data to prepare for analysis

## Load packages -------------------------------------------------
library(tidyverse)

## Load data -----------------------------------------------------

load(file = "Output/PlayerProjs.Rdata")

## Munge data  ---------------------------------------------------

## Field goals made per game
PlayerProjs$fgm.g = PlayerProjs$fga.g * PlayerProjs$fg.

## Free throws made per game
PlayerProjs$ftm.g = PlayerProjs$fta.g * PlayerProjs$ft.

## Construct team-level projections ------------------------------

## Calculate means across rostered players
TeamProjs <- PlayerProjs %>%
    group_by(Owner) %>%
    select(Owner, p.g, X3.g, r.g, a.g, s.g, b.g, fgm.g, fga.g, ftm.g, fta.g, to.g) %>%
    summarize_all(.funs = c(mean="mean"))

## Construct new fields for fg.g and ft.g
TeamProjs <- TeamProjs %>%
    mutate(fg.g = fgm.g_mean/ fga.g_mean, ft.g = ftm.g_mean / fta.g_mean)
