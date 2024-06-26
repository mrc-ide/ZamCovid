## TODO: checklist
# If boosters are needed further down the line, implement vaccine skip
# Assess hospitalisation data, as and when available, and think whether
# conf/uncof still make sense or it might need re-factoring
# For a fixed seed, we can do -50 odd days after the first 15 deaths recorded
# ass OJ did in squire

## Compartment indexes: age groups (i), vaccine class (j)
# Note k index is used for shape parameter of erlang distributed rates
n_groups <- user()
n_vacc_classes <- user()
k_E <- user()
k_G_D <- user()
k_H_D <- user()
k_H_R <- user()
k_PCR_pos <- user()
k_PCR_pre <- user()
k_sero_pos <- user()
k_sero_pre <- user()


## Definition of time-step and output as "time"
steps_per_day <- user(integer = TRUE)
dt <- 1 / steps_per_day
initial(time) <- 0
update(time) <- (step + 1) * dt


## Core state variables (model compartments)
update(S[, ]) <- new_S[i, j]
update(E[, , ]) <- new_E[i, j, k]
update(I_A[, ]) <- new_I_A[i, j]
update(I_P[, ]) <- new_I_P[i, j]
update(I_C_1[, ]) <- new_I_C_1[i, j]
update(I_C_2[, ]) <- new_I_C_2[i, j]
update(H_R_conf[, , ]) <- new_H_R_conf[i, j, k]
update(H_R_unconf[, , ]) <- new_H_R_unconf[i, j, k]
update(H_D_conf[, , ]) <- new_H_D_conf[i, j, k]
update(H_D_unconf[, , ]) <- new_H_D_unconf[i, j, k]
update(G_D[, , ]) <- new_G_D[i, j, k]
update(R[, ]) <- new_R[i, j]
update(D[, ]) <- D[i, j] +
  delta_D_hosp_disag[i, j] + delta_D_non_hosp_disag[i, j]
update(D_hosp[, ]) <- D_hosp[i, j] + delta_D_hosp_disag[i, j]
update(D_non_hosp[, ]) <- D_non_hosp[i, j] + delta_D_non_hosp_disag[i, j]


## Parallel flows state variables
update(T_sero_pre[, , ]) <- new_T_sero_pre[i, j, k]
update(T_sero_pos[, , ]) <- new_T_sero_pos[i, j, k]
update(T_sero_neg[, ]) <- new_T_sero_neg[i, j]

update(T_PCR_pre[, , ]) <- new_T_PCR_pre[i, j, k]
update(T_PCR_pos[, , ]) <- new_T_PCR_pos[i, j, k]
update(T_PCR_neg[, ]) <- new_T_PCR_neg[i, j]


## Work out new individuals entering compartments
new_S[, ] <- S[i, j] + n_RS[i, j] + n_infected_to_S[i, j] -
  n_S_progress[i, j] - n_S_next_vacc_class[i, j] +
  (if (j == 1) n_S_next_vacc_class[i, n_vacc_classes] else
    n_S_next_vacc_class[i, j - 1])

new_E[, , ] <- E[i, j, k] +
  (if (k == 1) n_S_progress[i, j] + n_RE[i, j] else n_E_progress[i, j, k - 1]) -
  n_E_progress[i, j, k] -
  n_E_next_vacc_class[i, j, k] +
  (if (j == 1) n_E_next_vacc_class[i, n_vacc_classes, k] else
    n_E_next_vacc_class[i, j - 1, k])

new_I_A[, ] <- I_A[i, j] + n_EI_A[i, j] -
  n_I_A_progress[i, j] - n_I_A_next_vacc_class[i, j] +
  (if (j == 1) n_I_A_next_vacc_class[i, n_vacc_classes] else
    n_I_A_next_vacc_class[i, j -1])

new_I_P[, ] <- I_P[i, j] + n_EI_P[i, j] -
  n_I_P_progress[i, j] - n_I_P_next_vacc_class[i, j] +
  if (j == 1) n_I_P_next_vacc_class[i, n_vacc_classes] else
    n_I_P_next_vacc_class[i, j - 1]

new_I_C_1[, ] <- I_C_1[i, j] + n_I_P_progress[i, j] -
  n_I_C_1_progress[i, j]

new_I_C_2[, ] <- I_C_2[i, j] + n_I_C_1_progress[i, j] -
  n_I_C_2_progress[i, j]

aux_H_R_conf[, , ] <- H_R_conf[i, j, k] +
  (if (k > 1) n_H_R_conf_progress[i, j, k - 1] else 0) -
  n_H_R_conf_progress[i, j, k]
aux_H_R_unconf[, , ] <- H_R_unconf[i, j, k] +
  (if (k > 1) n_H_R_unconf_progress[i, j, k - 1] else 0) -
  n_H_R_unconf_progress[i, j, k]
new_H_R_conf[, , ] <-
  aux_H_R_conf[i, j, k] + n_H_R_unconf_to_conf[i, j, k] +
  (if (k == 1) n_I_C_2_to_H_R_conf[i, j] else 0)
new_H_R_unconf[, , ] <-
  aux_H_R_unconf[i, j, k] - n_H_R_unconf_to_conf[i, j, k] +
  (if (k == 1) n_I_C_2_to_H_R[i, j] - n_I_C_2_to_H_R_conf[i, j] else 0)

aux_H_D_conf[, , ] <- H_D_conf[i, j, k] +
  (if (k > 1) n_H_D_conf_progress[i, j, k - 1] else 0) -
  n_H_D_conf_progress[i, j, k]
aux_H_D_unconf[, , ] <- H_D_unconf[i, j, k] +
  (if (k > 1) n_H_D_unconf_progress[i, j, k - 1] else 0) -
  n_H_D_unconf_progress[i, j, k]
new_H_D_conf[, , ] <-
  aux_H_D_conf[i, j, k] + n_H_D_unconf_to_conf[i, j, k] +
  (if (k == 1) n_I_C_2_to_H_D_conf[i, j] else 0)
new_H_D_unconf[, , ] <-
  aux_H_D_unconf[i, j, k] - n_H_D_unconf_to_conf[i, j, k] +
  (if (k == 1) n_I_C_2_to_H_D[i, j] - n_I_C_2_to_H_D_conf[i, j] else 0)

new_G_D[, , ] <- G_D[i, j, k] +
  (if (k == 1) n_I_C_2_to_G_D[i, j] else
    n_G_D_progress[i, j, k - 1]) - n_G_D_progress[i, j, k]

new_R[, ] <- R[i, j] - n_RS[i, j] - n_RE[i, j] - n_R_next_vacc_class[i, j] +
  n_infected_to_R[i, j] +
  (if (j == 1) n_R_next_vacc_class[i, n_vacc_classes] else
    n_R_next_vacc_class[i, j - 1])

delta_D_hosp_disag[, ] <- n_H_D_unconf_progress[i, j, k_H_D] +
  n_H_D_conf_progress[i, j, k_H_D]
delta_D_non_hosp_disag[, ] <- n_G_D_progress[i, j, k_G_D]



## Binomial draws for numbers who will progress
n_S_progress[, ] <- rbinom(S[i, j], p_SE[i, j])
n_S_next_vacc_class[, ] <- rbinom(S[i, j] - n_S_progress[i, j],
                                  p_S_next_vacc_class[i, j])
n_E_progress[, , ] <- rbinom(E[i, j, k], p_E_progress)
n_E_next_vacc_class[, , ] <- rbinom(E[i, j, k] - n_E_progress[i, j, k],
                                    p_E_next_vacc_class[i, j])
n_EI_A[, ] <- rbinom(n_E_progress[i, j, k_E], 1 - p_C[i, j])
n_EI_P[, ] <- n_E_progress[i, j, k_E] - n_EI_A[i, j]

n_I_A_progress[, ] <- rbinom(I_A[i, j], p_I_A_progress)
n_I_A_next_vacc_class[, ] <- rbinom(I_A[i, j] - n_I_A_progress[i, j],
                                    p_I_A_next_vacc_class[i, j])
n_I_P_progress[, ] <- rbinom(I_P[i, j], p_I_P_progress)
n_I_P_next_vacc_class[, ] <- rbinom(I_P[i, j] - n_I_P_progress[i, j],
                                    p_I_P_next_vacc_class[i, j])

n_I_C_1_progress[, ] <- rbinom(I_C_1[i, j], p_I_C_1_progress)
n_I_C_2_progress[, ] <- rbinom(I_C_2[i, j], p_I_C_2_progress)

n_I_C_2_NoHosp[, ] <- rbinom(n_I_C_2_progress[i, j], 1 - p_H[i, j])
n_I_C_2_to_RS[, ] <- rbinom(n_I_C_2_NoHosp[i, j], 1 - p_G_D[i, j])

n_I_C_2_to_hosp[, ] <- n_I_C_2_progress[i, j] - n_I_C_2_NoHosp[i, j]
n_I_C_2_to_G_D[, ] <- n_I_C_2_progress[i, j] - n_I_C_2_to_RS[i, j] -
  n_I_C_2_to_hosp[i, j]

n_I_C_2_to_H_R[, ] <- rbinom(n_I_C_2_to_hosp[i, j], 1 - p_H_D[i, j])
n_I_C_2_to_H_D[, ] <- n_I_C_2_to_hosp[i, j] - n_I_C_2_to_H_R[i, j]
n_I_C_2_to_H_R_conf[, ] <- rbinom(n_I_C_2_to_H_R[i, j], p_star[i])
n_I_C_2_to_H_D_conf[, ] <- rbinom(n_I_C_2_to_H_D[i, j], p_star[i])

n_H_R_unconf_to_conf[, , ] <- rbinom(aux_H_R_unconf[i, j, k], p_test)
n_H_D_unconf_to_conf[, , ] <- rbinom(aux_H_D_unconf[i, j, k], p_test)
n_H_R_conf_progress[, , ] <- rbinom(H_R_conf[i, j, k], p_H_R_progress)
n_H_R_unconf_progress[, , ] <- rbinom(H_R_unconf[i, j, k], p_H_R_progress)
n_H_D_conf_progress[, , ] <- rbinom(H_D_conf[i, j, k], p_H_D_progress)
n_H_D_unconf_progress[, , ] <- rbinom(H_D_unconf[i, j, k], p_H_D_progress)

n_infection_end[, ] <- n_I_A_progress[i, j] + n_I_C_2_to_RS[i, j] +
  n_H_R_conf_progress[i, j, k_H_R] + n_H_R_unconf_progress[i, j, k_H_R]
n_infected_to_R[, ] <- rbinom(n_infection_end[i, j], p_R[i, j])
n_infected_to_S[, ] <- n_infection_end[i, j] - n_infected_to_R[i, j]

n_G_D_progress[, , ] <- rbinom(G_D[i, j, k], p_G_D_progress)


## Handle recovery classes and flows:
# We will allow re-infections, with cross-immunity referring to protection
# against re-infection conferred by a prior infection episode whilst not fully
# susceptible. As a proxy of the emergence of VOCs, cross_immunity will be
# time-varying, as informed by literature
n_RS[, ] <- rbinom(R[i, j], p_RS)
n_RE[, ] <- rbinom(R[i, j] - n_RS[i, j], p_RE[i, j])
n_R_next_vacc_class[, ] <- rbinom(R[i, j] - n_RS[i, j] - n_RE[i, j],
                                  p_R_next_vacc_class[i, j])


## Parallel serology flows
# Note flow is split between those who will and won't seroconvert
n_com_to_T_sero_pre[, ] <- n_E_progress[i, j, k_E]

new_T_sero_pre[, , ] <- T_sero_pre[i, j, k] -
  n_T_sero_pre_progress[i, j, k] +
  (if (k == 1) n_com_to_T_sero_pre[i, j] else
    n_T_sero_pre_progress[i, j, k - 1])

n_T_sero_pre_to_T_sero_pos[, ] <-
  rbinom(n_T_sero_pre_progress[i, j, k_sero_pre], p_sero_pos[i])

new_T_sero_pos[, , ] <- T_sero_pos[i, j, k] -
  n_T_sero_pos_progress[i, j, k] +
  (if (k == 1)  n_T_sero_pre_to_T_sero_pos[i, j] else
    n_T_sero_pos_progress[i, j, k - 1])

new_T_sero_neg[, ] <- T_sero_neg[i, j] +
  n_T_sero_pre_progress[i, j, k_sero_pre] -
  n_T_sero_pre_to_T_sero_pos[i, j] +
  n_T_sero_pos_progress[i, j, k_sero_pos]

n_T_sero_pre_progress[, , ] <- rbinom(T_sero_pre[i, j, k],
                                      p_T_sero_pre_progress)
n_T_sero_pos_progress[, , ] <- rbinom(T_sero_pos[i, j, k],
                                      p_T_sero_pos_progress)



## Parallel PCR flows
new_T_PCR_pre[, , ] <- T_PCR_pre[i, j, k] - n_T_PCR_pre_progress[i, j, k] +
  (if (k == 1) n_S_progress[i, j] else n_T_PCR_pre_progress[i, j, k - 1])

new_T_PCR_pos[, , ] <- T_PCR_pos[i, j, k] - n_T_PCR_pos_progress[i, j, k] +
  (if (k == 1) n_T_PCR_pre_progress[i, j, k_PCR_pre] else
    n_T_PCR_pos_progress[i, j, k - 1])

new_T_PCR_neg[, ] <- T_PCR_neg[i, j] + n_T_PCR_pos_progress[i, j, k_PCR_pos]

n_T_PCR_pre_progress[, , ] <- rbinom(T_PCR_pre[i, j, k], p_T_PCR_pre_progress)
n_T_PCR_pos_progress[, , ] <- rbinom(T_PCR_pos[i, j, k], p_T_PCR_pos_progress)



## Clinical progression probabilities
p_SE[, ] <- 1 - exp(-lambda_susc[i, j] * dt) # age/vacc dependent
p_E_progress <- 1 - exp(-gamma_E * dt)
p_I_A_progress <- 1 - exp(-gamma_A * dt)
p_I_P_progress <- 1 - exp(-gamma_P * dt)
p_I_C_1_progress <- 1 - exp(-gamma_C_1 * dt)
p_I_C_2_progress <- 1 - exp(-gamma_C_2 * dt)
p_H_R_progress <- 1 - exp(-gamma_H_R * dt)
p_H_D_progress <- 1 - exp(-gamma_H_D * dt)
p_G_D_progress <- 1 - exp(-gamma_G_D * dt)
p_RS <- 1 - exp(-gamma_R * dt)
p_RE[, ] <- 1 - exp(-lambda_susc[i, j] * dt * (1 - cross_immunity))
p_test <- 1 - exp(-gamma_U * dt)

p_sero_pos[] <- user()
p_T_sero_pre_progress <- 1 - exp(-gamma_sero_pre * dt)
p_T_sero_pos_progress <- 1 - exp(-gamma_sero_pos * dt)
p_T_PCR_pre_progress <- 1 - exp(-gamma_PCR_pre * dt)
p_T_PCR_pos_progress <- 1 - exp(-gamma_PCR_pos * dt)


## Vaccination probability and relative protection parameters
# vaccine_probability[, ] <- user()
p_S_next_vacc_class[, ] <- vaccine_probability[i, j]
p_E_next_vacc_class[, ] <- vaccine_probability[i, j]
p_I_A_next_vacc_class[, ] <- vaccine_probability[i, j]
p_I_P_next_vacc_class[, ] <- vaccine_probability[i, j]
p_R_next_vacc_class[, ] <- vaccine_probability[i, j]

rel_infectivity[, ] <- user()
rel_susceptibility[, ] <- user()
rel_p_sympt[, ] <- user()
rel_p_hosp_if_sympt[, ] <- user()
rel_p_H_D[, ] <- user()
rel_p_G_D[, ] <- user()
rel_p_R[, ] <- user()

## Time-varying probabilities
p_C_step[, ] <- user()
n_p_C_steps <- user()
p_H_step[, ] <- user()
n_p_H_steps <- user()
p_H_D_step[, ]<- user()
n_p_H_D_steps <- user()
p_star_step[, ] <- user()
n_p_star_steps <- user()
p_G_D_step[, ] <- user()
n_p_G_D_steps <- user()
p_R_step[, ] <- user()
n_p_R_steps <- user()


p_C[, ] <- if (as.integer(step) >= n_p_C_steps)
  min(p_C_step[n_p_C_steps, i] * rel_p_sympt[i, j], as.numeric(1)) else
    min(p_C_step[step + 1, i] * rel_p_sympt[i, j], as.numeric(1))

p_H[, ] <- if (as.integer(step) >= n_p_H_steps)
  min(p_H_step[n_p_H_steps, i] * rel_p_hosp_if_sympt[i, j], as.numeric(1)) else
    min(p_H_step[step + 1, i] * rel_p_hosp_if_sympt[i, j], as.numeric(1))

p_H_D[, ] <- if (as.integer(step) >= n_p_H_D_steps)
  min(p_H_D_step[n_p_H_D_steps, i] * rel_p_H_D[i, j], as.numeric(1)) else
    min(p_H_D_step[step + 1, i] * rel_p_H_D[i, j], as.numeric(1))

p_G_D[, ] <- if (as.integer(step) >= n_p_G_D_steps)
  min(p_G_D_step[n_p_G_D_steps, i] * rel_p_G_D[i, j], as.numeric(1)) else
    min(p_G_D_step[step + 1, i] * rel_p_G_D[i, j], as.numeric(1))

p_R[, ] <- if (as.integer(step) >= n_p_R_steps)
  min(p_R_step[n_p_R_steps, i] * rel_p_R[i, j], as.numeric(1)) else
    min(p_R_step[step + 1, i] * rel_p_R[i, j], as.numeric(1))

p_star[] <- if (as.integer(step) >= n_p_star_steps)
  p_star_step[n_p_star_steps, i] else p_star_step[step + 1, i]


## Cross-immunity
cross_immunity_step[] <- user()
dim(cross_immunity_step) <- user()
cross_immunity <- if (step >= length(cross_immunity_step))
  cross_immunity_step[length(cross_immunity_step)] else
    cross_immunity_step[step + 1]


## Seeding model for first epidemic wave
seed_step_end <- seed_step_start + length(seed_value)
seed_rate <- if (step >= seed_step_start && step < seed_step_end)
  seed_value[as.integer(step - seed_step_start + 1)] else 0
seed <- rpois(seed_rate)

seed_age_band <- user(integer = TRUE)
seed_step_start <- user()
seed_value[] <- user()
dim(seed_value) <- user()

n_S_progress[seed_age_band, 1] <- n_S_progress[seed_age_band, 1] +
  min(S[seed_age_band, 1], seed)


## Force of infection - depends on: contact matrix (m), relative infectivity
# (age, vaccination class), prevalence in infected classes and
# assumptions about how much each compartment contributes to transmission,
# and relative susceptibility to infection (age, vaccination class)
m[, ] <- user()
I_A_transmission <- user()
I_P_transmission <- user()
I_C_1_transmission <- user()
I_C_2_transmission <- user()
hosp_transmission <- user()
G_D_transmission <- user()

I_trans[, ] <- rel_infectivity[i, j] *
  (I_A_transmission * sum(I_A[i, j]) +
     I_P_transmission * sum(I_P[i, j]) +
     I_C_1_transmission * sum(I_C_1[i, j]) +
     I_C_2_transmission * sum(I_C_2[i, j]) +
     hosp_transmission * (sum(H_R_conf[i, j, ]) +
                            sum(H_R_unconf[i, j, ]) +
                            sum(H_D_conf[i, j, ]) +
                            sum(H_D_unconf[i, j, ])) +
     G_D_transmission * sum(G_D[i, j, ]))

s_ij[, ] <- m[i, j] * sum(I_trans[j, ])
lambda[] <- beta * sum(s_ij[i, ])
lambda_susc[, ] <- lambda[i] * rel_susceptibility[i, j]

beta_step[] <- user()
dim(beta_step) <- user()
beta <- if (step >= length(beta_step))
  beta_step[length(beta_step)] else beta_step[step + 1]

# Output betas - useful for debugging
initial(beta_out) <- beta_step[1]
update(beta_out) <- beta


## Track number of individuals vaccinated
n_vaccinated[, ] <-
  n_S_next_vacc_class[i, j] +
  sum(n_E_next_vacc_class[i, j, ]) +
  n_I_A_next_vacc_class[i, j] +
  n_I_P_next_vacc_class[i, j] +
  n_R_next_vacc_class[i, j]

update(cum_n_vaccinated[, ]) <- cum_n_vaccinated[i, j] + n_vaccinated[i, j]

update(cum_n_S_vaccinated[, ]) <-
  cum_n_S_vaccinated[i, j] + n_S_next_vacc_class[i, j]

update(cum_n_E_vaccinated[, ]) <-
  cum_n_E_vaccinated[i, j] + sum(n_E_next_vacc_class[i, j, ])

update(cum_n_I_A_vaccinated[, ]) <-
  cum_n_I_A_vaccinated[i, j] + n_I_A_next_vacc_class[i, j]

update(cum_n_I_P_vaccinated[, ]) <-
  cum_n_I_P_vaccinated[i, j] + n_I_P_next_vacc_class[i, j]

update(cum_n_R_vaccinated[, ]) <-
  cum_n_R_vaccinated[i, j] + n_R_next_vacc_class[i, j]


## Vaccination engine
n_doses <- user()
index_dose[] <- user(integer = TRUE)
index_dose_inverse[] <- user(integer = TRUE)
vaccine_dose_step[, , ] <- user() # n_groups, n_doses, n_time

# First, the number of candidates
vaccine_n_candidates[, ] <- S[i, index_dose[j]] + sum(E[i, index_dose[j], ]) +
  I_A[i, index_dose[j]] + I_P[i, index_dose[j]] + R[i, index_dose[j]]

# Second: work out how many doses will be attempted
# Now we work out the split of the total attempted doses
vaccine_catchup_fraction <- user(0)
update(vaccine_missed_doses[, ]) <-
  vaccine_catchup_fraction *
  max(total_attempted_doses[i, j] - n_vaccinated[i, index_dose[j]],
      as.numeric(0))

total_attempted_doses[, ] <- vaccine_missed_doses[i, j] + (
  if (as.integer(step) >= dim(vaccine_dose_step, 3)) 0
  else vaccine_dose_step[i, j, step + 1])

vaccine_attempted_doses[, ] <-
  (if (vaccine_n_candidates[i, j] == 0) 0
   else min(total_attempted_doses[i, j], vaccine_n_candidates[i, j]))

# Third: vaccination probability driven by schedule
vaccine_probability_doses[, ] <- min(
  if (vaccine_n_candidates[i, j] > 0)
    vaccine_attempted_doses[i, j] / vaccine_n_candidates[i, j] else 0,
  as.numeric(1))


## Then either fix everything based on progression at a constant rate,
## or take from the supplied time-varying probabilities.
vaccine_probability[, ] <- (
  if (index_dose_inverse[j] > 0)
    vaccine_probability_doses[i, index_dose_inverse[j]]
  else
    1 - exp(-vaccine_progression_rate_base[i, j] * dt))

update(tmp_vaccine_n_candidates[, ]) <- vaccine_n_candidates[i, j]
update(tmp_vaccine_probability[, ]) <- vaccine_probability[i, j]

vaccine_progression_rate_base[, ] <- user()


### Initial states are all zeroed
# S and E will be initialiased based on the seeding model
initial(S[, ]) <- 0
initial(E[, , ]) <- 0
initial(I_A[, ]) <- 0
initial(I_P[, ]) <- 0
initial(I_C_1[, ]) <- 0
initial(I_C_2[, ]) <- 0
initial(H_R_conf[, , ]) <- 0
initial(H_R_unconf[, , ]) <- 0
initial(H_D_conf[, , ]) <- 0
initial(H_D_unconf[, , ]) <- 0
initial(G_D[, , ]) <- 0
initial(R[, ]) <- 0
initial(D[, ]) <- 0
initial(D_hosp[, ]) <- 0
initial(D_non_hosp[, ]) <- 0
initial(T_sero_pre[, , ]) <- 0
initial(T_sero_pos[, , ]) <- 0
initial(T_sero_neg[, ]) <- 0
initial(T_PCR_pre[, , ]) <- 0
initial(T_PCR_pos[, , ]) <- 0
initial(T_PCR_neg[, ]) <- 0

initial(cum_n_vaccinated[, ]) <- 0
initial(cum_n_S_vaccinated[, ]) <- 0
initial(cum_n_E_vaccinated[, ]) <- 0
initial(cum_n_I_A_vaccinated[, ]) <- 0
initial(cum_n_I_P_vaccinated[, ]) <- 0
initial(cum_n_R_vaccinated[, ]) <- 0
initial(vaccine_missed_doses[, ]) <- 0

initial(tmp_vaccine_n_candidates[, ]) <- 0
initial(tmp_vaccine_probability[, ]) <- 0


## Time-varying progression rates
gamma_E_step[] <- user()
n_gamma_E_steps <- user()
gamma_A_step[] <- user()
n_gamma_A_steps <- user()
gamma_P_step[] <- user()
n_gamma_P_steps <- user()
gamma_C_1_step[] <- user()
n_gamma_C_1_steps <- user()
gamma_C_2_step[] <- user()
n_gamma_C_2_steps <- user()
gamma_H_R_step[] <- user()
n_gamma_H_R_steps <- user()
gamma_H_D_step[] <- user()
n_gamma_H_D_steps <- user()
gamma_G_D_step[] <- user()
n_gamma_G_D_steps <- user()
gamma_PCR_pre_step[] <- user()
n_gamma_PCR_pre_steps <- user()
gamma_PCR_pos_step[] <- user()
n_gamma_PCR_pos_steps <- user()
gamma_sero_pos_step[] <- user()
n_gamma_sero_pos_steps <- user()
gamma_sero_pre_step[] <- user()
n_gamma_sero_pre_steps <- user()
gamma_U_step[] <- user()
n_gamma_U_steps <- user()

gamma_E <- if (as.integer(step) >= n_gamma_E_steps)
  gamma_E_step[n_gamma_E_steps] else gamma_E_step[step + 1]

gamma_A <- if (as.integer(step) >= n_gamma_A_steps)
  gamma_A_step[n_gamma_A_steps] else gamma_A_step[step + 1]

gamma_P <- if (as.integer(step) >= n_gamma_P_steps)
  gamma_P_step[n_gamma_P_steps] else gamma_P_step[step + 1]

gamma_C_1 <- if (as.integer(step) >= n_gamma_C_1_steps)
  gamma_C_1_step[n_gamma_C_1_steps] else gamma_C_1_step[step + 1]

gamma_C_2 <- if (as.integer(step) >= n_gamma_C_2_steps)
  gamma_C_2_step[n_gamma_C_2_steps] else gamma_C_2_step[step + 1]

gamma_H_R <- if (as.integer(step) >= n_gamma_H_R_steps)
  gamma_H_R_step[n_gamma_H_R_steps] else gamma_H_R_step[step + 1]

gamma_H_D <- if (as.integer(step) >= n_gamma_H_D_steps)
  gamma_H_D_step[n_gamma_H_D_steps] else gamma_H_D_step[step + 1]

gamma_G_D <- if (as.integer(step) >= n_gamma_G_D_steps)
  gamma_G_D_step[n_gamma_G_D_steps] else gamma_G_D_step[step + 1]

gamma_PCR_pre <- if (as.integer(step) >= n_gamma_PCR_pre_steps)
  gamma_PCR_pre_step[n_gamma_PCR_pre_steps] else gamma_PCR_pre_step[step + 1]

gamma_PCR_pos <- if (as.integer(step) >= n_gamma_PCR_pos_steps)
  gamma_PCR_pos_step[n_gamma_PCR_pos_steps] else gamma_PCR_pos_step[step + 1]

gamma_sero_pre <- if (as.integer(step) >= n_gamma_sero_pre_steps)
  gamma_sero_pre_step[n_gamma_sero_pre_steps] else gamma_sero_pre_step[step + 1]

gamma_sero_pos <- if (as.integer(step) >= n_gamma_sero_pos_steps)
  gamma_sero_pos_step[n_gamma_sero_pos_steps] else gamma_sero_pos_step[step + 1]

gamma_U <- if (as.integer(step) >= n_gamma_U_steps)
  gamma_U_step[n_gamma_U_steps] else gamma_U_step[step + 1]

gamma_R <- user()



## Dimensions of arrays and vectors ###
dim(S) <- c(n_groups, n_vacc_classes)
dim(new_S) <- c(n_groups, n_vacc_classes)
dim(E) <- c(n_groups, n_vacc_classes, k_E)
dim(new_E) <- c(n_groups, n_vacc_classes, k_E)
dim(I_A) <- c(n_groups, n_vacc_classes)
dim(new_I_A) <- c(n_groups, n_vacc_classes)
dim(I_P) <- c(n_groups, n_vacc_classes)
dim(new_I_P) <- c(n_groups, n_vacc_classes)
dim(I_C_1) <- c(n_groups, n_vacc_classes)
dim(new_I_C_1) <- c(n_groups, n_vacc_classes)
dim(I_C_2) <- c(n_groups, n_vacc_classes)
dim(new_I_C_2) <- c(n_groups, n_vacc_classes)
dim(H_R_conf) <- c(n_groups, n_vacc_classes, k_H_R)
dim(new_H_R_conf) <- c(n_groups, n_vacc_classes, k_H_R)
dim(H_R_unconf) <- c(n_groups, n_vacc_classes, k_H_R)
dim(new_H_R_unconf) <- c(n_groups, n_vacc_classes, k_H_R)
dim(H_D_conf) <- c(n_groups, n_vacc_classes, k_H_D)
dim(new_H_D_conf) <- c(n_groups, n_vacc_classes, k_H_D)
dim(H_D_unconf) <- c(n_groups, n_vacc_classes, k_H_D)
dim(new_H_D_unconf) <- c(n_groups, n_vacc_classes, k_H_D)
dim(G_D) <- c(n_groups, n_vacc_classes, k_G_D)
dim(new_G_D) <- c(n_groups, n_vacc_classes, k_G_D)
dim(R) <- c(n_groups, n_vacc_classes)
dim(new_R) <- c(n_groups, n_vacc_classes)
dim(D) <- c(n_groups, n_vacc_classes)
dim(D_hosp) <- c(n_groups, n_vacc_classes)
dim(D_non_hosp) <- c(n_groups, n_vacc_classes)
dim(delta_D_hosp_disag) <- c(n_groups, n_vacc_classes)
dim(delta_D_non_hosp_disag) <- c(n_groups, n_vacc_classes)
dim(T_sero_pre) <- c(n_groups, n_vacc_classes, k_sero_pre)
dim(new_T_sero_pre) <- c(n_groups, n_vacc_classes, k_sero_pre)
dim(T_sero_pos) <- c(n_groups, n_vacc_classes, k_sero_pos)
dim(new_T_sero_pos) <- c(n_groups, n_vacc_classes, k_sero_pos)
dim(T_sero_neg) <- c(n_groups, n_vacc_classes)
dim(new_T_sero_neg) <- c(n_groups, n_vacc_classes)
dim(T_PCR_pre) <- c(n_groups, n_vacc_classes, k_PCR_pre)
dim(new_T_PCR_pre) <- c(n_groups, n_vacc_classes, k_PCR_pre)
dim(T_PCR_pos) <- c(n_groups, n_vacc_classes, k_PCR_pos)
dim(new_T_PCR_pos) <- c(n_groups, n_vacc_classes, k_PCR_pos)
dim(T_PCR_neg) <- c(n_groups, n_vacc_classes)
dim(new_T_PCR_neg) <- c(n_groups, n_vacc_classes)

dim(n_S_progress) <- c(n_groups, n_vacc_classes)
dim(n_infected_to_S) <- c(n_groups, n_vacc_classes)
dim(n_RS) <- c(n_groups, n_vacc_classes)
dim(n_RE) <- c(n_groups, n_vacc_classes)
dim(n_S_next_vacc_class) <- c(n_groups, n_vacc_classes)
dim(n_E_progress) <- c(n_groups, n_vacc_classes, k_E)
dim(n_E_next_vacc_class) <- c(n_groups, n_vacc_classes, k_E)
dim(n_EI_A) <- c(n_groups, n_vacc_classes)
dim(n_I_A_progress) <- c(n_groups, n_vacc_classes)
dim(n_I_A_next_vacc_class) <- c(n_groups, n_vacc_classes)
dim(n_EI_P) <- c(n_groups, n_vacc_classes)
dim(n_I_P_progress) <- c(n_groups, n_vacc_classes)
dim(n_I_P_next_vacc_class) <- c(n_groups, n_vacc_classes)
dim(n_I_C_1_progress) <- c(n_groups, n_vacc_classes)
dim(n_I_C_2_progress) <- c(n_groups, n_vacc_classes)
dim(aux_H_R_conf) <- c(n_groups, n_vacc_classes, k_H_R)
dim(aux_H_R_unconf) <- c(n_groups, n_vacc_classes, k_H_R)
dim(n_H_R_conf_progress) <- c(n_groups, n_vacc_classes, k_H_R)
dim(n_H_R_unconf_progress) <- c(n_groups, n_vacc_classes, k_H_R)
dim(n_H_R_unconf_to_conf) <- c(n_groups, n_vacc_classes, k_H_R)
dim(n_I_C_2_to_H_R_conf) <- c(n_groups, n_vacc_classes)
dim(n_I_C_2_to_H_R) <- c(n_groups, n_vacc_classes)
dim(aux_H_D_conf) <- c(n_groups, n_vacc_classes, k_H_D)
dim(aux_H_D_unconf) <- c(n_groups, n_vacc_classes, k_H_D)
dim(n_H_D_conf_progress) <- c(n_groups, n_vacc_classes, k_H_D)
dim(n_H_D_unconf_progress) <- c(n_groups, n_vacc_classes, k_H_D)
dim(n_H_D_unconf_to_conf) <- c(n_groups, n_vacc_classes, k_H_D)
dim(n_I_C_2_to_H_D_conf) <- c(n_groups, n_vacc_classes)
dim(n_I_C_2_to_H_D) <- c(n_groups, n_vacc_classes)
dim(n_I_C_2_to_G_D) <- c(n_groups, n_vacc_classes)
dim(n_G_D_progress) <- c(n_groups, n_vacc_classes, k_G_D)
dim(n_R_next_vacc_class) <- c(n_groups, n_vacc_classes)
dim(n_infected_to_R) <- c(n_groups, n_vacc_classes)
dim(n_I_C_2_to_RS) <- c(n_groups, n_vacc_classes)
dim(n_I_C_2_NoHosp) <- c(n_groups, n_vacc_classes)
dim(n_infection_end) <- c(n_groups, n_vacc_classes)
dim(n_I_C_2_to_hosp) <- c(n_groups, n_vacc_classes)
dim(n_com_to_T_sero_pre) <- c(n_groups, n_vacc_classes)
dim(n_T_sero_pre_progress) <- c(n_groups, n_vacc_classes, k_sero_pre)
dim(n_T_sero_pre_to_T_sero_pos) <- c(n_groups, n_vacc_classes)
dim(n_T_sero_pos_progress) <- c(n_groups, n_vacc_classes, k_sero_pos)
dim(n_T_PCR_pre_progress) <- c(n_groups, n_vacc_classes, k_PCR_pre)
dim(n_T_PCR_pos_progress) <- c(n_groups, n_vacc_classes, k_PCR_pos)

dim(p_SE) <- c(n_groups, n_vacc_classes)
dim(p_sero_pos) <- n_groups
dim(p_S_next_vacc_class) <- c(n_groups, n_vacc_classes)
dim(p_E_next_vacc_class) <- c(n_groups, n_vacc_classes)
dim(p_I_A_next_vacc_class) <- c(n_groups, n_vacc_classes)
dim(p_I_P_next_vacc_class) <- c(n_groups, n_vacc_classes)
dim(p_R_next_vacc_class) <- c(n_groups, n_vacc_classes)
dim(p_RE) <- c(n_groups, n_vacc_classes)
dim(rel_infectivity) <- c(n_groups, n_vacc_classes)
dim(rel_susceptibility) <- c(n_groups, n_vacc_classes)
dim(rel_p_sympt) <- c(n_groups, n_vacc_classes)
dim(rel_p_hosp_if_sympt) <- c(n_groups, n_vacc_classes)
dim(rel_p_H_D) <- c(n_groups, n_vacc_classes)
dim(rel_p_G_D) <- c(n_groups, n_vacc_classes)
dim(rel_p_R) <- c(n_groups, n_vacc_classes)

dim(p_C) <- c(n_groups, n_vacc_classes)
dim(p_H) <- c(n_groups, n_vacc_classes)
dim(p_H_D) <- c(n_groups, n_vacc_classes)
dim(p_G_D) <- c(n_groups, n_vacc_classes)
dim(p_R) <- c(n_groups, n_vacc_classes)
dim(p_star) <- n_groups

dim(p_C_step) <- c(n_p_C_steps, n_groups)
dim(p_H_step) <- c(n_p_H_steps, n_groups)
dim(p_H_D_step) <- c(n_p_H_D_steps, n_groups)
dim(p_G_D_step) <- c(n_p_G_D_steps, n_groups)
dim(p_R_step) <- c(n_p_R_steps, n_groups)
dim(p_star_step) <- c(n_p_star_steps, n_groups)

dim(m) <- c(n_groups, n_groups)
dim(s_ij) <- c(n_groups, n_groups)
dim(lambda) <- n_groups
dim(lambda_susc) <- c(n_groups, n_vacc_classes)
dim(I_trans) <- c(n_groups, n_vacc_classes)

dim(n_vaccinated) <- c(n_groups, n_vacc_classes)
dim(cum_n_vaccinated) <- c(n_groups, n_vacc_classes)
dim(cum_n_S_vaccinated) <- c(n_groups, n_vacc_classes)
dim(cum_n_E_vaccinated) <- c(n_groups, n_vacc_classes)
dim(cum_n_I_A_vaccinated) <- c(n_groups, n_vacc_classes)
dim(cum_n_I_P_vaccinated) <- c(n_groups, n_vacc_classes)
dim(cum_n_R_vaccinated) <- c(n_groups, n_vacc_classes)

dim(index_dose) <- n_doses
dim(index_dose_inverse) <- n_vacc_classes
dim(vaccine_dose_step) <- user()
dim(vaccine_n_candidates) <- c(n_groups, n_doses)
dim(vaccine_missed_doses) <- c(n_groups, n_doses)
dim(total_attempted_doses) <- c(n_groups, n_doses)
dim(vaccine_attempted_doses) <- c(n_groups, n_doses)
dim(vaccine_probability_doses) <- c(n_groups, n_doses)
dim(vaccine_progression_rate_base) <- c(n_groups, n_vacc_classes)

dim(vaccine_probability) <- c(n_groups, n_vacc_classes)
dim(tmp_vaccine_n_candidates) <- c(n_groups, n_doses)
dim(tmp_vaccine_probability) <- c(n_groups, n_vacc_classes)

dim(gamma_E_step) <- n_gamma_E_steps
dim(gamma_A_step) <- n_gamma_A_steps
dim(gamma_P_step) <- n_gamma_P_steps
dim(gamma_C_1_step) <- n_gamma_C_1_steps
dim(gamma_C_2_step) <- n_gamma_C_2_steps
dim(gamma_H_R_step) <- n_gamma_H_R_steps
dim(gamma_H_D_step) <- n_gamma_H_D_steps
dim(gamma_G_D_step) <- n_gamma_G_D_steps
dim(gamma_U_step) <- n_gamma_U_steps
dim(gamma_PCR_pre_step) <- n_gamma_PCR_pre_steps
dim(gamma_PCR_pos_step) <- n_gamma_PCR_pos_steps
dim(gamma_sero_pos_step) <- n_gamma_sero_pos_steps
dim(gamma_sero_pre_step) <- n_gamma_sero_pre_steps



########################################
###   Space observation equations    ###
########################################

## Parameters to support the compare function. Since these do not appear in any
## odin equation, they are marked as "ignore.unused"
N_tot_over15 <- user() # ignore.unused
N_tot_all <- user() # ignore.unused
sero_sensitivity <- user() # ignore.unused
sero_specificity <- user() # ignore.unused
pcr_sensitivity <- user() # ignore.unused
pcr_specificity <- user() # ignore.unused
exp_noise <- user() # ignore.unused
phi_admitted <- user() # ignore.unused
kappa_admitted <- user() # ignore.unused
phi_death_hosp <- user() # ignore.unused
kappa_death_hosp <- user() # ignore.unused
phi_death_all <- user() # ignore.unused
kappa_death_all <- user() # ignore.unused


## Total number of susceptible (used for initialising population)
initial(susceptible) <- 0
update(susceptible) <- sum(new_S)


## Total population
initial(N_tot[]) <- 0
update(N_tot[]) <- sum(S[i, ]) + sum(R[i, ]) + sum(D_hosp[i, ]) +
  sum(E[i, , ]) + sum(I_A[i, ]) + sum(I_P[i, ]) +
  sum(I_C_1[i, ]) + sum(I_C_2[i, ]) +
  sum(H_R_conf[i, , ]) + sum(H_R_unconf[i, , ]) +
  sum(H_D_conf[i, , ]) + sum(H_D_unconf[i, , ]) +
  sum(G_D[i, , ]) + sum(D_non_hosp[i, ])
dim(N_tot) <- n_groups


## Total population calculated with seroconversion flow
initial(N_tot_sero) <- 0
update(N_tot_sero) <- sum(S) + sum(T_sero_pre) +
  sum(T_sero_pos) + sum(T_sero_neg) + sum(E)


## Total population calculated with PCR flow
initial(N_tot_PCR) <- 0
update(N_tot_PCR) <- sum(S) + sum(T_PCR_pre) + sum(T_PCR_pos) + sum(T_PCR_neg)


## I_weighted used in Rt and IFR calculations
dim(new_I_weighted) <- c(n_groups, n_vacc_classes)
new_I_weighted[, ] <-
  I_A_transmission * new_I_A[i, j] +
  I_P_transmission * new_I_P[i, j] +
  I_C_1_transmission * new_I_C_1[i, j] +
  I_C_2_transmission * new_I_C_2[i, j] +
  hosp_transmission * (sum(H_R_conf[i, j, ]) +
                         sum(H_R_unconf[i, j, ]) +
                         sum(H_D_conf[i, j, ]) +
                         sum(H_D_unconf[i, j, ])) +
  G_D_transmission * sum(G_D[i, j, ])
sum_new_I_weighted <- sum(new_I_weighted)
initial(I_weighted[, ]) <- 0
dim(I_weighted) <- c(n_groups, n_vacc_classes)
# If there are zero infectives at time step default to putting weight
# in group 4/vaccine stratum 1 to avoid NAs in IFR calculation.
update(I_weighted[, ]) <-
  (if (sum_new_I_weighted == 0)
    (if (i == seed_age_band && j == 1) 1 else 0)
   else new_I_weighted[i, j])



delta_infections[, ] <- n_S_progress[i, j] + n_RE[i, j]
dim(delta_infections) <- c(n_groups, n_vacc_classes)
delta_infections_total <- sum(delta_infections)



# Output all new infections
initial(infections_inc) <- 0
new_infections_inc <- if (step %% steps_per_day == 0)
  delta_infections_total else infections_inc + delta_infections_total
update(infections_inc) <- new_infections_inc

dim(infections_inc_age) <- n_groups
dim(delta_infections_age) <- n_groups
dim(new_infections_inc_age) <- n_groups

initial(infections_inc_age[]) <- 0
delta_infections_age[] <- sum(delta_infections[i, ])
new_infections_inc_age[] <-
  if (step %% steps_per_day == 0)
    delta_infections_age[i] else
      infections_inc_age[i] + delta_infections_age[i]
update(infections_inc_age[]) <- new_infections_inc_age[i]



# Output all new re-infections
initial(reinfections_inc) <- 0
new_reinfections_inc <- if (step %% steps_per_day == 0)
  sum(n_RE) else reinfections_inc + sum(n_RE)
update(reinfections_inc) <- new_reinfections_inc

dim(reinfections_inc_age) <- n_groups
dim(delta_reinfections_age) <- n_groups
dim(new_reinfections_inc_age) <- n_groups

initial(reinfections_inc_age[]) <- n_groups
delta_reinfections_age[] <- sum(n_RE[i, ])
new_reinfections_inc_age[] <-
  if (step %% steps_per_day == 0)
    delta_reinfections_age[i] else
      reinfections_inc_age[i] + delta_reinfections_age[i]
update(reinfections_inc_age[]) <- new_reinfections_inc_age[i]


## Sero-positive population by age
initial(sero_pos_all) <- 0
update(sero_pos_all) <- sum(T_sero_pos[1:n_groups, , ])

initial(sero_pos_over15) <- 0
update(sero_pos_over15) <- sum(T_sero_pos[4:n_groups, , ])

initial(sero_pos_15_19) <- 0
update(sero_pos_15_19) <- sum(T_sero_pos[4, , ])

initial(sero_pos_20_29) <- 0
update(sero_pos_20_29) <- sum(T_sero_pos[5:6, , ])

initial(sero_pos_30_39) <- 0
update(sero_pos_30_39) <- sum(T_sero_pos[7:8, , ])

initial(sero_pos_40_49) <- 0
update(sero_pos_40_49) <- sum(T_sero_pos[9:10, , ])

initial(sero_pos_50_plus) <- 0
update(sero_pos_50_plus) <- sum(T_sero_pos[11:n_groups, , ])


## New infections by same age groups as serology
initial(inf_cum_all) <- 0
update(inf_cum_all) <- inf_cum_all +
  sum(infections_inc_age[1:n_groups]) - sum(reinfections_inc_age[1:n_groups])

initial(inf_cum_over15) <- 0
update(inf_cum_over15) <- inf_cum_over15 +
  sum(infections_inc_age[4:n_groups]) - sum(reinfections_inc_age[4:n_groups])

initial(inf_cum_15_19) <- 0
update(inf_cum_15_19) <- inf_cum_15_19 +
  sum(infections_inc_age[4]) - sum(reinfections_inc_age[4])

initial(inf_cum_20_29) <- 0
update(inf_cum_20_29) <- inf_cum_20_29 +
  sum(infections_inc_age[5:6]) - sum(reinfections_inc_age[5:6])

initial(inf_cum_30_39) <- 0
update(inf_cum_30_39) <- inf_cum_30_39 +
  sum(infections_inc_age[7:8]) - sum(reinfections_inc_age[7:8])

initial(inf_cum_40_49) <- 0
update(inf_cum_40_49) <- inf_cum_40_49 +
  sum(infections_inc_age[9:10]) - sum(reinfections_inc_age[9:10])

initial(inf_cum_50_plus) <- 0
update(inf_cum_50_plus) <- inf_cum_50_plus +
  sum(infections_inc_age[11:n_groups]) - sum(reinfections_inc_age[11:n_groups])


## IFR trajectories
dim(IFR_disag) <- c(n_groups, n_vacc_classes)
dim(IFR_disag_weighted_inc) <- c(n_groups, n_vacc_classes)
dim(new_IFR_disag_weighted_inc) <- c(n_groups, n_vacc_classes)


IFR_disag[, ] <- p_C[i, j] * p_H[i, j] * p_H_D[i, j] +
  p_C[i, j] * (1 - p_H[i, j]) * p_G_D[i, j]

initial(IFR_disag_weighted_inc[, ]) <- 0
update(IFR_disag_weighted_inc[, ]) <- new_IFR_disag_weighted_inc[i, j]

new_IFR_disag_weighted_inc[, ] <- if (step %% steps_per_day == 0)
  IFR_disag[i, j] * delta_infections[i, j] else
    IFR_disag_weighted_inc[i, j] + IFR_disag[i, j] * delta_infections[i, j]

# Output overall IFR trajectory
initial(ifr) <- NA
update(ifr) <- sum(new_IFR_disag_weighted_inc) / new_infections_inc

# Output IFR by age
dim(ifr_age) <- n_groups
initial(ifr_age[]) <- NA
update(ifr_age[]) <- sum(new_IFR_disag_weighted_inc[i, ]) /
  new_infections_inc_age[i]


## Confirmed hospital admissions
initial(cum_admit_conf) <- 0
delta_admit_conf <- sum(n_I_C_2_to_H_D_conf) + sum(n_I_C_2_to_H_R_conf)
update(cum_admit_conf) <- cum_admit_conf + delta_admit_conf

initial(admit_conf_inc) <- 0
update(admit_conf_inc) <- if (step %% steps_per_day == 0)
  delta_admit_conf else admit_conf_inc + delta_admit_conf


## Other state variables for post-processing
initial(cum_deaths_hosp) <- 0
delta_deaths_hosp <- sum(delta_D_hosp_disag)
update(cum_deaths_hosp) <- cum_deaths_hosp + delta_deaths_hosp

initial(hosp_deaths_inc) <- 0
update(hosp_deaths_inc) <- if (step %% steps_per_day == 0)
  delta_deaths_hosp else hosp_deaths_inc + delta_deaths_hosp

initial(cum_deaths_comm) <- 0
delta_deaths_comm <- sum(delta_D_non_hosp_disag)
update(cum_deaths_comm) <- cum_deaths_comm + delta_deaths_comm

initial(comm_deaths_inc) <- 0
update(comm_deaths_inc) <- if (step %% steps_per_day == 0)
  delta_deaths_comm else comm_deaths_inc + delta_deaths_comm



## Baseline deaths
base_death_step[] <- user()
dim(base_death_step) <- user()
base_death <- if (step >= length(base_death_step))
  base_death_step[length(base_death_step)] else base_death_step[step + 1]

initial(base_death_inc) <- 0
update(base_death_inc) <- base_death

initial(all_deaths_inc) <- 0
update(all_deaths_inc) <- base_death_inc + hosp_deaths_inc + comm_deaths_inc


## Calculate effective immunity
# Weight each person in S/R by their relative susceptibility. For those in R,
# we will further account for cross immunity.
dim(eff_sus_S) <- c(n_groups, n_vacc_classes)
dim(eff_sus_R) <- c(n_groups, n_vacc_classes)
eff_sus_S[, ] <- new_S[i, j] * rel_susceptibility[i, j]
eff_sus_R[, ] <- new_R[i, j] * (1 - cross_immunity) * rel_susceptibility[i, j]

initial(effective_susceptible) <- 0
update(effective_susceptible) <- sum(eff_sus_S[, ]) + sum(eff_sus_R[, ])

## Calculate the (weighted) number of individuals protected against infection
initial(protected_S_vaccinated) <- 0
initial(protected_R_unvaccinated) <- 0
initial(protected_R_vaccinated) <- 0
update(protected_S_vaccinated) <- sum(new_S) - sum(eff_sus_S)
update(protected_R_unvaccinated) <- sum(new_R[, 1]) - sum(eff_sus_R[, 1])
update(protected_R_vaccinated) <- sum(new_R) - sum(new_R[, 1]) -
  (sum(eff_sus_R) - sum(eff_sus_R[, 1]))
