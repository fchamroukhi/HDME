\name{PoissonRMoE}
\alias{PoissonRMoE}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{PoissonRMoE
%%  ~~function to do ... ~~
}
\description{
This function provides a penalized MLE for the Poisson regularized Mixture of Experts (MoE) model corresponding with the penalty parameters Lambda, Gamma.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
PoissonRMoE(X, Y, K, Lambda, Gamma, option)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{X}{The matrix data for the input.}
  \item{Y}{vector of the respond variable.}
  \item{K}{number of expert classes.}
  \item{Lambda}{penalty value for the expert part.}
  \item{Gamma}{penalty value for the gating network.}
  \item{option}{option = 1: using proximal Newton-type method; option = 0: using proximal Newton method.}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
The results are stored in 5 txt files:
\item{Para.txt}{contains 2K-1 vectors: the first K vectors are vectors of the experts, the remain are vectors of the gating network;}
\item{LOG.txt}{the penalized log-likelihood value;}
\item{MAXP.txt}{the gating network's values for each observation;}
\item{BIC.txt}{the value of BIC;}
\item{Restore data.txt}{contains the input data and the classification class (the last column) for each observation.}
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
function (x)
{
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
