LWRITERES = function(MAXeta, MAXwk, MAXLOG, MAXBIC, Y, X, K, R, n)
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
  utils::write.table(Para, file = "LPara.txt", sep = '\t', append = FALSE, col.names = FALSE, row.names = FALSE)
  utils::write.table(MAXLOG, file = "LLOG.txt", append = FALSE, col.names = FALSE, row.names = FALSE)
  utils::write.table(MAXBIC, file = "LBIC.txt", append = FALSE, col.names = FALSE, row.names = FALSE)
  MAXtau = Le.step(MAXeta, MAXwk, Y, X, K, R)
  MAXP = Pik(n, K, X, MAXwk)
  utils::write.table(MAXP, file = "LMAXP.txt", sep = '\t', append = FALSE, col.names = FALSE, row.names = FALSE)
  MAXClass = apply(MAXtau, 1, which.max)
  Data = cbind(X,Y)
  RDATA = cbind(Data, MAXClass)
  #utils::write.table(RDATA, file = "Restore Data.txt", sep = '\t', append = TRUE, col.names = FALSE, row.names = FALSE)
  #DATA = DATA[-seq(1,300),]#=========Data size = 300
  utils::write.table(RDATA, file="LRestore Data.txt",sep = '\t', append = FALSE, col.names = FALSE, row.names = FALSE)
  #NoR <<- NoR + 1
  #print(paste("NoR: ", NoR))
}
