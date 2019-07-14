RMoE = function(X, Y, K, Lambda, Gamma, option)
{
library(plot3D)
library(stats)
library(graphics)
library(MASS)
library(base)
library(doParallel)
library(foreach)  
#setDefaultCluster(makePSOCKcluster(K)) 
#=========Parallel==============
cl = makeCluster(K)
registerDoParallel(cl)
getDoParWorkers()
MAXLOG = -10^6
#================Penalty parameters for Housing Data
# lambda = c(rep(42,K))
# gamma = c(rep(10,K-1))
#================Penalty parameters for RB Data and BB Data
lambda <<- c(rep(Lambda,K))
gamma = c(rep(Gamma,K-1))
#rho = 0.1*log(n)
rho = 0
#===================
pik = c(rep(0, K))
Nstep = 5000
arr = c(rep(0, Nstep))
ZMat <<- matrix(rep(0, Nstep*K), ncol=K)
eps = 1e-5
d = dim(X)[2] #dim of X: d = p+1
n <<- dim(X)[1]
S <<- runif(1, min = 5, max = 20) #variance
wk = matrix(rep(0,(K-1)*d), ncol = d)
betak <<- matrix(rep(0, d*K), ncol = K)
#Generated Beta
for (k in 1:K)
{
  betak[,k] = runif(d,-5,5)
}
#------------------------
source("Estep.R")
source("PMstep.R") #Programing in parallel
source("SMstep.R")
source("LOG.R")
source("ZeroCoeff.R")
source("BIC.R")
#source("Plot.R")
source("Write.R")
#-------Choose the method
if(option) source("CoorGateP1.R")
else source("CoorGateP.R")
#----------------------
tau = matrix(rep(0,n*K), ncol=K) 
L2 = LOG(X, Y, wk, betak, S, lambda, gamma, rho)
step = 1
arr[step] = L2
print(paste("Step:", step))
print("betak:")
print(betak)
print("wk: ")
print(wk)
print(paste("S: ", S))
print(paste("LOG: ", L2))
repeat
{
  step =step+1
  L1 = L2
  tau = e.step(betak, wk, S, Y, X, K)
  # para = pm.step(tau, X, Y, d, K, S, lambda, betak)
  # pik = do.call(rbind,para[1])
  # betak = do.call(rbind,para[2])
  betak = pm.step(tau, X, Y, d, K, S, lambda, betak, cl)
  wk = CoorGateP(X, wk, tau, gamma, rho)
  tau = e.step(betak, wk, S, Y, X, K)
  S = sm.step(tau, X, Y, K, betak)
  L2 = LOG(X, Y, wk, betak, S, lambda, gamma, rho)
  ZeroCoeff(betak, d, K, step, ZMat)
  arr[step] = L2
  print(paste("Step:", step))
  print("betak:")
  print(betak)
  print("wk: ")
  print(wk)
  print(paste("S: ", S))
  print(paste("LOG: ", L2))
  if((L2-L1)/abs(L1) < eps) break
}
print(paste("Number of steps: ", step))
print(paste("betak: "))
print(betak)
print("wk: ")
print(wk)
print(paste("S: ", S))
print(paste("LOG value: ", L2))
Step = seq.int(1, step)
Arr = c(rep(0, step))
for(i in 1:step)
{
  Arr[i]=arr[i]
}
print(Arr)
if(L2 > MAXLOG)
{
  MAXbetak <<- betak
  MAXS <<- S
  MAXwk <<- wk
  MAXLOG <<- L2
}
#===============Plot Zero Coefficient============
U = t(ZMat)
U = t(U[,c(1:step)])
matplot(U, type = c("o"), pch=19, col=1:K, xlab = 'Step', ylab = 'Number of Zero Coefficients')
#===========The BIC value
BIC = BIC(X, Y, wk, betak, S)
print(paste("BIC: ", BIC))
#==============Plot Log-likelihood value========
matplot(Step, Arr, col = "blue",type="o",pch=19,xlab = 'Step', ylab = 'Log-likelihood')
on.exit(stopCluster(cl))
#==============Plot histogram of Y================
# hist(Y, breaks = 15, main="Histogram for MEDV/sd(MEDV)",
#      xlab="MEDV/sd(MEDV)", ylab = "Density",
#      border="black",col="green",prob=TRUE)
# lines(density(Y))
WRITERES()
return()
}