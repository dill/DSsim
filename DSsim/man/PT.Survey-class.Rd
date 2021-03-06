% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PT.Survey.R
\docType{class}
\name{PT.Survey-class}
\alias{PT.Survey-class}
\title{Virtual Class "PT.Survey" extends class "Survey"}
\description{
Virtual Class \code{"PT.Survey"} is an S4 class containing a population
and a set of transects.
}
\section{Slots}{

\describe{
\item{\code{transect}}{Object of class \code{"Transect"}; the
transects.}

\item{\code{radial.truncation}}{Object of class \code{"numeric"}; the
maximum distance from the transect at which animals may be detected.}
}}
\section{Methods}{

\describe{
 \item{\code{create.sample.table}}{\code{signature=(object = "PT.Survey", ...)}:
 creates a sample table for \code{dht}.}
}
}
\seealso{
\code{\link{make.design}}
}
\keyword{classes}

