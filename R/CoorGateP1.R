CoorGateP1 = function(X, wk, tau, Gamma, rho)
{ #using proximal Newton-type
  # source("Fs.R")
  # source("CoorLQk.R")
  # source("Pik.R")
  n = dim(X)[1]
  K = ncol(tau)
  P_k = c(rep(0,n))
  d_k = c(rep(1/4,n))
  c_k = c(rep(0,n))
  Stepsize = 0.5
  esp = 10^-5 #threshold for Q value
  wk_new = wk
  repeat
  {
    wk_old = wk_new
    Q_old = Fs(X, tau, Gamma, rho, wk_old)
    for(k in 1:(K-1))
    { #First: compute the quadratic approximation w.r.t (w_k): L_Qk
      P = Pik(n, K, X, wk_new) #value of Pi_k
      P_k = P[,k]
      #d_k = P_k*(1-P_k)
      c_k = X%*%(as.matrix(wk_new[k,]))+4*(tau[,k]-P_k)
      #Second: coordinate descent for maximizing L_Qk
      wk_new[k,] = CoorLQk(X, c_k, d_k, wk_new[k,], Gamma[k], rho)
    }
    Q_new = Fs(X, tau, Gamma, rho, wk_new)
    #-------------BACKTRACKING LINE SEARCH
    t = 1
    while (Q_new < Q_old)
    {
      t = t*Stepsize
      wk_new = wk_new*t + wk_old*(1-t)
      Q_new = Fs(X, tau, Gamma, rho, wk_new)
    }
    if((Q_new - Q_old) < esp) break
  }
  #print("OK!")
  return(wk_new)
}
