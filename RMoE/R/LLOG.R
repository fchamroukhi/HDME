#Log likelihood
LLOG = function(X, Y, wk, eta, lambda, gamma, rho)
{
  source("Pik.R")
  source("LPi.R")
  #Do for dim X > 2 to tranlate beta into matrix
  pik = Pik(n, K, X, wk)
  wPen = abs(wk[,-1]) #remove first column of wk
  #d = dim(X)[2]
  if(K==2)
  {
    wPen = as.matrix(t(wPen))
  }

  Pen = 0
  for(k in 1:K)
  {
    ETAk = as.matrix(eta[k,,])
    if(R==2) ETAk = t(ETAk)
    ETAk = abs(ETAk[,-1]) #remove first column
    Value = lambda[k,]*ETAk
    Pen = Pen + sum(Value)
  }
  Pen1 = sum(gamma*rowSums(wPen))
  Pen2 = sum(wPen^2)*rho/2
  S0 = 0
  n = dim(X)[1]
  for(i in 1:n)
  {
    S1 = 0
    for(k in 1:K)
    {
      ETAk = as.matrix(eta[k,,])
      if(R==2) ETAk = t(ETAk)
      P_eta = Pi(R,X[i,],ETAk)
      # P_eta = Pi(R,X[i,],t(as.matrix(eta[k,,])))
      S1 = S1+pik[i,k]*P_eta[Y[i]]
    }
    S1 = log(S1)
    S0 = S0+S1
  }
  S0 = S0 - Pen - Pen1 - Pen2
  return (S0)
}
