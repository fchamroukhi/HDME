#M-step parallel
Gpm.step = function(tau, X, Y, d, K, S, lambda, betak, cl)
{
  # source("CoorLQk.R")
  #n = dim(X)[1]
  #Update Pik
  pik = colSums(tau,1)/n
  clusterExport(cl, list("CoorLQk", "X", "Y", "S", "lambda", "betak"))
  betak = unlist(parLapply(cl, 1:K, function(k) CoorLQk(X, Y, tau[,k], betak[,k], S*lambda[k], 0))) #rho = 0
  betak = matrix(betak, ncol=K)
  #para = list(pik,betak)
  #return (para)
  return (betak)
}
