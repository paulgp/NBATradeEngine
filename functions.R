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
