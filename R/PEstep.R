#E-step
Pe.step = function(betak, wk, Y, X, K)
{
  # source("Pik.R")
  n = dim(X)[1]
  tau = matrix(rep(0,n*K), ncol=K)
  pik = Pik(n, K, X, wk)
#----------------OLD E-step
  # for (i in 1:n)
  # { Sum = 0
  #   for(k in 1:K)
  #   {
  #     mu = X[i,]%*%as.matrix(betak[,k])
  #     Lam = exp(mu)
  #     tau[i,k] = pik[i,k]*stats::dpois(Y[i],Lam)
  #     #print(tau[i,k])
  #     Sum = Sum + tau[i,k]
  #   }
  # tau[i,] = tau[i,]/Sum
  # }
#---------------NEW E-step
  Lam = exp(X%*%betak)
  tau = pik*stats::dpois(Y, Lam)
  Sum = rowSums(tau)
  tau = tau/Sum

  return (tau)
}
