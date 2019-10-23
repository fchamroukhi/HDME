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
#' @field zerocoeff Matrix. Proportion of zero coefficients obtained during each
#'   iteration of the EM. First column gives the number of zero coefficients for
#'   `wk` and the second column for `eta`.
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

    zerocoeff = "matrix",

    Cluster = "numeric"
  ),
  methods = list(
    initialize = function(X = matrix(), Y = numeric(1), K = 1, Lambda = 0, Gamma = 0,
                          wk = matrix(), eta = matrix(), loglik = -Inf,
                          storedloglik = numeric(), BIC = -Inf, zerocoeff = matrix(),
                          Cluster = numeric()) {

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

      zerocoeff <<- zerocoeff

      Cluster <<- Cluster

    },

    plot = function(what = c("loglik", "zerocoefficients")) {
      "Plot method.
      \\describe{
        \\item{\\code{what}}{The type of graph requested:
          \\itemize{
            \\item \\code{\"loglik\" = } Value of the log-likelihood for
              each iteration.
            \\item \\code{\"zerocoefficients\" = } Proportion of zero
              coefficients for each iteration.
          }
        }
      }
      By default, all the above graphs are produced."

      what <- match.arg(what, several.ok = TRUE)

      oldpar <- par(no.readonly = TRUE)
      on.exit(par(oldpar), add = TRUE)

      if (any(what == "loglik")) {
        graphics::plot(1:length(storedloglik), storedloglik, col = "blue", type = "o", pch = 19, xlab = 'Step', ylab = 'Log-likelihood')
      }

      if (any(what == "zerocoefficients")) {
        graphics::matplot(1:nrow(zerocoeff), zerocoeff, type = "l", col = 1:ncol(zerocoeff), xlab = "Step", ylab = "Proportion", ylim = c(0, 1))
        legend("topright", legend = colnames(zerocoeff), col = 1:ncol(zerocoeff), lty = 1, cex = 0.9)
        title(main = "Proportion of zero coefficients over EM iterations")
      }

    }
  )
)
