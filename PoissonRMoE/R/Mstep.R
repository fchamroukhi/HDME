#M-step
m.step = function(tau, X, Y, d, K, S, lambda)
{
  source("CooDes1.R")
  n = dim(X)[1]
  #Update Pik
  pik = colSums(tau,1)/n
  betak = matrix(rep(0, K*d), ncol = K)
  for(k in 1:K)
  {#update betak using coordinate descent
    betak[,k] = CooDes1(tau[,k], X, Y, S*lambda[k], betak[,k])
  }
    para = list(pik, betak)
    return (para)
}