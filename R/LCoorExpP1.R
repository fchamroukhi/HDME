LCoorExpP = function(X, Y, U, R, eta, tau, lambda, k)
  #Proximal Newton-type for the #k Expert parameter eta[k,,]
  #Input: array[eta], k, lambda[k]
{
  source("LFk.R")
  source("CoorLQk.R")
  source("Pik.R")
  n = dim(X)[1]
  P_r = c(rep(0,n))
  d_r = c(rep(1/4,n))
  c_r = c(rep(0,n))
  Stepsize = 0.5
  esp = 10^-5 #threshold for Q value
  etak = as.matrix(eta[k,,])
  if(R==2) etak = t(etak) #change dimension
  etak_new = etak
  repeat
  {
    etak_old = etak_new
    Qk_old = Fk(X, Y, R, tau, lambda, etak_old, k)
    for(r in 1:(R-1))
    { #First: compute the quadratic approximation w.r.t (w_k): L_Qk
      P = Pik(n, R, X, etak_new) #value of Pi_k
      P_r = P[,r]
      e_r = tau[,k]/4
      c_r = X%*%(as.matrix(etak_new[r,]))+4*(U[,r]-P_r)
      #Second: coordinate descent for maximizing L_Qk
      etak_new[r,] = CoorLQk(X, c_r, e_r, etak_new[r,], lambda[k,r], 0)
    }
    #print(etak_new)
    Qk_new = Fk(X, Y, R, tau, lambda, etak_new, k)
    #print(paste("Minus: ",Qk_new-Qk_old))
    #-------------BACKTRACKING LINE SEARCH
    t = 1
    while ( Qk_new < Qk_old)
    {
      t = t*Stepsize
      #----------Stupid Tuyen!!! old + new
      # etak_new[r,] = etak_new[r,]*t + etak_old[r,]*(1-t) #For R = 2
      etak_new = etak_new*t + etak_old*(1-t) # For general
      Qk_new = Fk(X, Y, R, tau, lambda, etak_new, k)
      #print(print(paste("Minus: ",Qk_new-Qk_old)))
    }
    if((Qk_new - Qk_old) < esp) break
  }
  return(etak_new)
}
