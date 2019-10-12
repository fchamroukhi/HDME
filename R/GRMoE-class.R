#' A Reference Class which contains parameters of a GRMoE model.
#'
#' GRMoE contains all the parameters of a Gaussian Regularized
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
#' @field sigma Numeric. The standard deviation.
#' @field loglik Numeric. Observed-data log-likelihood of the GRMoE model.
#' @field storedloglik Numeric vector. Stored values of the log-likelihood at
#'   each EM iteration.
#' @field BIC Numeric. Value of BIC (Bayesian Information Criterion).
GRMoE <- setRefClass(
  "GRMoE",
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
    sigma = "numeric",

    loglik = "numeric",
    storedloglik = "numeric",
    BIC = "numeric"
  ),
  methods = list(
    initialize = function(X = matrix(), Y = numeric(1), K = 1, Lambda = 0, Gamma = 0,
                          wk = matrix(), betak = matrix(), sigma = 1, loglik = -Inf,
                          storedloglik = numeric(), BIC = -Inf) {

      X <<- X
      Y <<- Y

      d <<- dim(X)[2] # dim of X: d = p+1
      n <<- dim(X)[1]

      K <<- K
      Lambda <<- Lambda
      Gamma <<- Gamma

      wk <<- wk
      betak <<- betak
      sigma <<- sigma

      loglik <<- loglik
      storedloglik <<- storedloglik
      BIC <<- BIC

    },

    plot = function() {

    }
  )
)