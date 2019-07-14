#E-step
e.step = function(betak, wk, Y, X, K)
{
  source("Pik.R")
  tau = matrix(rep(0,n*K), ncol=K) 
  #n = dim(X)[1]
  pik = Pik(n, K, X, wk)
  for (i in 1:n)
  { Sum = 0
    for(k in 1:K)
    {
      mu = X[i,]%*%as.matrix(betak[,k])
      Lam = exp(mu)
      tau[i,k] = pik[i,k]*dpois(Y[i],Lam)
      #print(tau[i,k])
      Sum = Sum + tau[i,k]
    }
  tau[i,] = tau[i,]/Sum
  }
  return (tau)
}
