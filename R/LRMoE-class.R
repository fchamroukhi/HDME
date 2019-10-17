#' A Reference Class which contains parameters of a LRMoE model.
#'
#' LRMoE contains all the parameters of a Logistic Regularized
#' Mixture-of-Experts.
#'
#' @field X The matrix data for the input.
#' @field Y Vector of the response variable.
#' @field d Numeric. Number of explanatory variables (including the intercept
#'   variable).
#' @field n Numeric. Length of the response/output vector `Y`.
#' @field R Numeric. Maximum value of `Y`.
#' @field K Number of expert classes.
#' @field Lambda Penalty value for the expert part.
#' @field Gamma Penalty value for the gating network.
#' @field wk Parameters of the gating network. Matrix of dimension \eqn{(K - 1,
#'   d)}, with `d` the number of explanatory variables (including the
#'   intercept).
#' @field eta Values of the regression coefficients for each level r = 1,...,R.
#'   Array of dimension \eqn{(K, R-1, d)}.
#' @field loglik Numeric. Observed-data log-likelihood of the LRMoE model.
#' @field storedloglik Numeric vector. Stored values of the log-likelihood at
#'   each EM iteration.
#' @field BIC Numeric. Value of BIC (Bayesian Information Criterion).
#' @field Cluster Numeric vector. Clustering label for each observation.
LRMoE <- setRefClass(
  "LRMoE",
  fields = list(

    X = "matrix",
    Y = "numeric",

    d = "numeric",
    n = "numeric",

    R = "numeric",
    K = "numeric",
    Lambda = "numeric",
    Gamma = "numeric",

    wk = "matrix",
    eta = "array",

    loglik = "numeric",
    storedloglik = "numeric",
    BIC = "numeric",

    Cluster = "numeric"
  ),
  methods = list(
    initialize = function(X = matrix(), Y = numeric(1), K = 1, Lambda = 0, Gamma = 0,
                          wk = matrix(), eta = matrix(), loglik = -Inf,
                          storedloglik = numeric(), BIC = -Inf, Cluster = numeric()) {

      X <<- X
      Y <<- Y

      d <<- dim(X)[2] # dim of X: d = p+1
      n <<- dim(X)[1]

      K <<- K
      R <<- max(Y)
      Lambda <<- Lambda
      Gamma <<- Gamma

      wk <<- wk
      eta <<- eta

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
