#E-step
Le.step = function(eta, wk, Y, X, K, R)
{
  source("Pik.R")
  source("LPi.R")
  n = dim(X)[1]
  tau = matrix(rep(0,n*K), ncol=K)
  pik = Pik(n, K, X, wk)
  for (i in 1:n)
  { Sum = 0
    for(k in 1:K)
    { #be careful for case R > 2
      ETAk = as.matrix(eta[k,,])
      if(R==2) ETAk = t(ETAk)
      P_eta = Pi(R,X[i,],ETAk)
      # P_eta = Pi(R,X[i,],t(as.matrix(eta[k,,])))
      tau[i,k] = pik[i,k]*P_eta[Y[i]]
      #print(tau[i,k])
      Sum = Sum + tau[i,k]
    }
  tau[i,] = tau[i,]/Sum
  }
  return (tau)
}
