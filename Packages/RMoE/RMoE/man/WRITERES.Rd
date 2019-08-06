\name{WRITERES}
\alias{WRITERES}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
WRITERES()
}
%- maybe also 'usage' for other objects documented here.
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
function () 
{
    Para = cbind(MAXbetak, t(MAXwk))
    write.table(Para, file = "Para.txt", sep = "\t", append = FALSE, 
        col.names = FALSE, row.names = FALSE)
    write.table(sqrt(MAXS), file = "Sigma.txt", append = FALSE, 
        col.names = FALSE, row.names = FALSE)
    write.table(MAXLOG, file = "LOG.txt", append = FALSE, col.names = FALSE, 
        row.names = FALSE)
    MAXtau = e.step(MAXbetak, MAXwk, MAXS, Y, X, K)
    MAXP = Pik(n, K, X, MAXwk)
    write.table(MAXP, file = "MAXP.txt", sep = "\t", append = FALSE, 
        col.names = FALSE, row.names = FALSE)
    MAXClass = apply(MAXtau, 1, which.max)
    RDATA = cbind(Data, MAXClass)
    write.table(RDATA, file = "Restore Data.txt", sep = "\t", 
        append = FALSE, col.names = FALSE, row.names = FALSE)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
