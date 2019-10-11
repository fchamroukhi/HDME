Fk = function(X, Y, R, tau, lambda, etak, k)
{
  #Compute the Q_k(eta_k;.) function in M-step for eta_k
  #input: matrix eta[k,,], k
  #remove the L2 norm
  # source("Pik.R")
  # source("Pi.R")
  n = dim(X)[1]
  d = dim(X)[2]
  #etak = as.matrix(eta[k,,]) #in the input
  PI = matrix(rep(0, n*R), ncol=R)
  PI = Pik(n, R, X, etak) #Compute probability for each Xi w.r.t Expert #k
  logPi = log(PI)
  S = 0
  for(i in 1:n)
  {
    S = S + tau[i,k]*logPi[i, Y[i]]
  }

    ETA = as.matrix(etak[,c(2:d)])#remove eta[k,1] and set it as matrix in case d = 2
    ETA1 = abs(ETA)
  # ETA2 = ETA^2
  L1 = rowSums(ETA1)
  S1 = sum(lambda[k,]*L1)
  #S2 = sum(ETA2)*rho/2   #The L2 norm
  S = S - S1
  return(S)
}
