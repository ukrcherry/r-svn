% File src/library/stats/man/predict.loess.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2020 R Core Team
% Distributed under GPL 2 or later

\name{predict.loess}
\alias{predict.loess}
\title{Predict \abbr{LOESS} Curve or Surface}
\description{
 Predictions from a \code{loess} fit, optionally with standard errors.
}
\usage{
\method{predict}{loess}(object, newdata = NULL, se = FALSE,
        na.action = na.pass, \dots)
}
\arguments{
  \item{object}{an object fitted by \code{loess}.}
  \item{newdata}{an optional data frame in which to look for variables with
    which to predict, or a matrix or vector containing exactly the variables
    needs for prediction.  If missing, the original data points are used.}
  \item{se}{should standard errors be computed?}
  \item{na.action}{function determining what should be done with missing
    values in data frame \code{newdata}.  The default is to predict \code{NA}.}
  \item{\dots}{arguments passed to or from other methods.}
}
\details{
  The standard errors calculation \code{se = TRUE} is slower than
  prediction, notably as it needs a relatively large workspace (memory),
  notably matrices of dimension \eqn{N \times Nf}{N * Nf} where \eqn{f =
  }\code{span}, i.e., \code{se = TRUE} is \eqn{O(N^2)}
  and hence stops when the sample size \eqn{N} is larger than about 40'600
  (for default \code{span = 0.75}).

  When the fit was made using \code{surface = "interpolate"} (the
  default), \code{predict.loess} will not extrapolate -- so points outside
  an axis-aligned hypercube enclosing the original data will have
  missing (\code{NA}) predictions and standard errors.
}
\value{
  If \code{se = FALSE}, a vector giving the prediction for each row of
  \code{newdata} (or the original data). If \code{se = TRUE}, a list
  containing components
  \item{fit}{the predicted values.}
  \item{se}{an estimated standard error for each predicted value.}
  \item{residual.scale}{the estimated scale of the residuals used in
    computing the standard errors.}
  \item{df}{an estimate of the effective degrees of freedom used in
    estimating the residual scale, intended for use with t-based
    confidence intervals. }
  If \code{newdata} was the result of a call to
  \code{\link{expand.grid}}, the predictions (and s.e.'s if requested)
  will be an array of the appropriate dimensions.

  Predictions from infinite inputs will be \code{NA} since \code{loess}
  does not support extrapolation.
}
\author{
  B. D. Ripley, based on the \code{cloess} package of Cleveland,
  Grosse and Shyu.
}
\note{
  Variables are first looked for in \code{newdata} and then searched for
  in the usual way (which will include the environment of the formula
  used in the fit).  A warning will be given if the
  variables found are not of the same length as those in \code{newdata}
  if it was supplied.
}

\seealso{\code{\link{loess}}}

\examples{
cars.lo <- loess(dist ~ speed, cars)
predict(cars.lo, data.frame(speed = seq(5, 30, 1)), se = TRUE)
# to get extrapolation
cars.lo2 <- loess(dist ~ speed, cars,
  control = loess.control(surface = "direct"))
predict(cars.lo2, data.frame(speed = seq(5, 30, 1)), se = TRUE)
}
\keyword{smooth}
