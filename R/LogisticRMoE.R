#' Penalized MLE for the logistic regularized Mixture of Experts.
#'
#' This function provides a penalized MLE for the logistic regularized Mixture
#' of Experts (MoE) model corresponding with the penalty parameters Lambda,
#' Gamma.
#'
#' @param Xmat The matrix data for the input.
#' @param Ymat Vector of the response variable.
#' @param K Number of expert classes.
#' @param Lambda Penalty value for the expert part.
#' @param Gamma Penalty value for the gating network.
#' @param option Optional. `option = TRUE`: using proximal Newton-type method;
#'   `option = FALSE`: using proximal Newton method.
#' @param verbose Optional. A logical value indicating whether or not values of
#'   the log-likelihood should be printed during EM iterations.
#' @return LogisticRMoE returns an object of class [LRMoE][LRMoE].
#' @seealso [LRMoE]
#' @export
LogisticRMoE = function(Xmat, Ymat, K, Lambda, Gamma, option = FALSE, verbose = FALSE)
{
# option = 1: proximal Newton-type, 0: proximal Newton
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
#==============================
X <- Xmat
Y <- Ymat
n <- dim(X)[1]
d <- dim(X)[2]
R <- max(Y)
#===============================
lambda <- matrix(rep(Lambda,(R-1)*K), ncol=(R-1))
gamma = c(rep(Gamma,K-1))
rho = 0
U <- matrix(rep(0,n*R), ncol=R)
for (i in 1:n) U[i,Y[i]] = 1
#MAXLOG = -10^6
#===================
pik = c(rep(0, K))
Nstep = 1000
arr = c(rep(0, Nstep))
ZMat = matrix(rep(0, Nstep*K), ncol=K)
eps = 1e-4
wk = matrix(rep(0,(K-1)*d), ncol = d)
eta <- array(0, dim = c(K,R-1,d))
#Generated eta
for (k in 1:K)
{
  for(r in 1:(R-1))
  {
    eta[k,r,] = stats::runif(d,-6,6)
  }
}
#------------------------
# source("LEstep.R")
# source("LPMstep.R") #Programing in parallel
# source("LLOG.R")
# #source("ZeroCoeff.R")
# if(option==1) source("CoorGateP1.R")
# else source("CoorGateP.R")
# source("LBIC.R")
# #source("Plot.R")
# source("LWrite.R")
#----------------------
tau <- matrix(rep(0,n*K), ncol=K)
L2 = LLOG(X, Y, wk, eta, lambda, gamma, rho)
step = 1
arr[step] = L2

###
# print(paste("Step:", step))
# print("Eta:")
# for(k in 1:K) print(eta[k,,])
# print("wk: ")
# print(wk)
# print(paste("LOG: ", L2))

if (verbose) {
  message("EM - LRMoE: Iteration: ", step, " | log-likelihood: "  , L2)
}
###

BEGIN = Sys.time()
repeat
{
  step =step+1
  L1 = L2
  #---------E-step
  tau = Le.step(eta, wk, Y, X, K, R)
  #---------M-step

  ###
  # wk = CoorGateP(X, wk, tau, gamma, rho)

  if (option) {
    wk = CoorGateP1(X, wk, tau, gamma, rho)
  } else {
    wk = CoorGateP(X, wk, tau, gamma, rho)
  }
  ###

  eta = Lpm.step(X, Y, U, R, eta, tau, lambda, cl, option)
  L2 = LLOG(X, Y, wk, eta, lambda, gamma, rho)
  #ZeroCoeff(betak, d, K, step, ZMat)
  arr[step] = L2

  ###
  # print(paste("Step:", step))
  # print("Beta:")
  # for(k in 1:K) print(eta[k,,])
  # print("wk: ")
  # print(wk)
  # print(paste("LOG: ", L2))

  if (verbose) {
    message("EM - LRMoE: Iteration: ", step, " | log-likelihood: "  , L2)
  }
  ###

  if((L2-L1) < eps) break
}

###
# print(paste("Number of steps: ", step))
# print(paste("Step:", step))
# print("Eta:")
# for(k in 1:K) print(eta[k,,])
# print("wk: ")
# print(wk)
# print(paste("LOG value: ", L2))
###

BIC = LBIC(X, Y, wk, eta)

###
# print(paste("BIC value: ", BIC))
###

Step = seq.int(1, step)
Arr = c(rep(0, step))
for(i in 1:step)
{
  Arr[i]=arr[i]
}

###
# print(Arr)
###

END = Sys.time()
time = END - BEGIN

###
# print(paste("Time: ", time))
###

#if(L2 > MAXLOG)
{
  MAXeta <- eta
  MAXwk <- wk
  MAXLOG <- L2
  MAXBIC <- BIC
}
#===============Plot Zero Coefficient============ Need to FIX
# U = t(ZMat)
# U = t(U[,c(1:step)])
# matplot(U, type = c("o"), pch=19, col=1:K, xlab = 'Step', ylab = 'Number of Zero Coefficients')
#===========The BIC value
#BIC = BIC(X, Y, wk, betak, S)
#print(paste("BIC: ", BIC))
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
# LWRITERES(MAXeta, MAXwk, MAXLOG, MAXBIC, Y, X, K, R, n)
###

model <- LRMoE(X = X, Y = Y, K = K, Lambda = Lambda, Gamma = Gamma,
              wk = wk, eta = eta, loglik = L2,
              storedloglik = Arr, BIC = BIC)

return(model)

}
