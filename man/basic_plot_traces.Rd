% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.R
\name{basic_plot_traces}
\alias{basic_plot_traces}
\title{Plot pMCMC traces of basic model.}
\usage{
basic_plot_traces(samples)
}
\arguments{
\item{samples}{A \code{list} object containing the sample outputs of a basic
model run.}
}
\value{
A base R plot of the pMCMC chains for fitted parameters and
log-likelihood.
}
\description{
Plot pMCMC traces of basic model.
}
\examples{
basic_plot_traces(samples)
}
