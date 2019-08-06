\name{RMoE}
\alias{RMoE}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
RMoE(X, Y, K, Lambda, Gamma, option)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{X}{
%%     ~~Describe \code{X} here~~
}
  \item{Y}{
%%     ~~Describe \code{Y} here~~
}
  \item{K}{
%%     ~~Describe \code{K} here~~
}
  \item{Lambda}{
%%     ~~Describe \code{Lambda} here~~
}
  \item{Gamma}{
%%     ~~Describe \code{Gamma} here~~
}
  \item{option}{
%%     ~~Describe \code{option} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (X, Y, K, Lambda, Gamma, option) 
{
    library(plot3D)
    library(stats)
    library(graphics)
    library(MASS)
    library(base)
    library(doParallel)
    library(foreach)
    cl = makeCluster(K)
    registerDoParallel(cl)
    getDoParWorkers()
    MAXLOG = -10^6
    lambda <<- c(rep(Lambda, K))
    gamma = c(rep(Gamma, K - 1))
    rho = 0
    pik = c(rep(0, K))
    Nstep = 5000
    arr = c(rep(0, Nstep))
    ZMat <<- matrix(rep(0, Nstep * K), ncol = K)
    eps = 1e-05
    d = dim(X)[2]
    n <<- dim(X)[1]
    S <<- runif(1, min = 5, max = 20)
    wk = matrix(rep(0, (K - 1) * d), ncol = d)
    betak <<- matrix(rep(0, d * K), ncol = K)
    for (k in 1:K) {
        betak[, k] = runif(d, -5, 5)
    }
    source("Estep.R")
    source("PMstep.R")
    source("SMstep.R")
    source("LOG.R")
    source("ZeroCoeff.R")
    source("BIC.R")
    source("Write.R")
    if (option) 
        source("CoorGateP1.R")
    else source("CoorGateP.R")
    tau = matrix(rep(0, n * K), ncol = K)
    L2 = LOG(X, Y, wk, betak, S, lambda, gamma, rho)
    step = 1
    arr[step] = L2
    print(paste("Step:", step))
    print("betak:")
    print(betak)
    print("wk: ")
    print(wk)
    print(paste("Sigma: ", sqrt(S)))
    print(paste("LOG: ", L2))
    repeat {
        step = step + 1
        L1 = L2
        tau = e.step(betak, wk, S, Y, X, K)
        betak = pm.step(tau, X, Y, d, K, S, lambda, betak, cl)
        wk = CoorGateP(X, wk, tau, gamma, rho)
        tau = e.step(betak, wk, S, Y, X, K)
        S = sm.step(tau, X, Y, K, betak)
        L2 = LOG(X, Y, wk, betak, S, lambda, gamma, rho)
        ZeroCoeff(betak, d, K, step, ZMat)
        arr[step] = L2
        print(paste("Step:", step))
        print("betak:")
        print(betak)
        print("wk: ")
        print(wk)
        print(paste("Sigma: ", sqrt(S)))
        print(paste("LOG: ", L2))
        if ((L2 - L1)/abs(L1) < eps) 
            break
    }
    print(paste("Number of steps: ", step))
    print(paste("betak: "))
    print(betak)
    print("wk: ")
    print(wk)
    print(paste("Sigma: ", sqrt(S)))
    print(paste("LOG value: ", L2))
    Step = seq.int(1, step)
    Arr = c(rep(0, step))
    for (i in 1:step) {
        Arr[i] = arr[i]
    }
    print(Arr)
    if (L2 > MAXLOG) {
        MAXbetak <<- betak
        MAXS <<- S
        MAXwk <<- wk
        MAXLOG <<- L2
    }
    U = t(ZMat)
    U = t(U[, c(1:step)])
    matplot(U, type = c("o"), pch = 19, col = 1:K, xlab = "Step", 
        ylab = "Number of Zero Coefficients")
    BIC = BIC(X, Y, wk, betak, S)
    print(paste("BIC: ", BIC))
    matplot(Step, Arr, col = "blue", type = "o", pch = 19, xlab = "Step", 
        ylab = "Log-likelihood")
    on.exit(stopCluster(cl))
    WRITERES()
    return()
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
