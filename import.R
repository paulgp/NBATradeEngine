# This file imports the Basketball Monster Projections, munges and saves dataframe

playerProj <- read.csv(file="Data/BBM_Projections.csv", header=TRUE, sep=",")

## Munge data  ----------------------------------------
                                                       
## Field goals made per game                           
playerProj$fgm.g = playerProj$fga.g * playerProj$fg.
                                                       
## Free throws made per game                           
playerProj$ftm.g = playerProj$fta.g * playerProj$ft.

save(playerProj, file="Output/playerProj.Rdata")
