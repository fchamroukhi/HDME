#BIC  function
BIC = function(X, Y, wk, betak, S)
{
  source("Pik.R")
  p = dim(X)[2]-1
  #n = dim(X)[1]
  pik = Pik(n, K, X, wk)
  beta = as.matrix(betak[-1,]) #remove first row of betak
  if(p==1) beta = t(beta)
  w = wk[,-1] #remove first column of wk
  DF = 0
  for(k in 1:K)
  {
    for (j in 1:p)
        if(beta[j,k]!= 0) DF = DF+1
  }
  if(K==2) w = t(as.matrix(w))
  for(k in 1:(K-1))
  {
    for (j in 1:p)
      if(w[k,j]!= 0) DF = DF+1
  }
  d = dim(X)[2]
  S0 = 0
  n = dim(X)[1]
  for(i in 1:n)
  {
    S1 = 0
    for(k in 1:K)
    {
      S1 = S1+pik[i,k]*dnorm(Y[i],X[i,]%*%as.matrix(betak[,k]),sqrt(S))
    }
    S1 = log(S1)
    S0 = S0+S1
  }
  S0 = S0 - log(n)*DF/2
  return (S0)
}
