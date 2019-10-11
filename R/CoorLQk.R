CoorLQk = function(X, Y, tau, u, Gammak, rho)
    #Find MINIMUM of penalized function
    #u vector of parameters (alpha, beta) represent wk_k
    #true tau is in c_k
    #tau vector represent by d_k
 {
   epsilon = 10^(-6) #Stopping condition
    # arr = c(rep(0, 300))
    # source("Obj.R")
    # source("SoTh.R")
    #X = as.matrix(X)
    #Y = as.matrix(Y)
    d = dim(X)[2]
    d1 = d-1
    n = dim(X)[1]
    Val = Obj(tau, X, Y, u, Gammak, rho)
    # step = 1
    # arr[step] = Val
    Xmat = X[,-1]
    Sum = t(as.matrix(tau))%*%Xmat^2
    TaU = colSums(as.matrix(tau))
    repeat
    {
      Val1 = Val
      alpha = u[1]
      beta = u[-1]
      for(j in 1:d1)
      {
        rij = Y - X%*%as.matrix(u) + beta[j]*Xmat[,j]
        #print(rij)
        numerator = colSums(as.matrix(rij*tau*Xmat[,j]))
        denominator1 = tau*Xmat[,j]^2
        denominator = rho + colSums(as.matrix(denominator1))
        # print(paste("Numerator: ", numerator))
        # print(paste("Denominator: ", denominator))
        beta[j] = SoTh(numerator, Gammak)/denominator
        alpha = t(as.matrix(tau))%*%(Y-Xmat%*%as.matrix(beta))
        alpha = alpha/TaU
        u = c(alpha, beta)
      }
        Val = Obj(tau, X, Y, u, Gammak, rho)
        # step = step+1
        # arr[step] = Val
        # print(paste("Val:",Val))
      if ((Val1 - Val) < epsilon) break
    }
    #============== Display=============
    # Step = seq.int(1, step)
    # Arr = c(rep(0, step))
    # print("Coordinate descent for minimum value: ")
    # for(i in 1:step)
    # {
    #   Arr[i]=arr[i]
    # }
    # print(Arr)
    # print(paste("Number of iteration: "))
    # print(step)
    # lines2D(Step, Arr, col = "blue")
    return (u)
}
