% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ordESS.r
\name{ordESS}
\alias{ordESS}
\title{ordESS}
\usage{
ordESS(fit)
}
\arguments{
\item{fit}{a model fitted by \code{orm} with \verb{y=TRUE, lpe=TRUE}}
}
\value{
a \code{ggplot2} object
}
\description{
Ordinal Model Effective Sample Size
}
\details{
For a standard ordinal model fitted with \code{orm}, returns the effective sample size (ESS) component of the \code{stats} part of the fit object if there were no censored data.  Otherwise \code{ordESS} assumes that \code{y=TRUE} and \code{lpe=TRUE} were given to \code{orm}, and an analysis of the effective sample size per censored observation is given, as a function of the censoring time, or in the case of interval censored data, o function of the width of the interval.
}
\examples{
\dontrun{
f <- orm(Ocens(y1, y2) ~ x, y=TRUE, lpe=TRUE)
ordESS(f)
}
}
\author{
Frank Harrell
}
