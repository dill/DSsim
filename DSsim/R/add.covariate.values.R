add.covariate.values <- function(pop.data, covariates){
  # Find number of strata
  strata.ids <- unique(pop.data$strata)
  # Divide population data up by strata
  list.data <- list()
  for(strat in seq(along = strata.ids)){
    list.data[[strata.ids[strat]]] <- pop.data[pop.data$strata == strata.ids[strat],] 
  }
  # Add covariates strata by strata
  cov.names <- names(covariates)
  for(cov in seq(along = covariates)){
    for(strat in seq(along = strata.ids)){
      # Get the covariate info
      current.cov <- covariates[[cov]][[strata.ids[strat]]]
      n.vals <- nrow(list.data[[strata.ids[strat]]])
      if(class(current.cov) == "data.frame"){
        cov.values <- sample(current.cov$level, n.vals, replace = TRUE, prob = current.cov$prob)
        list.data[[strata.ids[strat]]][[cov.names[cov]]] <- cov.values
      }else if(class(current.cov) == "list"){
        distribution <- current.cov[[1]]
        params <- current.cov[[2]]
        cov.values <- switch(distribution,
                             normal = rnorm(n.vals, mean = params$mean, sd = params$sd),
                             poisson = rpois(n.vals, lambda = params$lambda),
                             ztruncpois = rtpois(n.vals, mean = params$mean),
                             lognormal = rlnorm(n.vals, meanlog = params$meanlog, sdlog = params$sdlog))
        list.data[[strata.ids[strat]]][[cov.names[cov]]] <- cov.values
      }
    }
  }
  # Put data back together
  for(strat in seq(along = list.data)){
    if(strat == 1){
      new.pop.data <- list.data[[strata.ids[strat]]]
    }else{
      new.pop.data <- rbind(new.pop.data, list.data[[strata.ids[strat]]])
    }
  }
  return(new.pop.data)    
}