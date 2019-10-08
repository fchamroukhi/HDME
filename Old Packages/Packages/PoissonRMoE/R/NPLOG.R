#Log likelihood
NPLOG = function(X, Y, wk, betak)
{ 
  source("Pik.R")
  #Do for dim X > 2 to tranlate beta into matrix
  pik = Pik(n, K, X, wk)
  S0 = 0
  n = dim(X)[1]
  # for(i in 1:n)
  # {
  #   S1 = 0
  #   for(k in 1:K)
  #   {
  #     Lambda = exp(X[i,]%*%as.matrix(betak[,k]))
  #     #print(Lambda)
  #     S1 = S1+pik[i,k]*dpois(Y[i], Lambda)
  #   }
  #   print(S1)
  #   S1 = log(S1)
  #   S0 = S0+S1
  # }
  Lam = exp(X%*%betak)
  tau = pik*dpois(Y, Lam)
  S = log(rowSums(tau))
  S0 = sum(S)
  return (S0)
}