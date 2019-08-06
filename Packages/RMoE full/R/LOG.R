#Log likelihood
LOG = function(X, Y, wk, betak, S, lambda, gamma, rho)
{ 
  source("Pik.R")
  #Do for dim X > 2 to tranlate beta into matrix
  pik = Pik(n, K, X, wk)
  beta = abs(betak[-1,])
  wPen = abs(wk[,-1]) #remove first column of wk
  d = dim(X)[2]
  if(d==2)
  {
    beta = as.matrix(t(beta))
  }
  if(K==2)
  {
    wPen = as.matrix(t(wPen))
  }
  Pen = sum(lambda*colSums(beta))
  Pen1 = sum(gamma*rowSums(wPen))
  Pen2 = sum(wPen^2)*rho/2
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
  S0 = S0 - Pen - Pen1 - Pen2
  return (S0)
}