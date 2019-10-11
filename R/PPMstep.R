#M-step parallel
Ppm.step = function(tau, X, Y, K, lambda, betak, cl)
{
  source("PCoorExpP.R")
  #n = dim(X)[1]
  #Update Pik
  #pik = colSums(tau,1)/n
  # for(k in 1:K) betak[,k] = CoorExpP(X, Y, betak, tau, lambda, k)
   clusterExport(cl, list("PCoorExpP", "X", "Y", "betak", "tau", "lambda"))
   Betak = parLapply(cl, 1:K, function(k) PCoorExpP(X, Y, betak, tau, lambda, k)) #rho = 0
  # betak = matrix(betak, ncol=K)
  for(k in 1:K) betak[,k] = Betak[[k]]
  #para = list(pik,betak)
  return (betak)
}
