#M-step parallel
pm.step = function(X, Y, U, R, eta, tau, lambda, cl, option)
{
  if (option==1) source("CoorExpP1.R")
  else source("CoorExpP.R")
  # for(k in 1:K) eta[k,,] = CoorExpP(X, Y, U, R, eta, tau, lambda, k)
  #======For parallel
  clusterExport(cl, list("CoorExpP", "X", "Y", "U", "R", "eta", "lambda", "tau"))
  Seta = parLapply(cl, 1:K, function(k) CoorExpP(X, Y, U, R, eta, tau, lambda, k)) #rho = 0
  #print(Seta)
  for(k in 1:K) eta[k,,] = Seta[[k]]
  return (eta)
}