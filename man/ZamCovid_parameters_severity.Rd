% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parameters.R
\name{ZamCovid_parameters_severity}
\alias{ZamCovid_parameters_severity}
\title{ZamCovid severity parameters}
\usage{
ZamCovid_parameters_severity(
  dt,
  severity = NULL,
  p_C = NULL,
  p_H = NULL,
  p_H_D = NULL,
  p_G_D = NULL,
  p_R = NULL,
  p_star = NULL,
  p_sero_pos = NULL
)
}
\arguments{
\item{dt}{The step size}

\item{severity}{\link{data.frame} object with severity data used to determine
default severity values by age. First column is a string (names of
severity parameter in ZamCovid) and rest of columns must be \code{real} numeric
values for each age group (16). If \code{NULL}, default package parameters will
be used.}

\item{p_C}{Time-varying parameters for p_C (the probability of an infected
individual becoming symptomatic). See Details.}

\item{p_H}{Time-varying parameters for p_H (the probability of a symptomatic
individual requiring hospitalisation). See Details.}

\item{p_H_D}{Time-varying parameters for p_H_D (the probability of death in
general beds).See Details.}

\item{p_G_D}{Time-varying parameters for p_G_D (the probability of
individuals requiring hospitalisation dying in the community or a care
home). See Details.}

\item{p_R}{Time-varying parameters for p_R (the probability of an non-
fatally infected individual having immunity post-infection). See Details.}

\item{p_star}{Time-varying parameters for p_star (the probability of
patients being confirmed as covid on admission to hospital). See Details.}
}
\value{
A list of severity parameters
}
\description{
ZamCovid severity parameters
}
\section{Time-varying parameters}{

Every time varying parameter has the same format, which can be \code{NULL} (in
which case the value from \code{severity} is used) or a list with \code{date} and
\code{value} for changes in the parameter. If \code{value} is scalar then
\code{date} can be \code{NULL} or missing. If \code{value} is a vector then \code{date}
must be a vector of numeric dates of the same length as \code{value}.
}

