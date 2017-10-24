# This file imports the Basketball Monster Projections, munges and saves dataframe

PlayerProjs <- read.csv(file="Data/BBM_Projections.csv", header=TRUE, sep=",")

## Munge data  ----------------------------------------
                                                       
## Field goals made per game                           
PlayerProjs$fgm.g = PlayerProjs$fga.g * PlayerProjs$fg.
                                                       
## Free throws made per game                           
PlayerProjs$ftm.g = PlayerProjs$fta.g * PlayerProjs$ft.

save(PlayerProjs, file="Output/PlayerProjs.Rdata")
