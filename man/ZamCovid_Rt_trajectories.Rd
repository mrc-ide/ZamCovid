% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ZamCovid_Rt.R
\name{ZamCovid_Rt_trajectories}
\alias{ZamCovid_Rt_trajectories}
\title{Compute Rt for a set of trajectories}
\usage{
ZamCovid_Rt_trajectories(
  time,
  S,
  pars,
  initial_time_from_parameters = TRUE,
  type = c("eff_Rt_general", "Rt_general"),
  eigen_method = "power_iteration",
  R = NULL,
  weight_Rt = FALSE
)
}
\arguments{
\item{time}{A vector of time steps}

\item{S}{A 3d ((n groups x n vaccine classes) x n trajectories x n time
steps) array of "S" compartment counts}

\item{pars}{Either a single \code{\link[=ZamCovid_parameters]{ZamCovid_parameters()}} object
(shared parameters) or an unnamed list of
\code{\link[=ZamCovid_parameters]{ZamCovid_parameters()}} objects, the same length as \code{ncol(S)}.}

\item{initial_time_from_parameters}{If \code{TRUE}, then \code{time[[1]]} is
replaced by the value of \code{initial_time} from the parameters.
This is usually what you want.}

\item{type}{A character vector of possible Rt types to
compute. Can be \code{eff_Rt_general} or \code{Rt_general}, for Rt accounting or
not accounting for immunity in the population, respectively.}

\item{eigen_method}{The eigenvalue method to use (passed to
\link[eigen1:eigen1]{eigen1::eigen1} as \code{method})}

\item{R}{A 2d ((n groups x n strains x n vaccine classes) x
n trajectories x n time steps) array of "R" compartment counts, required
for multi-strain models.}

\item{weight_Rt}{If \code{TRUE} then computes the weighted average
of the Rt for all strains, otherwise all calculations are returned with
an additional dimension to index each strain.}
}
\value{
As for \code{\link[=ZamCovid_Rt]{ZamCovid_Rt()}}, except that every element is a
matrix, not a vector.
}
\description{
Compute "Rt" for a set of simulated trajectories (e.g., the result
of the \verb{$iterate()} method of \link{ZamCovid}, \code{\link[mcstate:pmcmc]{mcstate::pmcmc()}} or
\code{\link[mcstate:pmcmc_predict]{mcstate::pmcmc_predict()}}. The trajectories may or may not share
parameters.
}
