#' Penalized MLE for the regularized Mixture of Experts.
#'
#' This function provides a penalized MLE for the regularized Mixture of Experts
#' (MoE) model corresponding with the penalty parameters Lambda, Gamma.
#'
#' @param Xm Matrix of explanatory variables. Each feature should be
#'   standardized to have mean 0 and variance 1. One must add the column vector
#'   (1,1,...,1) for the intercept variable.
#' @param Ym Vector of the response variable. For the Gaussian case Y should
#'   be standardized. For multi-logistic model Y is numbered from 1 to R (R is
#'   the number of labels of Y).
#' @param K Number of experts (K > 1).
#' @param Lambda Penalty value for the experts.
#' @param Gamma Penalty value for the gating network.
#' @param option Optional. `option = TRUE`: using proximal Newton-type method;
#'   `option = FALSE`: using proximal Newton method.
#' @param verbose Optional. A logical value indicating whether or not values of
#'   the log-likelihood should be printed during EM iterations.
#' @return GaussRMoE returns an object of class [GRMoE][GRMoE].
#' @seealso [GRMoE]
#' @export
GaussRMoE = function(Xm, Ym, K, Lambda, Gamma, option = FALSE, verbose = FALSE)
{
# library(plot3D)
# library(stats)
# library(graphics)
# library(MASS)
# library(base)
# library(doParallel)
# library(foreach)
#setDefaultCluster(makePSOCKcluster(K))
#=========Parallel==============
cl = parallel::makeCluster(K)
doParallel::registerDoParallel(cl)
foreach::getDoParWorkers()
#MAXLOG = -10^6
X <- Xm
Y <- Ym
#================Penalty parameters for Housing Data
# lambda = c(rep(42,K))
# gamma = c(rep(10,K-1))
#================Penalty parameters for RB Data and BB Data
lambda <- c(rep(Lambda,K))
gamma = c(rep(Gamma,K-1))
#rho = 0.1*log(n)
rho = 0
#===================
pik = c(rep(0, K))
Nstep = 5000
arr = c(rep(0, Nstep))
ZMat <- matrix(rep(0, Nstep*K), ncol=K)
eps = 1e-5
d <- dim(X)[2] #dim of X: d = p+1
n <- dim(X)[1]
S <- stats::runif(1, min = 5, max = 20) #variance
wk = matrix(rep(0,(K-1)*d), ncol = d)
betak <- matrix(rep(0, d*K), ncol = K)
#Generated Beta
for (k in 1:K)
{
  betak[,k] = stats::runif(d,-5,5)
}
#------------------------
# source("GEstep.R")
# source("GPMstep.R") #Programing in parallel
# source("GSMstep.R")
# source("GLOG.R")
# #source("ZeroCoeff.R")
# source("GBIC.R")
# #source("Plot.R")
# source("GWrite.R")
# #-------Choose the method
# if(option) source("CoorGateP1.R")
# else source("CoorGateP.R")
#----------------------
tau = matrix(rep(0,n*K), ncol=K)
L2 = GLOG(X, Y, wk, betak, S, lambda, gamma, 0)
step = 1
arr[step] = L2

###
# print(paste("Step:", step))
# print("betak:")
# print(betak)
# print("wk: ")
# print(wk)
# print(paste("Sigma: ", sqrt(S)))
# print(paste("LOG: ", L2))

if (verbose) {
  message("EM - GRMoE: Iteration: ", step, " | log-likelihood: "  , round(x = L2, digits = 2))
}
###

repeat
{
  step =step+1
  L1 = L2
  tau = Ge.step(betak, wk, S, Y, X, K)
  # para = pm.step(tau, X, Y, d, K, S, lambda, betak)
  # pik = do.call(rbind,para[1])
  # betak = do.call(rbind,para[2])
  betak = Gpm.step(tau, X, Y, d, K, S, lambda, betak, cl)

  ###
  # wk = CoorGateP(X, wk, tau, gamma, 0)

  if (option) {
    wk = CoorGateP1(X, wk, tau, gamma, rho)
  } else {
    wk = CoorGateP(X, wk, tau, gamma, rho)
  }
  ###

  tau = Ge.step(betak, wk, S, Y, X, K)
  S = sm.step(tau, X, Y, K, betak)
  L2 = GLOG(X, Y, wk, betak, S, lambda, gamma, 0)
  #ZeroCoeff(betak, d, K, step, ZMat)
  arr[step] = L2

  ###
  # print(paste("Step:", step))
  # print("betak:")
  # print(betak)
  # print("wk: ")
  # print(wk)
  # print(paste("Sigma: ", sqrt(S)))
  # print(paste("LOG: ", L2))

  if (verbose) {
    message("EM - GRMoE: Iteration: ", step, " | log-likelihood: "  , L2)
  }
  ###

  if((L2-L1)/abs(L1) < eps) break
}

###
# print(paste("Number of steps: ", step))
# print(paste("betak: "))
# print(betak)
# print("wk: ")
# print(wk)
# print(paste("Sigma: ", sqrt(S)))
# print(paste("LOG value: ", L2))
###

Step = seq.int(1, step)
Arr = c(rep(0, step))
#===========The BIC value
BIC = GBIC(X, Y, wk, betak, S)

###
# print(paste("BIC: ", BIC))
###

for(i in 1:step)
{
  Arr[i]=arr[i]
}

###
# print(Arr)
###

#if(L2 > MAXLOG)
{
  MAXbetak <- betak
  MAXS <- S
  MAXwk <- wk
  MAXLOG <- L2
  MAXBIC <-BIC
}
#===============Plot Zero Coefficient============
# U = t(ZMat)
# U = t(U[,c(1:step)])
# graphics::matplot(U, type = c("o"), pch=19, col=1:K, xlab = 'Step', ylab = 'Number of Zero Coefficients')
#==============Plot Log-likelihood value========

###
# graphics::matplot(Step, Arr, col = "blue",type="o",pch=19,xlab = 'Step', ylab = 'Log-likelihood')
###

on.exit(parallel::stopCluster(cl))
#==============Plot histogram of Y================
# hist(Y, breaks = 15, main="Histogram for MEDV/sd(MEDV)",
#      xlab="MEDV/sd(MEDV)", ylab = "Density",
#      border="black",col="green",prob=TRUE)
# lines(density(Y))

###
# GWRITERES(MAXbetak, MAXwk, MAXS, MAXLOG, MAXBIC, Y, X, K)
###

model <- GRMoE(X = X, Y = Y, K = K, Lambda = Lambda, Gamma = Gamma,
                      wk = wk, betak = betak, sigma = S, loglik = L2,
                      storedloglik = Arr, BIC = BIC)

return(model)

}
