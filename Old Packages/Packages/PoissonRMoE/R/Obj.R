Obj = function(tau, X, Y, u, Gammak, rho)
#Compute the value of the ojective function
{
  n = dim(X)[1]
  d = dim(X)[2]
  Val = t(as.matrix(tau))%*%((X%*%as.matrix(u)-Y)^2)
  beta = u[-1]
  if(Gammak==0) Val = Val/2
  else Val = Val/2 + Gammak*(colSums(as.matrix(abs(beta))))
  if(rho != 0) Val = Val + rho/2*(colSums(as.matrix(beta))^2)
  return (Val)
}