GWRITERES = function()
{
  # if(!(MAXbetak[1,1]*MAXbetak[1,2])) return()
  # if(MAXbetak[1,2] < MAXbetak[1,1])
  # {
  #   temp = MAXbetak[,1]
  #   MAXbetak[,1] = MAXbetak[,2]
  #   MAXbetak[,2] = temp
  #   MAXwk = - MAXwk
  # }
  # source("GEstep.R")
  Para = cbind(MAXbetak, t(MAXwk))
  write.table(Para, file = "GPara.txt", sep = '\t', append = FALSE, col.names = FALSE, row.names = FALSE)
  write.table(sqrt(MAXS), file = "GSigma.txt", append = FALSE, col.names = FALSE, row.names = FALSE)
  write.table(MAXLOG, file = "GLOG.txt", append = FALSE, col.names = FALSE, row.names = FALSE)
  write.table(MAXBIC, file = "GBIC.txt", append = FALSE, col.names = FALSE, row.names = FALSE)
  MAXtau = Ge.step(MAXbetak, MAXwk, MAXS, Y, X, K)
  MAXP = Pik(n, K, X, MAXwk)
  write.table(MAXP, file = "GMAXP.txt", sep = '\t', append = FALSE, col.names = FALSE, row.names = FALSE)
  MAXClass = apply(MAXtau, 1, which.max)
  Data = cbind(X,Y)
  RDATA = cbind(Data, MAXClass)
  #write.table(RDATA, file = "Restore Data.txt", sep = '\t', append = TRUE, col.names = FALSE, row.names = FALSE)
  #DATA = DATA[-seq(1,300),]#=========Data size = 300
  write.table(RDATA, file="GRestore Data.txt",sep = '\t', append = FALSE, col.names = FALSE, row.names = FALSE)
  #NoR <<- NoR + 1
  #print(paste("NoR: ", NoR))
}
