# This file imports the Basketball Monster Projections and saves dataframe

PlayerProjs <- read.csv(file="Data/BBM_Projections.csv", header=TRUE, sep=",")
save(PlayerProjs, file="Output/PlayerProjs.Rdata")
