Pi = function(R, Xi, w)
  #Dim X = p+1 with the first column := 1
  #Compute pi_jk(r_j, omega) with eta_r[R] = 0
  #omega has the matrix form
{
  P = matrix(rep(0, R), ncol=R)
  W = rbind(w,0)
  Mat =t(exp(W%*%as.matrix(Xi)))
  #print(Mat)
  S = rowSums(Mat)
  #print(S)
  P = Mat/S
  return(P)
}