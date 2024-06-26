
% File src/library/utils/man/str.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2023 R Core Team
% Distributed under GPL 2 or later

\name{str}
\title{Compactly Display the Structure of an Arbitrary R Object}
\alias{str}
\alias{str.default}
\alias{str.data.frame}
\alias{strOptions}
\usage{
str(object, \dots)

\method{str}{data.frame}(object, \dots)

\method{str}{default}(object, max.level = NA,
    vec.len  = strO$vec.len, digits.d = strO$digits.d,
    nchar.max = 128, give.attr = TRUE,
    drop.deparse.attr = strO$drop.deparse.attr,
    give.head = TRUE, give.length = give.head,
    width = getOption("width"), nest.lev = 0,
    indent.str = paste(rep.int(" ", max(0, nest.lev + 1)),
                       collapse = ".."),
    comp.str = "$ ", no.list = FALSE, envir = baseenv(),
    strict.width = strO$strict.width,
    formatNum = strO$formatNum, list.len = strO$list.len,
    deparse.lines = strO$deparse.lines, \dots)

strOptions(strict.width = "no", digits.d = 3, vec.len = 4,
           list.len = 99, deparse.lines = NULL,
           drop.deparse.attr = TRUE,
           formatNum = function(x, ...)
                       format(x, trim = TRUE, drop0trailing = TRUE, ...))
}
\description{
  Compactly display the internal \bold{str}ucture of an \R object, a
  diagnostic function and an alternative to \code{\link{summary}}
  (and to some extent, \code{\link{dput}}).  Ideally, only one line for
  each \sQuote{basic} structure is displayed.  It is especially well suited
  to compactly display the (abbreviated) contents of (possibly nested)
  lists.  The idea is to give reasonable output for \bold{any} \R
  object.  It calls \code{\link{args}} for (non-primitive) function objects.

  \code{strOptions()} is a convenience function for setting
  \code{\link{options}(str = .)}, see the examples.
}
\arguments{
  \item{object}{any \R object about which you want to have some
    information.}
  \item{max.level}{maximal level of nesting which is applied for
    displaying nested structures, e.g., a list containing sub lists.
    Default NA: Display all nesting levels.}
  \item{vec.len}{numeric (>= 0) indicating how many \sQuote{first few} elements
    are displayed of each vector.  The number is multiplied by different
    factors (from .5 to 3) depending on the kind of vector.  Defaults to
    the \code{vec.len} component of option \code{"str"} (see
    \code{\link{options}}) which defaults to 4.}
  \item{digits.d}{number of digits for numerical components (as for
    \code{\link{print}}).  Defaults to the \code{digits.d} component of
    option \code{"str"} which defaults to 3.}
  \item{nchar.max}{maximal number of characters to show for
    \code{\link{character}} strings.  Longer strings are truncated, see
    \code{longch} example below.}
  \item{give.attr}{logical; if \code{TRUE} (default), show attributes
    as sub structures.}
  \item{drop.deparse.attr}{logical; if \code{TRUE} (default),
    \code{\link{deparse}(control = \var{control})} will not have
    \code{"showAttributes"} in \var{control}.  Used to be hard coded to
    \code{FALSE} and hence can be set via \code{strOptions()} for back
    compatibility.}
  \item{give.length}{logical; if \code{TRUE} (default), indicate
    length (as \code{[1:\dots]}).}
  \item{give.head}{logical; if \code{TRUE} (default), give (possibly
    abbreviated) mode/class and length (as \code{\var{type}[1:\dots]}).}
  \item{width}{the page width to be used.  The default is the currently
    active \code{\link{options}("width")}; note that this has only a
    weak effect, unless \code{strict.width} is not \code{"no"}.}
  \item{nest.lev}{current nesting level in the recursive calls to
    \code{str}.}
  \item{indent.str}{the indentation string to use.}
  \item{comp.str}{string to be used for separating list components.}
  \item{no.list}{logical; if true, no \sQuote{list of \dots} nor the
    class are printed.}
  \item{envir}{the environment to be used for \emph{promise} (see
    \code{\link{delayedAssign}}) objects only.}
  \item{strict.width}{string indicating if the \code{width} argument's
    specification should be followed strictly, one of the values
    \code{c("no", "cut", "wrap")}, which can be abbreviated.
    Defaults to the \code{strict.width} component of option \code{"str"}
    (see \code{\link{options}}) which defaults to \code{"no"} for back
    compatibility reasons; \code{"wrap"} uses
    \code{\link{strwrap}(*, width = width)} whereas \code{"cut"} cuts
    directly to \code{width}.  Note that a small \code{vec.length}
    may be better than setting \code{strict.width = "wrap"}.}
  \item{formatNum}{a function such as \code{\link{format}} for
    formatting numeric vectors.  It defaults to the \code{formatNum}
    component of option \code{"str"}, see \dQuote{Usage} of
    \code{strOptions()} above, which is almost back compatible to \R
    <= 2.7.x, however, using \code{\link{formatC}} may be slightly better.}
  \item{list.len}{numeric; maximum number of list elements to display
    within a level.}
  \item{deparse.lines}{numeric or \code{NULL} as by default, determining the
    \code{nlines} argument to \code{\link{deparse}()} when \code{object} is
    a \code{\link{call}}.  When \code{NULL}, the \code{nchar.max} and
    \code{width} arguments are used to determine a smart default.}
  \item{\dots}{potential further arguments (required for Method/Generic
    reasons).}
}
\value{
  \code{str} does not return anything, for efficiency reasons.
  The obvious side effect is output to the terminal.
}
\note{
  See the extensive annotated \sQuote{Examples} below.

  The default method tries to \dQuote{work always}, but needs to make some
  assumptions for the case when \code{object} has a \code{\link{class}} but
  no own \code{str()} method which is \emph{the typical} case: There it
  relies on \code{"\link{[}"} and \code{"\link{[[}"} subsetting methods to
  be compatible with \code{\link{length}()}.  When this is not the case, or
  when \code{is.list(object)} is \code{TRUE}, but \code{length(object)}
  differs from \code{length(\link{unclass}(object))} it treats it as
  \dQuote{irregular} and reports the contents of \code{unclass(object)}
  as \dQuote{hidden list}.
}
\author{Martin Maechler \email{maechler@stat.math.ethz.ch} since 1990.
}
\seealso{
  \code{\link{ls.str}} for \emph{listing} objects with their structure;
  \code{\link{summary}}, \code{\link{args}}.
}
\examples{
require(stats); require(grDevices); require(graphics)
## The following examples show some of 'str' capabilities
str(1:12)
str(ls)
str(args) #- more useful than  args(args) !
str(freeny)
str(str)
str(.Machine, digits.d = 20) # extra digits for identification of binary numbers
str( lsfit(1:9, 1:9))
str( lsfit(1:9, 1:9), max.level = 1)
str( lsfit(1:9, 1:9), width = 60, strict.width = "cut")
str( lsfit(1:9, 1:9), width = 60, strict.width = "wrap")
op <- options(); str(op)   # save first;
                           # otherwise internal options() is used.
need.dev <-
  !exists(".Device") || is.null(.Device) || .Device == "null device"
{ if(need.dev) pdf()
  str(par())
  if(need.dev) graphics.off()
}
ch <- letters[1:12]; is.na(ch) <- 3:5
str(ch) # character NA's

str(list(a = "A", L = as.list(1:100)), list.len = 9)
##                                     ------------
## " .. [list output truncated] "

## Long strings,   'nchar.max'; 'strict.width' :
nchar(longch <- paste(rep(letters,100), collapse = ""))
str(longch)
str(longch, nchar.max = 52)
str(longch, strict.width = "wrap")

## Multibyte characters in strings:
## Truncation behavior (<-> correct width measurement) for "long" non-ASCII:
idx <- c(65313:65338, 65345:65350)
fwch <- intToUtf8(idx) # full width character string: each has width 2
ch <- strtrim(paste(LETTERS, collapse="._"), 64)
(ncc <- c(c.ch = nchar(ch),   w.ch = nchar(ch,   "w"),
          c.fw = nchar(fwch), w.fw = nchar(fwch, "w")))
stopifnot(unname(ncc) == c(64,64, 32, 64))
## nchar.max: 1st line needs an increase of  2  in order to see  1  (in UTF-8!):
invisible(lapply(60:66, function(N) str(fwch, nchar.max = N)))
invisible(lapply(60:66, function(N) str( ch , nchar.max = N))) # "1 is 1" here


## Settings for narrow transcript :
op <- options(width = 60,
              str = strOptions(strict.width = "wrap"))
str(lsfit(1:9,1:9))
str(options())
## reset to previous:
options(op)


\dontshow{
 ##-- Some "crazy" objects
 str(array(1:5, dim = 20))
 str(factor(character(0)))
 str(as.data.frame(NULL))
}
str(quote( { A+B; list(C, D) } ))

% package attaching/detaching only when needed:
\dontshow{
had.stats4 <- "package:stats4" \%in\% search()
if(!had.stats4)
   rs <- % the result of require() below
}
## S4 classes :
require(stats4)
x <- 0:10; y <- c(26, 17, 13, 12, 20, 5, 9, 8, 5, 4, 8)
ll <- function(ymax = 15, xh = 6)
      -sum(dpois(y, lambda=ymax/(1+x/xh), log=TRUE))
fit <- mle(ll)
str(fit)
\dontshow{if(!had.stats4 && rs) detach("package:stats4")}
}
\keyword{print}
\keyword{documentation}
\keyword{utilities}
