teamprojection_fun <- function(playerProj) {

    ## Collapse data from player to team level
    teamProj <- playerProj %>%
        group_by(Owner) %>%
        filter(Owner!="") %>%
        select(Owner, points = p.g, threes = X3.g, rebounds = r.g, assists = a.g, steals = s.g, blocks = b.g, fgmade = fgm.g, fgattempts = fga.g, ftmade = ftm.g, ftattempts = fta.g, turnovers  = to.g) %>%
        summarize_all(.funs = c(mean))

    ## Construct new fields for fg.g and ft.g
    teamProj <- teamProj %>%
        mutate(fgperc = fgmade/ fgattempts, ftperc = ftmade / ftattempts) %>%
        select(Owner, points, threes, rebounds, assists, steals, blocks, fgperc, ftperc, turnovers)
    return(teamProj)

}

## Calculate total columns won for each team

teamwins_fun <- function(teamProj) {

    RankedProj <- select(teamProj,-Owner) %>%
        mutate_all(funs(dense_rank(desc(-.))-1)) %>%
        mutate(.,turnovers = 12 - turnovers) %>%
        mutate(wins = rowSums(., na.rm = TRUE))
    
    teamWins <- data.frame(teamProj$Owner,RankedProj$wins)

    return(teamWins)
}

## Takes as input the ouput of teamwins_fun and an owner name and returns the team wins
## and surplus relative to the baseline projection

ownerwins_fun <- function(teamWins,Owner) {

    wins <- (teamWins %>% filter(teamProj.Owner == Owner) %>% select(RankedProj.wins))[1,1]
    surplus <- wins - (baseWins %>% filter(teamProj.Owner == Owner) %>% select(RankedProj.wins))[1,1]

    return = list(wins,surplus)

}

## Moves players from one team to another in the playerProj file

replaceplayer_fun <- function(PlayerProj,Player1,Player2) {
    
    ## Replace the owner of each player based on trade
    new <- playerProj
    new$Owner[new$Name == Player1] <- Own2
    new$Owner[new$Name == Player2] <- Own1

    return(new)
    
}
