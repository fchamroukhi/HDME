\name{CoorLQk}
\alias{CoorLQk}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
CoorLQk(X, Y, tau, u, Gammak, rho)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{X}{
%%     ~~Describe \code{X} here~~
}
  \item{Y}{
%%     ~~Describe \code{Y} here~~
}
  \item{tau}{
%%     ~~Describe \code{tau} here~~
}
  \item{u}{
%%     ~~Describe \code{u} here~~
}
  \item{Gammak}{
%%     ~~Describe \code{Gammak} here~~
}
  \item{rho}{
%%     ~~Describe \code{rho} here~~
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
function (X, Y, tau, u, Gammak, rho) 
{
    epsilon = 10^(-6)
    source("Obj.R")
    source("SoTh.R")
    d = dim(X)[2]
    p = d - 1
    Val = Obj(tau, X, Y, u, Gammak, rho)
    Xmat = X[, -1]
    Sum = t(as.matrix(tau)) \%*\% Xmat^2
    TaU = colSums(as.matrix(tau))
    repeat {
        Val1 = Val
        alpha = u[1]
        beta = u[-1]
        for (j in 1:p) {
            rij = Y - X \%*\% as.matrix(u) + beta[j] * Xmat[, j]
            numerator = colSums(as.matrix(rij * tau * Xmat[, 
                j]))
            denominator1 = tau * Xmat[, j]^2
            denominator = rho + colSums(as.matrix(denominator1))
            beta[j] = SoTh(numerator, Gammak)/denominator
            alpha = t(as.matrix(tau)) \%*\% (Y - Xmat \%*\% as.matrix(beta))
            alpha = alpha/TaU
            u = c(alpha, beta)
        }
        Val = Obj(tau, X, Y, u, Gammak, rho)
        if ((Val1 - Val) < epsilon) 
            break
    }
    return(u)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
