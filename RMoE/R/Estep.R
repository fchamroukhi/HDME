#E-step
e.step = function(betak, wk, S, Y, X, K)
{
  source("Pik.R")
  pikfk = matrix(rep(0,n*K), ncol=K)

  pik = Pik(n, K, X, wk)
    for(k in 1:K)
    {
      mu = X%*%as.matrix(betak[,k])
      pikfk[,k] = pik[,k]*dnorm(Y,mu,sqrt(S))
    }
  fMoE = matrix(rep(rowSums(pikfk), K), ncol=K)
  tau = pikfk/fMoE#(rowSums(pikfk)%*%(ones(n, 1) %*% (1:K)))
  #
  return (tau)
}
