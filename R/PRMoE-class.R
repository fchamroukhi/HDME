#' A Reference Class which contains parameters of a PRMoE model.
#'
#' PRMoE contains all the parameters of a Poisson Regularized
#' Mixture-of-Experts.
#'
#' @field X The matrix data for the input.
#' @field Y Vector of the response variable.
#' @field d Numeric. Number of explanatory variables (including the intercept
#'   variable).
#' @field n Numeric. Length of the response/output vector `Y`.
#' @field K Number of expert classes.
#' @field Lambda Penalty value for the expert part.
#' @field Gamma Penalty value for the gating network.
#' @field wk Parameters of the gating network. Matrix of dimension \eqn{(K - 1,
#'   d)}, with `d` the number of explanatory variables (including the
#'   intercept).
#' @field betak Regressions coefficients for each expert. Matrix of dimension
#'   \eqn{(d, K)}.
#' @field loglik Numeric. Observed-data log-likelihood of the PRMoE model.
#' @field storedloglik Numeric vector. Stored values of the log-likelihood at
#'   each EM iteration.
#' @field BIC Numeric. Value of BIC (Bayesian Information Criterion).
#' @field Cluster Numeric vector. Clustering label for each observation.
PRMoE <- setRefClass(
  "PRMoE",
  fields = list(

    X = "matrix",
    Y = "numeric",

    d = "numeric",
    n = "numeric",

    K = "numeric",
    Lambda = "numeric",
    Gamma = "numeric",

    wk = "matrix",
    betak = "matrix",

    loglik = "numeric",
    storedloglik = "numeric",
    BIC = "numeric",

    Cluster = "numeric"
  ),
  methods = list(
    initialize = function(X = matrix(), Y = numeric(1), K = 1, Lambda = 0, Gamma = 0,
                          wk = matrix(), betak = matrix(), loglik = -Inf,
                          storedloglik = numeric(), BIC = -Inf, Cluster = numeric()) {

      X <<- X
      Y <<- Y

      d <<- dim(X)[2] # dim of X: d = p+1
      n <<- dim(X)[1]

      K <<- K
      Lambda <<- Lambda
      Gamma <<- Gamma

      wk <<- wk
      betak <<- betak

      loglik <<- loglik
      storedloglik <<- storedloglik
      BIC <<- BIC

      Cluster <<- Cluster

    },

    plot = function() {
      "Plot method."

      # Log-likelihood
      graphics::plot(1:length(storedloglik), storedloglik, col = "blue", type = "o", pch = 19, xlab = 'Step', ylab = 'Log-likelihood')

    }
  )
)
