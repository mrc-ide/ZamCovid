% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parameters.R
\name{ZamCovid_parameters}
\alias{ZamCovid_parameters}
\title{Define ZamCovid model parameters}
\usage{
ZamCovid_parameters(
  start_date,
  steps_per_day = 4L,
  beta_date = NULL,
  beta_value = NULL,
  base_death_date = NULL,
  base_death_value = NULL,
  cross_immunity_date = NULL,
  cross_immunity_value = NULL,
  population = NULL,
  contact_matrix = NULL,
  N_tot = NULL,
  n_groups = NULL,
  severity = NULL,
  progression = NULL,
  observation = NULL,
  sens_and_spec = NULL,
  vaccination = NULL,
  vaccine_progression_rate = NULL,
  vaccine_schedule = NULL,
  vaccine_index_dose2 = NULL,
  vaccine_catchup_fraction = NULL,
  n_doses = 2L,
  initial_seed_pattern = 1,
  initial_seed_size = 10,
  I_A_transmission = 0.223,
  I_P_transmission = 1,
  I_C_1_transmission = 1,
  I_C_2_transmission = 0,
  hosp_transmission = 0,
  G_D_transmission = 0,
  rel_susceptibility = 1,
  rel_p_sympt = 1,
  rel_p_hosp_if_sympt = 1,
  rel_p_death = 1,
  rel_infectivity = 1
)
}
\arguments{
\item{start_date}{A positive integer, greated than \code{model_start} for the model
end time.}

\item{steps_per_day}{A positive integer for the number of steps per day to
run the model.}

\item{beta_date}{A vector of \code{numeric_date}s for constructing piece-wise
linear interpolate function for beta (transmission scaling) parameter.}

\item{beta_value}{A vector of \code{double} values for constructing piece-wise
linear interpolate function for beta (transmission scaling) parameter.}

\item{base_death_date}{A vector of \code{numeric_deaths}s for constructing
piece-wise linear interpolate function of daily baseline deaths.}

\item{base_death_value}{A vector of \code{double} values for constructing
piece-wise linear interpolate function of daily baseline deaths.}

\item{cross_immunity_date}{A vector of \code{numeric_deaths}s for constructing
piece-wise linear interpolate function of cross-immunity vs infection.}

\item{cross_immunity_value}{A vector of \code{double} values for constructing
piece-wise linear interpolate function of cross-immunity vs infection.}

\item{population}{Either \code{NULL} or a \code{data.frame} with columns \code{age_group}
and \code{n} of same length (age groups) as \code{contact_matrix} supplied. If
\code{NULL} defaults to nationally representative values for Zambia.}

\item{contact_matrix}{Either \code{NULL} or a \code{data.frame} of a symmetric
individual-to-individual contact rate matrix. If \code{NULL} defaults to
nationally representative values for Zambia.}

\item{N_tot}{Either \code{NULL} or a \code{vector} integer numbers of age-specific
population of same length as age-groups in \code{contact_matri}. Must be
supplied if \code{population} and \code{contact_matrix} are not \code{NULL}.}

\item{n_groups}{Either \code{NULL} or an \code{integer} number specifying the number of
age groups in the populsation to model. Must be supplied if \code{population}
and \code{contact_matrix} are not \code{NULL}.}

\item{severity}{Either \code{NULL} or a named \code{list} containing all elements in
\link{ZamCovid_parameters_severity}.}

\item{progression}{Either \code{NULL} or a named \code{list} containing all elements in
\link{ZamCovid_parameters_progression}.}

\item{observation}{Either \code{NULL} or a named \code{list} containing all elements in
\link{ZamCovid_parameters_observation}.}

\item{sens_and_spec}{Either \code{NULL} or a named \code{list} containing all elements
in \link{ZamCovid_parameters_sens_and_spec}.}

\item{vaccination}{Either \code{NULL} or a named \code{list} containing all elements in
\link{ZamCovid_parameters_vaccination}. Nota that, if \code{NULL} and
modelling vaccination, a \code{vaccine_progression_rate}, \code{vaccine_schedule},
\code{vaccine_index_dose2}, \code{vaccine_catchup_fraction}
and \code{n_doses} must be supplied.}
}
\value{
Return a \code{list} of parameters to run the basic ZamCovid model.
}
\description{
Define ZamCovid model parameters
}
