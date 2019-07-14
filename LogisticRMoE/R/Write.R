WRITERES = function()
{
  #if(!(MAXeta[1,1,2]*MAXeta[2,1,2])) return()
  # if(MAXwk[1,1] < 0) #label switching for simulated data
  # {
  #   temp = MAXeta[1,,]
  #   MAXeta[1,,] = MAXeta[2,,]
  #   MAXeta[2,,] = temp
  #   MAXwk = - MAXwk
  # }
  Mat = t(rbind(MAXeta[,,]))
  Para = cbind(Mat, t(MAXwk))
  write.table(Para, file = "Para.txt", sep = '\t', append = FALSE, col.names = FALSE, row.names = FALSE)
  write.table(MAXLOG, file = "LOG.txt", append = FALSE, col.names = FALSE, row.names = FALSE)
  write.table(MAXBIC, file = "BIC.txt", append = FALSE, col.names = FALSE, row.names = FALSE)
  MAXtau = e.step(MAXeta, MAXwk, Y, X, K, R)
  MAXP = Pik(n, K, X, MAXwk)
  write.table(MAXP, file = "MAXP.txt", sep = '\t', append = FALSE, col.names = FALSE, row.names = FALSE)
  MAXClass = apply(MAXtau, 1, which.max)
  Data = cbind(X,Y)
  RDATA = cbind(Data, MAXClass)
  #write.table(RDATA, file = "Restore Data.txt", sep = '\t', append = TRUE, col.names = FALSE, row.names = FALSE)
  #DATA = DATA[-seq(1,300),]#=========Data size = 300
  write.table(RDATA, file="Restore Data.txt",sep = '\t', append = FALSE, col.names = FALSE, row.names = FALSE)
  #NoR <<- NoR + 1
  #print(paste("NoR: ", NoR))
}
