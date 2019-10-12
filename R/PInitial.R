Initial = function(X, Y, d, K)
{
  betak = matrix(rep(0, d*K), ncol = K)
  for (k in 1:K) betak[,k] = stats::runif(d,-5, 5)
  MAXY = max(Y)
  logY = log(MAXY)
  U = abs(X%*%betak)
  MAX = max(U)
  betak = betak/MAX*logY*stats::runif(1,1,3)
  return (betak)
}
