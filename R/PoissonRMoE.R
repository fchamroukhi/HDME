#' Penalized MLE for the Poisson regularized Mixture of Experts.
#'
#' This function provides a penalized MLE for the Poisson regularized Mixture
#' of Experts (MoE) model corresponding with the penalty parameters Lambda,
#' Gamma.
#'
#' @param Xmat Matrix of explanatory variables. Each feature should be
#'   standardized to have mean 0 and variance 1. One must add the column vector
#'   (1,1,...,1) for the intercept variable.
#' @param Ymat Vector of the response variable. For the Gaussian case Y should
#'   be standardized. For multi-logistic model Y is numbered from 1 to R (R is
#'   the number of labels of Y).
#' @param K Number of experts (K > 1).
#' @param Lambda Penalty value for the experts.
#' @param Gamma Penalty value for the gating network.
#' @param option Optional. `option = TRUE`: using proximal Newton-type method;
#'   `option = FALSE`: using proximal Newton method.
#' @param verbose Optional. A logical value indicating whether or not values of
#'   the log-likelihood should be printed during EM iterations.
#' @return PoissonRMoE returns an object of class [PRMoE][PRMoE].
#' @seealso [PRMoE]
#' @export
PoissonRMoE = function(Xmat, Ymat, K, Lambda, Gamma, option = FALSE, verbose = TRUE)
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
#===============================
X <-Xmat
Y<-Ymat
n <- dim(X)[1]
d <- dim(X)[2]
#MAXLOG = -10^6
#rho = 0.1*log(n)
#================Penalty parameters for bike (20-2)
lambda <- c(rep(Lambda,K))
gamma = c(rep(Gamma,K-1))
rho = 0
#===================
N = 1
LOGarr = c(rep(0, N))
for(runstep in 1:N)
{
  Nstep = 500
  arr = c(rep(0, Nstep))
  # ZMat <- matrix(rep(0, Nstep*K), ncol=K)
  eps = 1e-5
  d = dim(X)[2] #dim of X: d = p+1
  wk = matrix(rep(0,(K-1)*d), ncol = d)
  betak <- matrix(rep(0,K*d), ncol = K)
  tau <- matrix(rep(0,n*K), ncol=K)

  ###
  zerocoeff <- matrix(ncol = 2, dimnames = list(NULL, c("wk", "betak")))
  ###

#===========Generated Beta for the experts
  # source("PInitial.R")
  # #for(k in 1:K)  betak[,k] = stats::runif(d,-2,2)
  # #------------------------
  # source("PEstep.R")
  # source("PPMstep.R") #Programing in parallel
  # source("PLOG.R")
  # #source("NPLOG.R")
  # #source("ZeroCoeff.R")
  # if(option) source("CoorGateP1.R")
  # else source("CoorGateP.R")
  # source("PBIC.R")
  # #source("Plot.R")
  # source("PWrite.R")
  #----------------------

  repeat{
  betak = Initial(X, Y, d, K)
  L2 = PLOG(X, Y, wk, betak, lambda, gamma, rho)
  if (L2 > -Inf) break
# else print("INFINITY")
  }
  step = 1
  arr[step] = L2

  ###
  zerocoeff[step, 1] <- sum(wk == 0) / length(wk)
  zerocoeff[step, 2] <- sum(betak == 0) / length(betak)
  ###

  ###
  # print(paste("Step:", step))
  # print("betak:")
  # print(betak)
  # print("wk: ")
  # print(wk)
  # print(paste("LOG: ", L2))

  if (verbose) {
    message("EM - PRMoE: Iteration: ", step, " | log-likelihood: "  , round(x = L2, digits = 2))
  }
  ###

  repeat
  {
    step =step+1
    L1 = L2
    #----------E-step
    tau = Pe.step(betak, wk, Y, X, K)
    #----------M-step

    ###
    # wk = CoorGateP(X, wk, tau, gamma, rho)

    if (option) {
      wk = CoorGateP1(X, wk, tau, gamma, rho)
    } else {
      wk = CoorGateP(X, wk, tau, gamma, rho)
    }
    ###

    betak = Ppm.step(tau, X, Y, K, lambda, betak, cl)
    L2 = PLOG(X, Y, wk, betak, lambda, gamma, rho)
    #ZeroCoeff(betak, d, K, step, ZMat)
    arr[step] = L2

    ###
    zerocoeff <- rbind(zerocoeff, c(sum(wk == 0) / length(wk), sum(betak == 0) / length(betak)))
    ###

    ###
    # print(paste("Step:", step))
    # print("betak:")
    # print(betak)
    # print("wk: ")
    # print(wk)
    # print(paste("LOG: ", L2))

    if (verbose) {
      message("EM - PRMoE: Iteration: ", step, " | log-likelihood: "  , L2)
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
  # print(paste("LOG value: ", L2))
  ###

  BIC = PBIC(X, Y, wk, betak)

  ###
  # print(paste("BIC: ", BIC))
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

  #===============Plot Zero Coefficient============
  #U = t(ZMat)
  #U = t(U[,c(1:step)])
  #matplot(U, type = c("o"), pch=19, col=1:K, xlab = 'Step', ylab = 'Number of Zero Coefficients')
  #==========Update MAX===============
  #if(L2 > MAXLOG)
  {
    MAXbetak <- betak
    MAXwk <- wk
    MAXLOG <- L2
    MAXBIC <-BIC
  }
  LOGarr[runstep] = L2
}
# print(paste("MAXbetak: "))
# print(MAXbetak)
# print("MAXwk: ")
# print(MAXwk)
# print(paste("MAXLOG value: ", L2))
# print("LOG array:")
# print(LOGarr)
# #===========NP Log
# NPlog = NPLOG(X, Y, MAXwk, MAXbetak)
# print(paste("MAX NPLOG: ", NPlog))
#==============Plot Log-likelihood value========

###
# graphics::matplot(Step, Arr, col = "blue",type="o",pch=19,xlab = 'Step', ylab = 'Log-likelihood')
###

on.exit(parallel::stopCluster(cl))

###
# PWRITERES(MAXbetak, MAXwk, MAXLOG, MAXBIC, Y, X, K)
###

tau <- Pe.step(betak, wk, Y, X, K)
cluster <- apply(tau, 1, which.max)

model <- PRMoE(X = X, Y = Y, K = K, Lambda = Lambda, Gamma = Gamma, wk = wk,
               betak = betak, loglik = L2, storedloglik = Arr, BIC = BIC,
               zerocoeff = zerocoeff, Cluster = cluster)
}
