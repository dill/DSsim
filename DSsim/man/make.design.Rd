% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Class.Constructors.R
\name{make.design}
\alias{make.design}
\title{Creates a Survey.Design object}
\usage{
make.design(transect.type = "line", design.details = "default",
  region.obj = "region", design.axis = 0, spacing = 100,
  nested.space = numeric(0), no.complex = numeric(0), angle = numeric(0),
  plus.sampling = logical(0), path = character(0))
}
\arguments{
\item{transect.type}{character variable specifying either "Line" or "Point"}

\item{design.details}{a character vector describing the type of design. See details section.}

\item{region.obj}{the character name of the Region object where the survey is to be carried out.}

\item{design.axis}{user may provide the angle of the design axis but not currently used}

\item{spacing}{user may provide the systematic design spacing but but not currently used}

\item{nested.space}{the number of spaces between nested points. If spacing = 1 then all points on the systematic design will be sepected.}

\item{no.complex}{the number of complex detectors to distribute based on simple random sampling of the systematic grid of detectors.}

\item{angle}{user may provide the design angle (only relevant in equal angle zigzag designs) but not currently used}

\item{plus.sampling}{logical vaule indicating whether a plus sampling protocol is used but not currently used}

\item{path}{pathway giving the location of the folder of survey shapefiles}
}
\value{
object of a class which inherits from class Survey.Design
}
\description{
Currently surveys are only generated within the GIS in Distance. If you 
are running a simulation in R you will need to get Distance to 
generate all the surveys as shapefiles in advance and supply the path to
the directory which contains these shapefiles and only these shapefiles.
}
\details{
The \code{design.details} argument should specify a character vector of either 1
or 2 elements. These options are described in the table below:

\tabular{lll}{ Transect Type \tab Design Details \tab               \cr 
               Line          \tab Parallel       \tab Systematic    \cr
               Line          \tab Parallel       \tab Random        \cr
               Line          \tab Zigzag         \tab Equal Angle   \cr
               Line          \tab Zigzag         \tab Equal Spaced  \cr
               Line          \tab User Specified \tab               \cr
               Point         \tab Systematic     \tab               \cr
               Point         \tab Random         \tab               \cr
               Point         \tab Nested         \tab               \cr}
}
\examples{
# DSsim can generate a systematic set of parallel line transects which by default have a 
# spacing of 100
design <- make.design("line")

# The easiest way to generate the transect is by creating a simulation (default simulations 
#create a line transect design)
sim <- make.simulation()
transects <- generate.transects(sim)
plot(make.region())
plot(transects, col = 4, lwd = 2)

# DSsim can generate a systematic grid of point transects which by default have a spacing of 100
design <- make.design("point")

sim <- make.simulation(design.obj = design)
transects <- generate.transects(sim)
plot(make.region())
plot(transects)

# More complex designs can be defined in Distance for Windows. This software can then generate
# multiple survey instances and store them as shapefiles for use by DSsim. The shapefile below 
# was generated in this way.

\dontrun{

coords <- gaps <- list()
coords[[1]] <- list(data.frame(x = c(0,1000,1000,0,0), y = c(0,0,
 1000,1000,0)))
gaps[[1]] <- list(data.frame(x = c(400,600,500,350,400), y = c(100,
 250,600,120,100)))
region <- make.region(region.name = "study.area", units = "m", 
 coords = coords, gaps = gaps)
 
data(transects.shp)
#Edit the pathway below to point to an empty folder where the
#transect shapefile will be saved
shapefile.pathway <- "C:/..."
library(shapefiles)
write.shapefile(transects.shp, paste(shapefile.pathway,"/transects_1",
 sep = ""))

# This design was created in Distance for Windows in a region with the same dimensions as the
# deault make.region().
parallel.design <- make.design(transect.type = "Line", 
 design.details = c("Parallel","Systematic"), region = region, 
 design.axis = 0, spacing = 100, plus.sampling =FALSE, 
 path = shapefile.pathway)

# As there is only one set of transects we have to set single.transect.set = TRUE
sim <- make.simulation(single.transect.set = TRUE, design.obj = parallel.design)
transects <- generate.transects(sim)
plot(region)
plot(transects, col = 4, lwd = 2)
}
}
\author{
Laura Marshall
}

