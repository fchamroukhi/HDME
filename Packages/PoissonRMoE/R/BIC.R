#BIC  function
BIC = function(X, Y, wk, betak)
{
  source("Pik.R")
  # d = dim(X)[2]
  # n = dim(X)[1]
  p = d-1
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
  S0 = 0
  for(i in 1:n)
  {
    S1 = 0
    for(k in 1:K)
    {
      Lambda = exp(X[i,]%*%as.matrix(betak[,k]))
      #print(Lambda)
      S1 = S1+pik[i,k]*dpois(Y[i], Lambda)
    }
    S1 = log(S1)
    S0 = S0+S1
  }
  S0 = S0 - log(n)*DF/2
  return (S0)
}
