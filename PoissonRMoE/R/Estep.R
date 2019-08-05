#E-step
e.step = function(betak, wk, Y, X, K)
{
  source("Pik.R")
  pikFk = matrix(rep(0,n*K), ncol=K)
  #n = dim(X)[1]
  pik = Pik(n, K, X, wk)
    for(k in 1:K)
    {
      mu = X%*%as.matrix(betak[,k])
      Lam = exp(mu)
      pikFk[,k] = pik[,k]*dpois(Y,Lam)
    }
  fMoE = matrix(rep(rowSums(pikFk), K), ncol=K)
  tau = pikFk/fMoE
  return (tau)
}
