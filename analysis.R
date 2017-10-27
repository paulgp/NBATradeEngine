## File simulates all possible trades and for each simulation recalculates the total winnings

## Load functions
source("functions.R")

## Load output from import.R step
load("Output/playerProj.Rdata")
playerProj$Owner <- as.character(playerProj$Owner)

## Estimate baseline standings
baseProj <- teamprojection_fun(playerProj)
baseWins <- teamwins_fun(baseProj)

## Loop through possible trades

Player1_vec <- combn(playerProj$Name,2)[1,]
Player2_vec <- combn(playerProj$Name,2)[2,]

## Initialize vectors for results
Own1_vec <- vector(, length=length(Player1_vec))
Own2_vec<- vector(, length=length(Player2_vec))
Own1Wins_vec<- vector(, length=length(Player1_vec))
Own2Wins_vec<- vector(, length=length(Player2_vec))
Own1Surplus_vec<- vector(, length=length(Player1_vec))
Own2Surplus_vec<- vector(, length=length(Player2_vec))

## Initialize counter

for (i in 1:length(Player1_vec)) {

    Player1 <- Player1_vec[i]
    Player2 <- Player2_vec[i]
    
    ## Identify owners
    Own1 <- (playerProj %>% filter(Name==Player1) %>% select(Owner))[1,1]
    Own2 <- (playerProj %>% filter(Name==Player2) %>% select(Owner))[1,1]
    
    ## Swap players and update the playerProj
    tradePlayerProj <- replaceplayer_fun(playerProj,Player1,Player2)
    
    ## Reconstruct projections with simulated trade
    tradeProj <- teamprojection_fun(tradePlayerProj)
    tradeWins <- teamwins_fun(tradeProj)
    
    ## Calculate surplus for each owner
    Own1Wins <- ownerwins_fun(tradeWins,Own1)[[1]]
    Own1Surplus <- ownerwins_fun(tradeWins,Own1)[[2]]
    
    Own2Wins <- ownerwins_fun(tradeWins,Own2)[[1]]
    Own2Surplus <- ownerwins_fun(tradeWins,Own2)[[2]]
    
    ## Append values to vectors
    Own1_vec[i] <- Own1
    Own2_vec[i] <- Own2
    Own1Wins_vec[i] <- Own1Wins
    Own2Wins_vec[i] <- Own2Wins
    Own1Surplus_vec[i] <- Own1Surplus
    Own2Surplus_vec[i] <- Own2Surplus
   
}

df <- data.frame(Player1 = Player1_vec, Player2 = Player2_vec, Own1 = Own1_vec, Own2 = Own2_vec, Own1Wins = Own1Wins_vec, Own2Wins = Own2Wins_vec, Own1Surplus = Own1Surplus_vec, Own2Surplus = Own2Surplus_vec)

df$TotSurplus = rowSums(df[,c('Own1Surplus','Own2Surplus')])

df2 <- plyr::rename(df, c("Player1"="Player2", "Player2"="Player1","Own1"="Own2","Own2"="Own1","Own1Wins"="Own2Wins","Own2Wins"="Own1Wins","Own1Surplus"="Own2Surplus","Own2Surplus"="Own1Surplus"))

df_final = rbind(df,df2)

write.csv(df_final,"Output/Trades1for1.csv")
