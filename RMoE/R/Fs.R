Fs = function(X, tau, gamma, rho, wk)
{# Q(pi;.) function in M-step
  source("Pik.R")
  #n = dim(X)[1]
  #d = dim(X)[2]
  PI = matrix(rep(0, n*K), ncol=K)
  PI = Pik(n, K, X, wk)
  logPi = log(PI)
  W = as.matrix(wk[,c(2:d)])#remove w[k,1] and set it as matrix in case d = 2
  W1 = abs(W)
  W2 = W^2
  L1 = rowSums(W1)
  S1 = sum(gamma*L1)
  S2 = sum(W2)*rho/2
  S = sum(tau*logPi) - S1 - S2
  return(S)
}
