set.seed(22)

bayesian_linear_regression_model <- "
data {
  int<lower=1> N;
  vector[N] x;
  vector[N] y;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}
model {
  // Priors
  alpha ~ normal(0, 5);
  beta  ~ normal(0, 5);
  sigma ~ inv_gamma(1, 1);
  
  // Likelihood
  y ~ normal(alpha + beta * x, sigma);
}
"

model_file <- cmdstanr::write_stan_file(bayesian_linear_regression_model)
model <- cmdstanr::cmdstan_model(model_file)

N <- 100
alpha <- 2
beta <- -0.5
sigma <- 1.e-1

x <- rnorm(N, 0, 1)
y <- rnorm(N, mean = alpha + beta * x, sd = sigma)

inputs <- list(N = N, x = x, y = y)

fit <- model$sample(
  data = inputs,
  seed = 22)

summary(fit)