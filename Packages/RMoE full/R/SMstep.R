#M-stepS
sm.step = function(tau, X, Y, K, wk)
{
  n = dim(X)[1]
  S1 = 0
  for(k in 1:K)
  {
    temp = t(as.matrix(tau[,k]))%*%(Y - X%*%as.matrix(wk[,k]))^2
    S1 = S1+ colSums(temp,1)
  }
  S1 = S1/n
  return (S1)
}