ZeroCoeff = function(wk, d, K, step, ZMat)
{
  for (k in 1:K)
  {
    Count = 0
    for(j in 2:d) #Count zero beta coefficient
      if(wk[j,k]==0) Count = Count + 1
    ZMat[step,k] <<- Count
  }
}