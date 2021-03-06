% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generic.functions.R, R/Survey.R
\docType{methods}
\name{create.region.table}
\alias{create.region.table}
\alias{create.region.table,Survey-method}
\title{S4 generic method to generate a region table}
\usage{
create.region.table(object, region)

\S4method{create.region.table}{Survey}(object, region)
}
\arguments{
\item{object}{an object of a class inheriting from Survey}

\item{region}{an object of class Region}
}
\value{
an object of class Region.Table
}
\description{
This function is called internally to generate a region table required to
estimate abundance /  density via the Hortvitz-Thompson estimator.
}

