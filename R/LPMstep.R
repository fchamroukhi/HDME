#M-step parallel
Lpm.step = function(X, Y, U, R, eta, tau, lambda, cl, option)
{
  # if (option==1) source("LCoorExpP1.R")
  # else source("LCoorExpP.R")
  K = ncol(tau)
  # for(k in 1:K) eta[k,,] = CoorExpP(X, Y, U, R, eta, tau, lambda, k)
  #======For parallel

  ###
  # parallel::clusterExport(cl, list("LCoorExpP", "X", "Y", "U", "R", "eta", "lambda", "tau"))
  ###

  Seta = parallel::parLapply(cl, 1:K, function(k) LCoorExpP(X, Y, U, R, eta, tau, lambda, k)) #rho = 0
  #print(Seta)
  for(k in 1:K) eta[k,,] = Seta[[k]]
  return (eta)
}
