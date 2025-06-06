% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Ocens.r
\name{as.data.frame.Ocens}
\alias{as.data.frame.Ocens}
\title{Convert `Ocens` Object to Data Frame to Facilitate Subset}
\usage{
\method{as.data.frame}{Ocens}(x, row.names = NULL, optional = FALSE, ...)
}
\arguments{
\item{x}{an `Ocens` object}

\item{row.names}{optional vector of row names}

\item{optional}{set to `TRUE` if needed}

\item{...}{ignored}
}
\value{
data frame containing a 2-column integer matrix with attributes
}
\description{
Converts an `Ocens` object to a data frame so that subsetting will preserve all needed attributes
}
\author{
Frank Harrell
}
