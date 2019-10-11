PCoorExpP = function(X, Y, betak, tau, lambda, k)
{
#Input matrix betak and k (for parallel programing)
  # source("PQk.R")
  # source("CoorLQk.R")
  # source("Pik.R")
  n = dim(X)[1]
  P_k = c(rep(0,n))
  d_k = c(rep(0,n))
  c_k = c(rep(0,n))
  Stepsize = 0.5
  esp = 10^-5 #threshold for Q value
  betakk_new = betak[,k]
  repeat
  {
    betakk_old = betakk_new
    Q_old = Qk(X, Y, tau, betakk_old, lambda, rho, k)
      U = X%*%as.matrix(betakk_old)
      d_k = tau[,k]*exp(U)
      c_k = Y/exp(U)-1+U
      betakk_new = CoorLQk(X, c_k, d_k, betakk_old, lambda[k], 0)
      #just Lasso
    Q_new = Qk(X, Y, tau, betakk_new, lambda, rho, k)
    #-------------BACKTRACKING LINE SEARCH
    t = 1
    while (Q_new < Q_old)
    {
      t = t*Stepsize
      betakk_new  = betakk_new *t + betakk_old*(1-t)
      Q_new = Qk(X, Y, tau, betakk_new, lambda, rho, k)
    }
    if((Q_new - Q_old) < esp) break
  }
  return(betakk_new)
}
