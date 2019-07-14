Pik = function(n, K, X, wk) #t := X
  #Dim X = p+1 with the first column := 1
  #Compute pi_jk(r_j, omega) with alpha[K] = 0
  #omega has the matrix form
{
  P = matrix(rep(0, n*K), ncol=K)
  Wk = rbind(wk,0)
  Mat =exp(X%*%t(Wk))
  s = rowSums(Mat)
  S = matrix(rep(s, K), ncol=K)
  P = Mat/S
  return(P)
}
