// Generated by dust (version 0.15.1) - do not edit
#include <cpp11.hpp>

[[cpp11::register]]
cpp11::sexp dust_basic_gpu_info();
[[cpp11::register]]
SEXP dust_cpu_basic_alloc(cpp11::list r_pars, bool pars_multi, cpp11::sexp r_time,
                         cpp11::sexp r_n_particles, int n_threads,
                         cpp11::sexp r_seed, bool deterministic,
                         cpp11::sexp gpu_config, cpp11::sexp ode_control);

[[cpp11::register]]
cpp11::sexp dust_cpu_basic_capabilities();

[[cpp11::register]]
SEXP dust_cpu_basic_run(SEXP ptr, cpp11::sexp r_time_end);

[[cpp11::register]]
SEXP dust_cpu_basic_simulate(SEXP ptr, cpp11::sexp time_end);

[[cpp11::register]]
SEXP dust_cpu_basic_run_adjoint(SEXP ptr);

[[cpp11::register]]
SEXP dust_cpu_basic_set_index(SEXP ptr, cpp11::sexp r_index);

[[cpp11::register]]
SEXP dust_cpu_basic_update_state(SEXP ptr, SEXP r_pars, SEXP r_state,
                                           SEXP r_time, SEXP r_set_initial_state,
                                           SEXP index, SEXP reset_step_size);

[[cpp11::register]]
SEXP dust_cpu_basic_state(SEXP ptr, SEXP r_index);

[[cpp11::register]]
SEXP dust_cpu_basic_time(SEXP ptr);

[[cpp11::register]]
void dust_cpu_basic_reorder(SEXP ptr, cpp11::sexp r_index);

[[cpp11::register]]
SEXP dust_cpu_basic_resample(SEXP ptr, cpp11::doubles r_weights);

[[cpp11::register]]
SEXP dust_cpu_basic_rng_state(SEXP ptr, bool first_only, bool last_only);

[[cpp11::register]]
SEXP dust_cpu_basic_set_rng_state(SEXP ptr, cpp11::raws rng_state);

[[cpp11::register]]
SEXP dust_cpu_basic_set_data(SEXP ptr, cpp11::list data, bool shared);

[[cpp11::register]]
SEXP dust_cpu_basic_compare_data(SEXP ptr);

[[cpp11::register]]
SEXP dust_cpu_basic_filter(SEXP ptr, SEXP time_end,
                                     bool save_trajectories,
                                     cpp11::sexp time_snapshot,
                                     cpp11::sexp min_log_likelihood);

[[cpp11::register]]
void dust_cpu_basic_set_n_threads(SEXP ptr, int n_threads);

[[cpp11::register]]
int dust_cpu_basic_n_state(SEXP ptr);

[[cpp11::register]]
void dust_cpu_basic_set_stochastic_schedule(SEXP ptr, SEXP time);

[[cpp11::register]]
SEXP dust_cpu_basic_ode_statistics(SEXP ptr);
#include <dust/r/dust.hpp>

// Generated by odin.dust (version 0.3.3) - do not edit
template <typename real_type, typename container>
__host__ __device__ real_type odin_sum1(const container x, size_t from, size_t to);
template <typename real_type, typename container>
__host__ __device__ real_type odin_sum2(const container x, int from_i, int to_i, int from_j, int to_j, int dim_x_1);
template <typename real_type, typename T, typename U>
__host__ __device__ real_type fmodr(T x, U y) {
  real_type tmp = std::fmod(static_cast<real_type>(x),
                            static_cast<real_type>(y));
  if (tmp * y < 0) {
    tmp += y;
  }
  return tmp;
}

// These exist to support the model on the gpu, as in C++14 std::min
// and std::max are constexpr and error without --expt-relaxed-constexpr
template <typename T>
__host__ __device__ T odin_min(T x, T y) {
  return x < y ? x : y;
}

template <typename T>
__host__ __device__ T odin_max(T x, T y) {
  return x > y ? x : y;
}

template <typename T>
__host__ __device__ T odin_sign(T x) {
  return (x > 0) ? 1 : ((x < 0) ? -1 : 0);
}
// [[dust::class(basic)]]
// [[dust::time_type(discrete)]]
// [[dust::param(E2_ini, has_default = FALSE, default_value = NULL, rank = 1, min = -Inf, max = Inf, integer = FALSE)]]
// [[dust::param(E_ini, has_default = FALSE, default_value = NULL, rank = 1, min = -Inf, max = Inf, integer = FALSE)]]
// [[dust::param(I_ini, has_default = FALSE, default_value = NULL, rank = 1, min = -Inf, max = Inf, integer = FALSE)]]
// [[dust::param(N_age, has_default = FALSE, default_value = NULL, rank = 0, min = -Inf, max = Inf, integer = FALSE)]]
// [[dust::param(R_ini, has_default = FALSE, default_value = NULL, rank = 1, min = -Inf, max = Inf, integer = FALSE)]]
// [[dust::param(S_ini, has_default = FALSE, default_value = NULL, rank = 1, min = -Inf, max = Inf, integer = FALSE)]]
// [[dust::param(beta_step, has_default = FALSE, default_value = NULL, rank = 1, min = -Inf, max = Inf, integer = FALSE)]]
// [[dust::param(eta_R, has_default = FALSE, default_value = NULL, rank = 0, min = -Inf, max = Inf, integer = FALSE)]]
// [[dust::param(gamma_E, has_default = FALSE, default_value = NULL, rank = 0, min = -Inf, max = Inf, integer = FALSE)]]
// [[dust::param(gamma_I, has_default = FALSE, default_value = NULL, rank = 0, min = -Inf, max = Inf, integer = FALSE)]]
// [[dust::param(m, has_default = FALSE, default_value = NULL, rank = 2, min = -Inf, max = Inf, integer = FALSE)]]
// [[dust::param(rho, has_default = FALSE, default_value = NULL, rank = 0, min = -Inf, max = Inf, integer = FALSE)]]
// [[dust::param(steps_per_day, has_default = FALSE, default_value = NULL, rank = 0, min = -Inf, max = Inf, integer = FALSE)]]
class basic {
public:
  using real_type = double;
  using rng_state_type = dust::random::generator<real_type>;
  using data_type = dust::no_data;
  struct shared_type {
    std::vector<real_type> E2_ini;
    std::vector<real_type> E_ini;
    std::vector<real_type> I_ini;
    int N_age;
    std::vector<real_type> R_ini;
    std::vector<real_type> S_ini;
    std::vector<real_type> beta_step;
    int dim_E1;
    int dim_E2;
    int dim_E2_ini;
    int dim_E_ini;
    int dim_I;
    int dim_I_ini;
    int dim_R;
    int dim_R_ini;
    int dim_S;
    int dim_S_ini;
    int dim_beta_step;
    int dim_delta_E1;
    int dim_delta_E2;
    int dim_delta_I;
    int dim_delta_R;
    int dim_delta_S;
    int dim_lambda;
    int dim_m;
    int dim_m_1;
    int dim_m_2;
    int dim_n_EE;
    int dim_n_EI;
    int dim_n_IR;
    int dim_n_RS;
    int dim_n_SE;
    int dim_new_I;
    int dim_p_SE;
    int dim_s_ij;
    int dim_s_ij_1;
    int dim_s_ij_2;
    int dim_temp;
    real_type dt;
    real_type eta_R;
    real_type gamma_E;
    real_type gamma_I;
    std::vector<real_type> initial_E1;
    std::vector<real_type> initial_E2;
    std::vector<real_type> initial_I;
    std::vector<real_type> initial_R;
    std::vector<real_type> initial_S;
    real_type initial_beta_out;
    real_type initial_cases_15_19;
    real_type initial_cases_20_29;
    real_type initial_cases_30_39;
    real_type initial_cases_40_49;
    real_type initial_cases_50_plus;
    real_type initial_cases_under_15;
    std::vector<real_type> initial_new_I;
    real_type initial_time;
    std::vector<real_type> m;
    int offset_variable_E1;
    int offset_variable_E2;
    int offset_variable_I;
    int offset_variable_R;
    int offset_variable_new_I;
    real_type p_EE;
    real_type p_EI;
    real_type p_IR;
    real_type p_RS;
    real_type rho;
    int steps_per_day;
  };
  struct internal_type {
    std::vector<real_type> delta_E1;
    std::vector<real_type> delta_E2;
    std::vector<real_type> delta_I;
    std::vector<real_type> delta_R;
    std::vector<real_type> delta_S;
    std::vector<real_type> lambda;
    std::vector<real_type> n_EE;
    std::vector<real_type> n_EI;
    std::vector<real_type> n_IR;
    std::vector<real_type> n_RS;
    std::vector<real_type> n_SE;
    std::vector<real_type> p_SE;
    std::vector<real_type> s_ij;
    std::vector<real_type> temp;
  };
  basic(const dust::pars_type<basic>& pars) :
    shared(pars.shared), internal(pars.internal) {
  }
  size_t size() const {
    return shared->dim_E1 + shared->dim_E2 + shared->dim_I + shared->dim_R + shared->dim_S + shared->dim_new_I + 8;
  }
  std::vector<real_type> initial(size_t step, rng_state_type& rng_state) {
    std::vector<real_type> state(shared->dim_E1 + shared->dim_E2 + shared->dim_I + shared->dim_R + shared->dim_S + shared->dim_new_I + 8);
    state[0] = shared->initial_time;
    state[1] = shared->initial_beta_out;
    state[2] = shared->initial_cases_under_15;
    state[3] = shared->initial_cases_15_19;
    state[4] = shared->initial_cases_20_29;
    state[5] = shared->initial_cases_30_39;
    state[6] = shared->initial_cases_40_49;
    state[7] = shared->initial_cases_50_plus;
    std::copy(shared->initial_S.begin(), shared->initial_S.end(), state.begin() + 8);
    std::copy(shared->initial_E1.begin(), shared->initial_E1.end(), state.begin() + shared->offset_variable_E1);
    std::copy(shared->initial_E2.begin(), shared->initial_E2.end(), state.begin() + shared->offset_variable_E2);
    std::copy(shared->initial_I.begin(), shared->initial_I.end(), state.begin() + shared->offset_variable_I);
    std::copy(shared->initial_R.begin(), shared->initial_R.end(), state.begin() + shared->offset_variable_R);
    std::copy(shared->initial_new_I.begin(), shared->initial_new_I.end(), state.begin() + shared->offset_variable_new_I);
    return state;
  }
  void update(size_t step, const real_type * state, rng_state_type& rng_state, real_type * state_next) {
    const real_type * S = state + 8;
    const real_type * E1 = state + shared->offset_variable_E1;
    const real_type * E2 = state + shared->offset_variable_E2;
    const real_type * I = state + shared->offset_variable_I;
    const real_type * R = state + shared->offset_variable_R;
    const real_type * new_I = state + shared->offset_variable_new_I;
    const real_type cases_under_15 = state[2];
    const real_type cases_15_19 = state[3];
    const real_type cases_20_29 = state[4];
    const real_type cases_30_39 = state[5];
    const real_type cases_40_49 = state[6];
    const real_type cases_50_plus = state[7];
    real_type delta_case_15_19 = new_I[3] * shared->rho;
    real_type delta_case_20_29 = odin_sum1<real_type>(new_I, 4, 6) * shared->rho;
    real_type delta_case_30_39 = odin_sum1<real_type>(new_I, 6, 8) * shared->rho;
    real_type delta_case_40_49 = odin_sum1<real_type>(new_I, 8, 10) * shared->rho;
    real_type delta_case_50_plus = odin_sum1<real_type>(new_I, 10, shared->N_age) * shared->rho;
    real_type delta_case_under_15 = odin_sum1<real_type>(new_I, 0, 3) * shared->rho;
    real_type beta = (step >= shared->dim_beta_step ? shared->beta_step[shared->dim_beta_step - 1] : shared->beta_step[step + 1 - 1]);
    state_next[3] = (fmodr<real_type>(step, shared->steps_per_day) == 0 ? delta_case_15_19 : delta_case_15_19 + cases_15_19);
    state_next[4] = (fmodr<real_type>(step, shared->steps_per_day) == 0 ? delta_case_20_29 : delta_case_20_29 + cases_20_29);
    state_next[5] = (fmodr<real_type>(step, shared->steps_per_day) == 0 ? delta_case_30_39 : delta_case_30_39 + cases_30_39);
    state_next[6] = (fmodr<real_type>(step, shared->steps_per_day) == 0 ? delta_case_40_49 : delta_case_40_49 + cases_40_49);
    state_next[7] = (fmodr<real_type>(step, shared->steps_per_day) == 0 ? delta_case_50_plus : delta_case_50_plus + cases_50_plus);
    state_next[2] = (fmodr<real_type>(step, shared->steps_per_day) == 0 ? delta_case_under_15 : delta_case_under_15 + cases_under_15);
    state_next[0] = (step + 1) * shared->dt;
    for (int i = 1; i <= shared->dim_n_EE; ++i) {
      internal.n_EE[i - 1] = dust::random::binomial<real_type>(rng_state, E1[i - 1], shared->p_EE);
    }
    for (int i = 1; i <= shared->dim_n_EI; ++i) {
      internal.n_EI[i - 1] = dust::random::binomial<real_type>(rng_state, E2[i - 1], shared->p_EI);
    }
    for (int i = 1; i <= shared->dim_n_IR; ++i) {
      internal.n_IR[i - 1] = dust::random::binomial<real_type>(rng_state, I[i - 1], shared->p_IR);
    }
    for (int i = 1; i <= shared->dim_n_RS; ++i) {
      internal.n_RS[i - 1] = dust::random::binomial<real_type>(rng_state, R[i - 1], shared->p_RS);
    }
    for (int i = 1; i <= shared->dim_temp; ++i) {
      internal.temp[i - 1] = I[i - 1];
    }
    state_next[1] = beta;
    for (int i = 1; i <= shared->dim_delta_E2; ++i) {
      internal.delta_E2[i - 1] = internal.n_EE[i - 1] - internal.n_EI[i - 1];
    }
    for (int i = 1; i <= shared->dim_delta_I; ++i) {
      internal.delta_I[i - 1] = internal.n_EI[i - 1] - internal.n_IR[i - 1];
    }
    for (int i = 1; i <= shared->dim_delta_R; ++i) {
      internal.delta_R[i - 1] = internal.n_IR[i - 1] - internal.n_RS[i - 1];
    }
    for (int i = 1; i <= shared->dim_s_ij_1; ++i) {
      for (int j = 1; j <= shared->dim_s_ij_2; ++j) {
        internal.s_ij[i - 1 + shared->dim_s_ij_1 * (j - 1)] = shared->m[shared->dim_m_1 * (j - 1) + i - 1] * internal.temp[j - 1];
      }
    }
    for (int i = 1; i <= shared->dim_new_I; ++i) {
      state_next[shared->offset_variable_new_I + i - 1] = (fmodr<real_type>(step, shared->steps_per_day) == 0 ? internal.n_EI[i - 1] : new_I[i - 1] + internal.n_EI[i - 1]);
    }
    for (int i = 1; i <= shared->dim_lambda; ++i) {
      internal.lambda[i - 1] = beta * odin_sum2<real_type>(internal.s_ij.data(), i - 1, i, 0, shared->dim_s_ij_2, shared->dim_s_ij_1);
    }
    for (int i = 1; i <= shared->dim_E2; ++i) {
      state_next[shared->offset_variable_E2 + i - 1] = E2[i - 1] + internal.delta_E2[i - 1];
    }
    for (int i = 1; i <= shared->dim_I; ++i) {
      state_next[shared->offset_variable_I + i - 1] = I[i - 1] + internal.delta_I[i - 1];
    }
    for (int i = 1; i <= shared->dim_R; ++i) {
      state_next[shared->offset_variable_R + i - 1] = R[i - 1] + internal.delta_R[i - 1];
    }
    for (int i = 1; i <= shared->dim_p_SE; ++i) {
      internal.p_SE[i - 1] = 1 - dust::math::exp(- internal.lambda[i - 1] * shared->dt);
    }
    for (int i = 1; i <= shared->dim_n_SE; ++i) {
      internal.n_SE[i - 1] = dust::random::binomial<real_type>(rng_state, S[i - 1], internal.p_SE[i - 1]);
    }
    for (int i = 1; i <= shared->dim_delta_E1; ++i) {
      internal.delta_E1[i - 1] = internal.n_SE[i - 1] - internal.n_EE[i - 1];
    }
    for (int i = 1; i <= shared->dim_delta_S; ++i) {
      internal.delta_S[i - 1] = internal.n_RS[i - 1] - internal.n_SE[i - 1];
    }
    for (int i = 1; i <= shared->dim_E1; ++i) {
      state_next[shared->offset_variable_E1 + i - 1] = E1[i - 1] + internal.delta_E1[i - 1];
    }
    for (int i = 1; i <= shared->dim_S; ++i) {
      state_next[8 + i - 1] = S[i - 1] + internal.delta_S[i - 1];
    }
  }
private:
  std::shared_ptr<const shared_type> shared;
  internal_type internal;
};
template <typename real_type, typename container>
__host__ __device__ real_type odin_sum2(const container x, int from_i, int to_i, int from_j, int to_j, int dim_x_1) {
  real_type tot = 0.0;
  for (int j = from_j; j < to_j; ++j) {
    int jj = j * dim_x_1;
    for (int i = from_i; i < to_i; ++i) {
      tot += x[i + jj];
    }
  }
  return tot;
}
#include <array>
#include <cpp11/R.hpp>
#include <cpp11/sexp.hpp>
#include <cpp11/doubles.hpp>
#include <cpp11/integers.hpp>
#include <cpp11/list.hpp>
#include <cpp11/strings.hpp>
#include <memory>
#include <vector>

template <typename T>
inline bool is_na(T x);

template <>
inline bool is_na(int x) {
  return x == NA_INTEGER;
}

template <>
inline bool is_na(double x) {
  return ISNA(x);
}

inline size_t object_length(cpp11::sexp x) {
  return ::Rf_xlength(x);
}

template <typename T>
void user_check_value(T value, const char *name, T min, T max) {
  if (is_na(value)) {
    cpp11::stop("'%s' must not be NA", name);
  }
  if (!is_na(min) && value < min) {
    cpp11::stop("Expected '%s' to be at least %g", name, (double) min);
  }
  if (!is_na(max) && value > max) {
    cpp11::stop("Expected '%s' to be at most %g", name, (double) max);
  }
}

template <typename T>
void user_check_array_value(const std::vector<T>& value, const char *name,
                            T min, T max) {
  for (auto& x : value) {
    user_check_value(x, name, min, max);
  }
}

inline size_t user_get_array_rank(cpp11::sexp x) {
  if (!::Rf_isArray(x)) {
    return 1;
  } else {
    cpp11::integers dim = cpp11::as_cpp<cpp11::integers>(x.attr("dim"));
    return dim.size();
  }
}

template <size_t N>
void user_check_array_rank(cpp11::sexp x, const char *name) {
  size_t rank = user_get_array_rank(x);
  if (rank != N) {
    if (N == 1) {
      cpp11::stop("Expected a vector for '%s'", name);
    } else if (N == 2) {
      cpp11::stop("Expected a matrix for '%s'", name);
    } else {
      cpp11::stop("Expected an array of rank %d for '%s'", N, name);
    }
  }
}

template <size_t N>
void user_check_array_dim(cpp11::sexp x, const char *name,
                          const std::array<int, N>& dim_expected) {
  cpp11::integers dim = cpp11::as_cpp<cpp11::integers>(x.attr("dim"));
  for (size_t i = 0; i < N; ++i) {
    if (dim[(int)i] != dim_expected[i]) {
      Rf_error("Incorrect size of dimension %d of '%s' (expected %d)",
               i + 1, name, dim_expected[i]);
    }
  }
}

template <>
inline void user_check_array_dim<1>(cpp11::sexp x, const char *name,
                                    const std::array<int, 1>& dim_expected) {
  if ((int)object_length(x) != dim_expected[0]) {
    cpp11::stop("Expected length %d value for '%s'", dim_expected[0], name);
  }
}

template <size_t N>
void user_set_array_dim(cpp11::sexp x, const char *name,
                        std::array<int, N>& dim) {
  cpp11::integers dim_given = cpp11::as_cpp<cpp11::integers>(x.attr("dim"));
  std::copy(dim_given.begin(), dim_given.end(), dim.begin());
}

template <>
inline void user_set_array_dim<1>(cpp11::sexp x, const char *name,
                                  std::array<int, 1>& dim) {
  dim[0] = object_length(x);
}

template <typename T>
T user_get_scalar(cpp11::list user, const char *name,
                  const T previous, T min, T max) {
  T ret = previous;
  cpp11::sexp x = user[name];
  if (x != R_NilValue) {
    if (object_length(x) != 1) {
      cpp11::stop("Expected a scalar numeric for '%s'", name);
    }
    // TODO: when we're getting out an integer this is a bit too relaxed
    if (TYPEOF(x) == REALSXP) {
      ret = cpp11::as_cpp<T>(x);
    } else if (TYPEOF(x) == INTSXP) {
      ret = cpp11::as_cpp<T>(x);
    } else {
      cpp11::stop("Expected a numeric value for %s", name);
    }
  }

  if (is_na(ret)) {
    cpp11::stop("Expected a value for '%s'", name);
  }
  user_check_value<T>(ret, name, min, max);
  return ret;
}

template <>
inline float user_get_scalar<float>(cpp11::list user, const char *name,
                                    const float previous, float min, float max) {
  double value = user_get_scalar<double>(user, name, previous, min, max);
  return static_cast<float>(value);
}

template <typename T>
std::vector<T> user_get_array_value(cpp11::sexp x, const char * name,
                                    T min, T max) {
  std::vector<T> ret = cpp11::as_cpp<std::vector<T>>(x);
  user_check_array_value<T>(ret, name, min, max);
  return ret;
}

template <typename T, size_t N>
std::vector<T> user_get_array_fixed(cpp11::list user, const char *name,
                                    const std::vector<T> previous,
                                    const std::array<int, N>& dim,
                                    T min, T max) {
  cpp11::sexp x = user[name];
  if (x == R_NilValue) {
    if (previous.size() == 0) {
      cpp11::stop("Expected a value for '%s'", name);
    }
    return previous;
  }

  user_check_array_rank<N>(x, name);
  user_check_array_dim<N>(x, name, dim);

  return user_get_array_value<T>(x, name, min, max);
}

template <typename T, size_t N>
std::vector<T> user_get_array_variable(cpp11::list user, const char *name,
                                       std::vector<T> previous,
                                       std::array<int, N>& dim,
                                       T min, T max) {
  cpp11::sexp x = user[name];
  if (x == R_NilValue) {
    if (previous.size() == 0) {
      cpp11::stop("Expected a value for '%s'", name);
    }
    return previous;
  }

  user_check_array_rank<N>(x, name);
  user_set_array_dim<N>(x, name, dim);

  return user_get_array_value<T>(x, name, min, max);
}

template <>
inline std::vector<float> user_get_array_value(cpp11::sexp x, const char * name,
                                               float min, float max) {
  // NOTE: possible under/overflow here for min/max because we've
  // downcast this.
  std::vector<double> value = user_get_array_value<double>(x, name, min, max);
  std::vector<float> ret(value.size());
  std::copy(value.begin(), value.end(), ret.begin());
  return ret;
}

// This is sum with inclusive "from", exclusive "to", following the
// same function in odin
template <typename real_type, typename container>
__host__ __device__
real_type odin_sum1(const container x, size_t from, size_t to) {
  real_type tot = 0.0;
  for (size_t i = from; i < to; ++i) {
    tot += x[i];
  }
  return tot;
}

inline cpp11::writable::integers integer_sequence(size_t from, size_t len) {
  cpp11::writable::integers ret(len);
  int* data = INTEGER(ret);
  for (size_t i = 0, j = from; i < len; ++i, ++j) {
    data[i] = j;
  }
  return ret;
}
namespace dust {
template<>
dust::pars_type<basic> dust_pars<basic>(cpp11::list user) {
  using real_type = typename basic::real_type;
  auto shared = std::make_shared<basic::shared_type>();
  basic::internal_type internal;
  shared->initial_cases_15_19 = 0;
  shared->initial_cases_20_29 = 0;
  shared->initial_cases_30_39 = 0;
  shared->initial_cases_40_49 = 0;
  shared->initial_cases_50_plus = 0;
  shared->initial_cases_under_15 = 0;
  shared->initial_time = 0;
  shared->N_age = NA_INTEGER;
  shared->eta_R = NA_REAL;
  shared->gamma_E = NA_REAL;
  shared->gamma_I = NA_REAL;
  shared->rho = NA_REAL;
  shared->steps_per_day = NA_INTEGER;
  shared->N_age = user_get_scalar<int>(user, "N_age", shared->N_age, NA_INTEGER, NA_INTEGER);
  std::array <int, 1> dim_beta_step;
  shared->beta_step = user_get_array_variable<real_type, 1>(user, "beta_step", shared->beta_step, dim_beta_step, NA_REAL, NA_REAL);
  shared->dim_beta_step = shared->beta_step.size();
  shared->eta_R = user_get_scalar<real_type>(user, "eta_R", shared->eta_R, NA_REAL, NA_REAL);
  shared->gamma_E = user_get_scalar<real_type>(user, "gamma_E", shared->gamma_E, NA_REAL, NA_REAL);
  shared->gamma_I = user_get_scalar<real_type>(user, "gamma_I", shared->gamma_I, NA_REAL, NA_REAL);
  shared->rho = user_get_scalar<real_type>(user, "rho", shared->rho, NA_REAL, NA_REAL);
  shared->steps_per_day = user_get_scalar<int>(user, "steps_per_day", shared->steps_per_day, NA_INTEGER, NA_INTEGER);
  shared->dim_E1 = shared->N_age;
  shared->dim_E2 = shared->N_age;
  shared->dim_E2_ini = shared->N_age;
  shared->dim_E_ini = shared->N_age;
  shared->dim_I = shared->N_age;
  shared->dim_I_ini = shared->N_age;
  shared->dim_R = shared->N_age;
  shared->dim_R_ini = shared->N_age;
  shared->dim_S = shared->N_age;
  shared->dim_S_ini = shared->N_age;
  shared->dim_delta_E1 = shared->N_age;
  shared->dim_delta_E2 = shared->N_age;
  shared->dim_delta_I = shared->N_age;
  shared->dim_delta_R = shared->N_age;
  shared->dim_delta_S = shared->N_age;
  shared->dim_lambda = shared->N_age;
  shared->dim_m_1 = shared->N_age;
  shared->dim_m_2 = shared->N_age;
  shared->dim_n_EE = shared->N_age;
  shared->dim_n_EI = shared->N_age;
  shared->dim_n_IR = shared->N_age;
  shared->dim_n_RS = shared->N_age;
  shared->dim_n_SE = shared->N_age;
  shared->dim_new_I = shared->N_age;
  shared->dim_p_SE = shared->N_age;
  shared->dim_s_ij_1 = shared->N_age;
  shared->dim_s_ij_2 = shared->N_age;
  shared->dim_temp = shared->N_age;
  shared->dt = 1 / (real_type) shared->steps_per_day;
  shared->initial_beta_out = shared->beta_step[0];
  shared->E2_ini = user_get_array_fixed<real_type, 1>(user, "E2_ini", shared->E2_ini, {shared->dim_E2_ini}, NA_REAL, NA_REAL);
  shared->E_ini = user_get_array_fixed<real_type, 1>(user, "E_ini", shared->E_ini, {shared->dim_E_ini}, NA_REAL, NA_REAL);
  shared->I_ini = user_get_array_fixed<real_type, 1>(user, "I_ini", shared->I_ini, {shared->dim_I_ini}, NA_REAL, NA_REAL);
  shared->R_ini = user_get_array_fixed<real_type, 1>(user, "R_ini", shared->R_ini, {shared->dim_R_ini}, NA_REAL, NA_REAL);
  shared->S_ini = user_get_array_fixed<real_type, 1>(user, "S_ini", shared->S_ini, {shared->dim_S_ini}, NA_REAL, NA_REAL);
  internal.delta_E1 = std::vector<real_type>(shared->dim_delta_E1);
  internal.delta_E2 = std::vector<real_type>(shared->dim_delta_E2);
  internal.delta_I = std::vector<real_type>(shared->dim_delta_I);
  internal.delta_R = std::vector<real_type>(shared->dim_delta_R);
  internal.delta_S = std::vector<real_type>(shared->dim_delta_S);
  shared->initial_E1 = std::vector<real_type>(shared->dim_E1);
  shared->initial_E2 = std::vector<real_type>(shared->dim_E2);
  shared->initial_I = std::vector<real_type>(shared->dim_I);
  shared->initial_R = std::vector<real_type>(shared->dim_R);
  shared->initial_S = std::vector<real_type>(shared->dim_S);
  shared->initial_new_I = std::vector<real_type>(shared->dim_new_I);
  internal.lambda = std::vector<real_type>(shared->dim_lambda);
  internal.n_EE = std::vector<real_type>(shared->dim_n_EE);
  internal.n_EI = std::vector<real_type>(shared->dim_n_EI);
  internal.n_IR = std::vector<real_type>(shared->dim_n_IR);
  internal.n_RS = std::vector<real_type>(shared->dim_n_RS);
  internal.n_SE = std::vector<real_type>(shared->dim_n_SE);
  internal.p_SE = std::vector<real_type>(shared->dim_p_SE);
  internal.temp = std::vector<real_type>(shared->dim_temp);
  shared->dim_m = shared->dim_m_1 * shared->dim_m_2;
  shared->dim_s_ij = shared->dim_s_ij_1 * shared->dim_s_ij_2;
  for (int i = 1; i <= shared->dim_new_I; ++i) {
    shared->initial_new_I[i - 1] = 0;
  }
  shared->offset_variable_E1 = shared->dim_S + 8;
  shared->offset_variable_E2 = shared->dim_E1 + shared->dim_S + 8;
  shared->offset_variable_I = shared->dim_E1 + shared->dim_E2 + shared->dim_S + 8;
  shared->offset_variable_R = shared->dim_E1 + shared->dim_E2 + shared->dim_I + shared->dim_S + 8;
  shared->offset_variable_new_I = shared->dim_E1 + shared->dim_E2 + shared->dim_I + shared->dim_R + shared->dim_S + 8;
  shared->p_EE = 1 - dust::math::exp(- shared->gamma_E * shared->dt);
  shared->p_EI = 1 - dust::math::exp(- shared->gamma_E * shared->dt);
  shared->p_IR = 1 - dust::math::exp(- shared->gamma_I * shared->dt);
  shared->p_RS = 1 - dust::math::exp(- shared->eta_R * shared->dt);
  internal.s_ij = std::vector<real_type>(shared->dim_s_ij);
  for (int i = 1; i <= shared->dim_E1; ++i) {
    shared->initial_E1[i - 1] = shared->E_ini[i - 1];
  }
  for (int i = 1; i <= shared->dim_E2; ++i) {
    shared->initial_E2[i - 1] = shared->E2_ini[i - 1];
  }
  for (int i = 1; i <= shared->dim_I; ++i) {
    shared->initial_I[i - 1] = shared->I_ini[i - 1];
  }
  for (int i = 1; i <= shared->dim_R; ++i) {
    shared->initial_R[i - 1] = shared->R_ini[i - 1];
  }
  for (int i = 1; i <= shared->dim_S; ++i) {
    shared->initial_S[i - 1] = shared->S_ini[i - 1];
  }
  shared->m = user_get_array_fixed<real_type, 2>(user, "m", shared->m, {shared->dim_m_1, shared->dim_m_2}, NA_REAL, NA_REAL);
  return dust::pars_type<basic>(shared, internal);
}
template <>
cpp11::sexp dust_info<basic>(const dust::pars_type<basic>& pars) {
  const std::shared_ptr<const basic::shared_type> shared = pars.shared;
  cpp11::writable::strings nms({"time", "beta_out", "cases_under_15", "cases_15_19", "cases_20_29", "cases_30_39", "cases_40_49", "cases_50_plus", "S", "E1", "E2", "I", "R", "new_I"});
  cpp11::writable::list dim(14);
  dim[0] = cpp11::writable::integers({1});
  dim[1] = cpp11::writable::integers({1});
  dim[2] = cpp11::writable::integers({1});
  dim[3] = cpp11::writable::integers({1});
  dim[4] = cpp11::writable::integers({1});
  dim[5] = cpp11::writable::integers({1});
  dim[6] = cpp11::writable::integers({1});
  dim[7] = cpp11::writable::integers({1});
  dim[8] = cpp11::writable::integers({shared->dim_S});
  dim[9] = cpp11::writable::integers({shared->dim_E1});
  dim[10] = cpp11::writable::integers({shared->dim_E2});
  dim[11] = cpp11::writable::integers({shared->dim_I});
  dim[12] = cpp11::writable::integers({shared->dim_R});
  dim[13] = cpp11::writable::integers({shared->dim_new_I});
  dim.names() = nms;
  cpp11::writable::list index(14);
  index[0] = cpp11::writable::integers({1});
  index[1] = cpp11::writable::integers({2});
  index[2] = cpp11::writable::integers({3});
  index[3] = cpp11::writable::integers({4});
  index[4] = cpp11::writable::integers({5});
  index[5] = cpp11::writable::integers({6});
  index[6] = cpp11::writable::integers({7});
  index[7] = cpp11::writable::integers({8});
  index[8] = integer_sequence(9, shared->dim_S);
  index[9] = integer_sequence(shared->offset_variable_E1 + 1, shared->dim_E1);
  index[10] = integer_sequence(shared->offset_variable_E2 + 1, shared->dim_E2);
  index[11] = integer_sequence(shared->offset_variable_I + 1, shared->dim_I);
  index[12] = integer_sequence(shared->offset_variable_R + 1, shared->dim_R);
  index[13] = integer_sequence(shared->offset_variable_new_I + 1, shared->dim_new_I);
  index.names() = nms;
  size_t len = shared->offset_variable_new_I + shared->dim_new_I;
  using namespace cpp11::literals;
  return cpp11::writable::list({
           "dim"_nm = dim,
           "len"_nm = len,
           "index"_nm = index});
}
}

cpp11::sexp dust_basic_gpu_info() {
  return dust::gpu::r::gpu_info();
}
using model_cpu = dust::dust_cpu<basic>;

cpp11::sexp dust_cpu_basic_capabilities() {
  return dust::r::dust_capabilities<model_cpu>();
}

SEXP dust_cpu_basic_alloc(cpp11::list r_pars, bool pars_multi, cpp11::sexp r_time,
                             cpp11::sexp r_n_particles, int n_threads,
                             cpp11::sexp r_seed, bool deterministic,
                             cpp11::sexp gpu_config, cpp11::sexp ode_control) {
  return dust::r::dust_cpu_alloc<basic>(r_pars, pars_multi, r_time, r_n_particles,
                                        n_threads, r_seed, deterministic,
                                        gpu_config, ode_control);
}

SEXP dust_cpu_basic_run(SEXP ptr, cpp11::sexp r_time_end) {
  return dust::r::dust_run<model_cpu>(ptr, r_time_end);
}

SEXP dust_cpu_basic_simulate(SEXP ptr, cpp11::sexp r_time_end) {
  return dust::r::dust_simulate<model_cpu>(ptr, r_time_end);
}

SEXP dust_cpu_basic_run_adjoint(SEXP ptr) {
  return dust::r::dust_run_adjoint<model_cpu>(ptr);
}

SEXP dust_cpu_basic_set_index(SEXP ptr, cpp11::sexp r_index) {
  dust::r::dust_set_index<model_cpu>(ptr, r_index);
  return R_NilValue;
}

SEXP dust_cpu_basic_update_state(SEXP ptr, SEXP r_pars, SEXP r_state,
                                           SEXP r_time, SEXP r_set_initial_state, SEXP index, SEXP reset_step_size) {
  return dust::r::dust_update_state<model_cpu>(ptr, r_pars, r_state, r_time,
                                                      r_set_initial_state, index, reset_step_size);
}

SEXP dust_cpu_basic_state(SEXP ptr, SEXP r_index) {
  return dust::r::dust_state<model_cpu>(ptr, r_index);
}

SEXP dust_cpu_basic_time(SEXP ptr) {
  return dust::r::dust_time<model_cpu>(ptr);
}

void dust_cpu_basic_reorder(SEXP ptr, cpp11::sexp r_index) {
  return dust::r::dust_reorder<model_cpu>(ptr, r_index);
}

SEXP dust_cpu_basic_resample(SEXP ptr, cpp11::doubles r_weights) {
  return dust::r::dust_resample<model_cpu>(ptr, r_weights);
}

SEXP dust_cpu_basic_rng_state(SEXP ptr, bool first_only, bool last_only) {
  return dust::r::dust_rng_state<model_cpu>(ptr, first_only, last_only);
}

SEXP dust_cpu_basic_set_rng_state(SEXP ptr, cpp11::raws rng_state) {
  dust::r::dust_set_rng_state<model_cpu>(ptr, rng_state);
  return R_NilValue;
}

SEXP dust_cpu_basic_set_data(SEXP ptr, cpp11::list data,
                                       bool shared) {
  dust::r::dust_set_data<model_cpu>(ptr, data, shared);
  return R_NilValue;
}

SEXP dust_cpu_basic_compare_data(SEXP ptr) {
  return dust::r::dust_compare_data<model_cpu>(ptr);
}

SEXP dust_cpu_basic_filter(SEXP ptr, SEXP time_end,
                                     bool save_trajectories,
                                     cpp11::sexp time_snapshot,
                                     cpp11::sexp min_log_likelihood) {
  return dust::r::dust_filter<model_cpu>(ptr, time_end,
                                                save_trajectories,
                                                time_snapshot,
                                                min_log_likelihood);
}

void dust_cpu_basic_set_n_threads(SEXP ptr, int n_threads) {
  return dust::r::dust_set_n_threads<model_cpu>(ptr, n_threads);
}

int dust_cpu_basic_n_state(SEXP ptr) {
  return dust::r::dust_n_state<model_cpu>(ptr);
}

void dust_cpu_basic_set_stochastic_schedule(SEXP ptr, SEXP time) {
  dust::r::dust_set_stochastic_schedule<model_cpu>(ptr, time);
}

SEXP dust_cpu_basic_ode_statistics(SEXP ptr) {
  return dust::r::dust_ode_statistics<model_cpu>(ptr);
}
