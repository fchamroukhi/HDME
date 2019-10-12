PWRITERES = function(MAXbetak, MAXwk, MAXLOG, MAXBIC, Y, X, K)
{
  # if(MAXbetak[1,1] < 0)
  # {
  #   temp = MAXbetak[,1]
  #   MAXbetak[,1] = MAXbetak[,2]
  #   MAXbetak[,2] = temp
  #   MAXwk = - MAXwk
  # }
  n = dim(X)[1]
  Para = cbind(MAXbetak, t(MAXwk))
  utils::write.table(Para, file = "PPara.txt", sep = '\t', append = FALSE, col.names = FALSE, row.names = FALSE)
  utils::write.table(MAXLOG, file = "PLOG.txt", append = FALSE, col.names = FALSE, row.names = FALSE)
  utils::write.table(MAXBIC, file = "PBIC.txt", append = FALSE, col.names = FALSE, row.names = FALSE)
  MAXtau = Pe.step(MAXbetak, MAXwk, Y, X, K)
  MAXP = Pik(n, K, X, MAXwk)
  utils::write.table(MAXP, file = "PMAXP.txt", sep = '\t', append = FALSE, col.names = FALSE, row.names = FALSE)
  MAXClass = apply(MAXtau, 1, which.max)
  Data = cbind(X,Y)
  RDATA = cbind(Data, MAXClass)
  #utils::write.table(RDATA, file = "Restore Data.txt", sep = '\t', append = TRUE, col.names = FALSE, row.names = FALSE)
  #DATA = DATA[-seq(1,300),]#=========Data size = 300
  utils::write.table(RDATA, file="PRestore Data.txt",sep = '\t', append = FALSE, col.names = FALSE, row.names = FALSE)
  #NoR <<- NoR + 1
  #print(paste("NoR: ", NoR))
}
