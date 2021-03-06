#' @include generic.functions.R
#' @include Survey.Design.R

#' @title Virtual Class "LT.Design" extends Class "Survey.Design"
#'
#' @description Virtual Class \code{"LT.Design"} is an S4 class detailing the type of 
#' line transect design.
#' @name LT.Design-class
#' @title S4 Class "LT.Design"
#' @section Methods:
#' \describe{
#'  \item{\code{generate.transects}}{\code{signature=(object = "LT.Design", ...)}:
#'  loads a set of transects from a shapefile.}
#' }
#' @keywords classes
#' @seealso \code{\link{make.design}}
#' @export
setClass(Class = "LT.Design",
         representation = representation("VIRTUAL"),
         contains = "Survey.Design"
)

# GENERIC METHODS DEFINITIONS --------------------------------------------

#' @rdname generate.transects-methods
#' @importFrom utils read.table
#' @export
setMethod(
  f="generate.transects",
  signature="LT.Design",
  definition=function(object, region = NULL, index = NULL){
    if(is.null(region) | class(region) != "Region"){
      region <- object@region.obj
      region <- get(region, pos = 1)
    }
    # Check that user has supplied a path to shapefiles
    if(length(object@path) == 0){
      read.from.file = FALSE
    }else if(length(object@path) > 0){
      read.from.file = TRUE
    }
    file.index <- ifelse(is.null(index), object@file.index, index)
    #Input pre-processing
    if(read.from.file){
      #Load the shapefle
      shapefile <- shapefiles::read.shapefile(paste(object@path, "/", object@filenames[file.index], sep=""))
      if(length(shapefile$shp$shp) == 0){
        warning("Survey transect shapefile has no transects.", call. = FALSE, immediate. = TRUE)
        dd <- data.frame(Id=c(1,1),X=c(1,1),Y=c(1,1))
        dd.table <- data.frame(Id=c(1),Name=c("1"))
        shapefile <- shapefiles::convert.to.shapefile(dd, dd.table, "Id", 3)
        meta <- data.frame(V1 = as.factor(object@filenames[file.index]), V2 = 1, V3 = 1)  
      #Check the shapefile is the correct type
      }else if(!shapefile$shp$header$shape.type %in% c(3,13,23)){
        warning("Survey transect shapefile of wrong shapefile type (not lines) cannot load survey.", call. = FALSE, immediate. = TRUE)
        dd <- data.frame(Id=c(1,1),X=c(1,1),Y=c(1,1))
        dd.table <- data.frame(Id=c(1),Name=c("1"))
        shapefile <- shapefiles::convert.to.shapefile(dd, dd.table, "Id", 3)
        meta <- data.frame(V1 = as.factor(object@filenames[file.index]), V2 = 1, V3 = 1)
      }else{
        #Load the meta file if it exists - describes which transects are in which strata
        meta <- suppressWarnings(try(read.table(paste(object@path, "/Meta.txt", sep="")), silent = TRUE))
        if(class(meta) == "try-error"){
          meta <- NULL
        }
        if(!is.null(meta)){
          meta <- meta[meta[,1] == object@filenames[file.index],]
        }  
      }
      line.transect <- new(Class = "Line.Transect", region = region, shapefile = shapefile, meta = meta)
    }else{
      stop("Only pre-generated surveys are currently implemented for this design.", call. = FALSE)
    }
    return(line.transect)
  }
)







