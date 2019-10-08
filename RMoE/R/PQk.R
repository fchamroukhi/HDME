Qk = function(X, Y, tau, betakk, lambda, rho, k)
{
  #Input betakk = betak[k]
  U = X%*%as.matrix(betakk)
  S = colSums(tau[,k]*(-exp(U)+Y*U))
  h = abs(betakk)
  h = h[-1]
  Pen = sum(lambda[k]*h)
  S = S - Pen
  return(S)
}