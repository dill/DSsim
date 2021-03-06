#' @include generic.functions.R
#' @include Density.R

#' @title Class "Population.Description"
#'
#' @description Class \code{"Population.Description"} is an S4 class containing a
#' description of the population. It provides methods to generate an
#' example population.
#'
#' @name Population.Description-class
#' @title S4 Class "Population.Description"
#' @slot N Object of class \code{"numeric"}; number of individuals
#' in the population (optional).
#' @slot density Object of class \code{"Density"}; describes the
#' population density
#' @slot region.name Object of class \code{"character"}; name of
#' the region in which the population exists.
#' @slot strata.names Character vector giving the strata names for the study region.
#' @slot covariates Named list with one named entry per individual level covariate.
#' Cluster sizes can be defined here. Each list entry will either be a data.frame 
#' containing 2 columns, the first the level (level) and the second the probability 
#' @slot size logical value indicating whether the population occurs in 
#' clusters.
#' (prob). The cluster size entry in the list must be named 'size'.
#' @slot gen.by.N Object of class \code{"logical"}; If \code{TRUE}
#' N is fixed otherwise it is generated from a Poisson distribution.
#' @slot D.dist Object of class \code{character}; Describes the
#' density distribution (currently not implemented).
#' @section Methods:
#' \describe{
#'  \item{\code{get.N}}{\code{signature=(object = "Population.Description")}:
#'  returns the value of \code{N}}
#'  \item{\code{generate.population}}{\code{signature=(object = "Population.Description")}: generates a single realisation of the population.}
#' }
#' @keywords classes
#' @export
#' @seealso \code{\link{make.population.description}}
setClass("Population.Description", representation(N            = "numeric",
                                                  density      = "Density",
                                                  region.name  = "character",
                                                  strata.names = "character",
                                                  covariates   = "list",
                                                  size         = "logical",
                                                  gen.by.N     = "logical",
                                                  D.dist       = "character"))
setMethod(
  f="initialize",
  signature="Population.Description",
  definition=function(.Object, N, density, region.obj, size.table, size, covariates, gen.by.N = TRUE, D.dist = character(0)){
    #Input pre-processing
    if(!gen.by.N){
      ave.density <- NULL
      #Calculate average density for each strata.
      for(strat in seq(along = density@density.surface)){
        ave.density[strat] <- get.ave.density(density.surface = density@density.surface[[strat]], coords = region.obj@coords[[strat]], gaps = region.obj@gaps[[strat]], x.space = density@x.space, y.space = density@y.space)
      }
      N <- region.obj@area*ave.density
    }
    # Check if there are clusters
    cov.names <- names(covariates)
    size <- "size" %in% cov.names
    #Set slots
    .Object@N            <- N
    .Object@density      <- density
    .Object@region.name  <- region.obj@region.name
    .Object@strata.names <- region.obj@strata.name
    .Object@covariates   <- covariates
    .Object@size         <- size
    .Object@gen.by.N     <- gen.by.N
    .Object@D.dist       <- D.dist
    #Check object is valid
    validObject(.Object)
    # return object
    return(.Object)
  }
)
setValidity("Population.Description",
  function(object){
    if(length(object@N) > 0 & sum(object@N) <= 0){
      return("You must provide a positive, non-zero abundance")
    }
    return(TRUE)
  }
)

# GENERIC METHODS DEFINITIONS --------------------------------------------

#' S4 generic method to return N
#'
#' Returns the population size
#'
#' @param object an object of class Population.Description
#' @return numeric value of the population size
#' @export
#' @rdname get.N-methods
setGeneric("get.N",function(object){standardGeneric ("get.N")})

#' @rdname get.N-methods
#' @export
setMethod("get.N","Population.Description",
  function(object){
    return(object@N)
  }
)

#' @rdname generate.population-methods
#' @export
setMethod(
  f="generate.population",
  signature="Population.Description",
  definition=function(object, detectability, region.obj = NULL){
    #If the user has not passed in the region object
    if(class(region.obj) != "Region"){
      warning("Trying to obtain region object from the global workspace", call. = TRUE, immediate. = TRUE)
      region.obj <- get(object@region.name)
    }
    #If the population has fixed N
    if(object@gen.by.N){
      all.grid.locations <- generate.pop.N(object, region.obj)
    }else{
      all.grid.locations <- generate.pop.D(object, region.obj)

    }
    N <- nrow(all.grid.locations)
    # Make population data.frame
    population.dataframe <- data.frame(object = 1:nrow(all.grid.locations), x = all.grid.locations$x.coord, y = all.grid.locations$y.coord, strata = all.grid.locations$strata)
    # Add covariate values
    if(length(object@covariates) > 0){
      population.dataframe <- add.covariate.values(population.dataframe, object@covariates)
    }
    # Add scale parameter values
    population.dataframe <- calculate.scale.param(population.dataframe, detectability, region.obj)
    # Make population object
    population <- new(Class = "Population", region = object@region.name, strata.names = region.obj@region.name, N = N, D = N/region.obj@area, population = population.dataframe, detectability = detectability)
    return(population)
  }
)


