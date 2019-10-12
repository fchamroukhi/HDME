#E-step
Ge.step = function(betak, wk, S, Y, X, K)
{
  # source("Pik.R")
  n = dim(X)[1]
  tau = matrix(rep(0,n*K), ncol=K)
  pik = Pik(n, K, X, wk)
  #--------------OLD E-Step
  # for (i in 1:n)
  # { Sum = 0
  #   for(k in 1:K)
  #   {
  #     mu = X[i,]%*%as.matrix(betak[,k])
  #     #ERROR: Too big Mean
  #     #print(paste("Mu: ", mu))
  #     tau[i,k] = pik[i,k]*stats::dnorm(Y[i],mu,sqrt(S))
  #     #print(tau[i,k])
  #     Sum = Sum + tau[i,k]
  #   }
  # tau[i,] = tau[i,]/Sum
  #}
  #--------------NEW E-Step
  mu = X%*%betak
  tau = pik*stats::dnorm(Y, mu, sqrt(S))
  Sum = rowSums(tau)
  tau = tau/Sum
  return (tau)
}
