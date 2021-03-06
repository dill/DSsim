#' @import methods 
#' @import mrds
NULL

#' S4 generic method to generate an instance of a population
#'
#' Uses the population description and detectability details to generate an 
#' instance of the population. Note that if the first argument supplied is 
#' of class Population.Description rather than class Simulation then a second 
#' argument \code{detectabity} must also be supplied and must be an object of 
#' class Detectability.
#'
#' @param object an object of class Simulation or Population.Description
#' @param detectability object of class Detectability (optional - only
#'   required if object is of class Population.Description) 
#' @param region.obj the region object for the population (optional - only
#'   required if object is of class Population.Description)
#' @param ... when this is called on an object of class Population.Description
#' the additional arguments detectability and region.obj should also be supplied
#' @return an object of class Population
#' @export
#' @rdname generate.population-methods
setGeneric("generate.population", function(object, ...){standardGeneric ("generate.population")})

#' S4 generic method to generate an instance of a design
#'
#' Uses the Survey.Design details to generate transects. Currenty this 
#' involves loading a survey shapefile from the path specified in the 
#' Survey.Design object and can only work with line transect designs.
#'
#' @param object an object of class Simulation or a class which inherits from 
#'   Survey.Design
#' @param region optional only required if object is of class Survey.Design.
#' @param index specifies which set of transect should be loaded
#' @param ... optional argument index if an object of class Survey.Design is 
#' supplied allowing the user to access / plot different sets of transects
#' listed in the filenames slot. 
#' @return an object of class Line.Transect
#' @export
#' @rdname generate.transects-methods
setGeneric("generate.transects", function(object, region = NULL, ...){standardGeneric ("generate.transects")})

#' S4 generic method to generate a region table
#'
#' This function is called internally to generate a region table required to
#' estimate abundance /  density via the Hortvitz-Thompson estimator.
#'
#' @param object an object of a class inheriting from Survey
#' @param region an object of class Region
#' @return an object of class Region.Table
#' @rdname create.region.table-methods
setGeneric(name = "create.region.table", def = function(object, region){standardGeneric ("create.region.table")})

#' S4 generic method to generate a sample table
#'
#' This function is called internally to generates a sample table required to
#' estimate abundance /  density via the Hortvitz-Thompson estimator.
#'
#' @param object an object of a class inheriting from Survey
#' @return an object of class Sample.Table
#' @rdname create.sample.table-methods
setGeneric(name = "create.sample.table", def = function(object){standardGeneric ("create.sample.table")}) 

#' S4 generic method to simulate a survey
#'
#' Simulates the process by which individuals / clusters are detected. 
#' Currently this is only implemented for line transect surveys. It returns an 
#' object of class LT.Survey.Results which contains a population, a set of 
#' transects, distance data and if requested region, sample and obs tables. 
#' 
#' This object can be displayed using \code{plot()} or the distance data
#' extracted using \code{get.distance.data()}. You can then investigate 
#' fitting models to this data.
#'
#' @param object an object of class Simulation
#' @param dht.tables logical value indicating whether or the data 
#' tables for Hortvitz-Thompson estimation are required.
#' @param ... allows a region object to be passed in
#' @return an object of class LT.Survey.Results
#' @export
#' @rdname create.survey.results-methods
#' @examples
#' \dontrun{
#' survey.results <- create.survey.results(simulation, dht.table = TRUE)
#' 
#' plot(survey.results)
#' }
#' 
setGeneric(name = "create.survey.results", def = function(object, dht.tables = FALSE, ...){standardGeneric ("create.survey.results")})

#' S4 generic method to extract distance data
#'
#' Extracts distance data from a Survey.Results object
#'
#' @param object an object of class LT.Survey.Results
#' @return a data.frame describing the distance data
#' @export
#' @rdname get.distance.data-methods
#' @seealso \code{\link{create.survey.results}}
setGeneric(name = "get.distance.data", def = function(object){standardGeneric ("get.distance.data")})

#' S4 generic method to add a hotspot to the density grid
#'
#' Uses a Gaussian decay around a central location to add a hotspot to the 
#' density grid.
#'
#' @param object an object of class Density or Simulation
#' @param centre an x,y-coordinate giving the centre of the hotspot
#' @param sigma a value giving the scale parameter for a gaussian decay
#' @param amplitude the height of the hotspot at its centre
#' @return the updated Density or Simulation object
#' @export
#' @rdname add.hotspot-methods
#' @seealso \code{\link{make.density}}
setGeneric(name = "add.hotspot", def = function(object, centre, sigma, amplitude){standardGeneric ("add.hotspot")})

#' S4 generic method to run a simulation
#' 
#' Runs the simulation and returns the simulation object with results. If
#' running in parallel and max.cores is not specified it will default to using
#' one less than the number of cores / threads on your machine.
#'
#' @param object an object of class Simulation
#' @param run.parallel logical option to use multiple processors
#' @param max.cores integer maximum number of cores to use, if not specified then
#' one less than the number available will be used.
#' @param save.data logical allows the datasets from the simulation to be 
#' saved to file
#' @param load.data logical allows the datasets to be loaded from file rather than
#' simulated afresh.
#' @param data.path character file path to the data files.
#' @param counter logical can be used to turn off simulation counter when running in serial.
#' @param ... allows the four previous optional arguments to be specified
#' @return an object of class simulation which now includes the results
#' @export
#' @rdname run-methods
#' @seealso \code{\link{make.simulation}}
setGeneric(name = "run", def = function(object, run.parallel = FALSE, max.cores = NA, ...){standardGeneric ("run")})

#' S4 generic method to run analyses
#'
#' This method carries out an analysis of distance sampling data. This method
#' is provided to allow the user to perform diagnostics of the analyses used
#' in the simulation. The data argument can be obtained by a call to
#' \code{simulate.survey(object, dht.table = TRUE)}. Note if the first object
#' supplied is of class DDf.Analysis then the second argument must be of class
#' DDf.Data. The data argument may be of either class for an object argument
#' of class Simulation.
#'
#' @param object an object of class Simulation or DDF.Analysis
#' @param data an object of class Survey.Results or DDF.Data
#' @param ... optional arguments including the following:
#' @param dht logical whether density should be estimated after fitting the model
#' @return a list containing an S3 ddf object and optionally an S3 dht object relating to the model with the miminum criteria.
#' @export
#' @rdname run.analysis-methods
setGeneric(name = "run.analysis", def = function(object, data, ...){standardGeneric ("run.analysis")})


if (!isGeneric("plot")){
  setGeneric(name = "plot", def = function(x, y, ...){standardGeneric("plot")})
}

if (!isGeneric("summary")){
  setGeneric(name = "summary", def = function(object, ...){standardGeneric("summary")})
}

if (!isGeneric("show")){
  setGeneric(name = "show", def = function(object){standardGeneric("show")})
}


