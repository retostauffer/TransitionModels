\name{tm_dist}
\alias{tm_dist}

\title{
  Transition Model Probability Density Visualization
}

\description{
  Visualizes the probability density function (PDF) and raw count or continuous data 
  based on transition models estimated using \code{\link{tm}}. This function provides 
  an intuitive way to understand the distribution of the modeled response.
}

\usage{
tm_dist(y, data = NULL, ...)
}

\arguments{
  \item{y}{A response vector or a formula specifying the relationship between the 
    response and covariates. For count data, this is typically a vector of counts. 
    For continuous data, this can be paired with the \code{breaks} argument to 
    discretize the response.}
  \item{data}{Optional. If \code{y} is a formula, this specifies the data frame to 
    be used for model fitting.}
  \item{\dots}{Additional arguments to be passed to \code{\link{tm}}, including 
    settings for the estimation engine, formula, and other relevant parameters.}
}

\details{
  This function estimates and visualizes the underlying probability density function 
  (PDF) for count or continuous response data using transition models. For continuous 
  data, the response is discretized based on the \code{breaks} argument passed through 
  \code{\dots}. 

  The function supports visualizations for raw counts, zero-inflated data, and transformed 
  distributions, providing insights into the modeled distribution of the response variable.
}

\value{
  An object of class \code{"tm"}, as described in \code{\link{tm}}. This includes:
  \itemize{
    \item Fitted transition model details.
    \item Model diagnostics and parameters.
    \item Visualization-ready data for plotting PDFs or transformed distributions.
  }
}

\seealso{
  \code{\link{tm}}, \code{\link{tm_data}}
}

\examples{
## Example 1: Count data.
set.seed(123)
n <- 3000
y <- rpois(n, 10)

# Visualize PDF for count data.
tm_dist(y)

## Example 2: Zero-inflated data.
y <- c(y, rep(0, 500))

## Include a zero-inflation term.
tm_dist(y ~ s(theta) + theta0)

## Example 3: Continuous data.
set.seed(123)
n <- 1000
y <- rgamma(n, shape = 10, rate = 0.1)

## Visualize PDF for continuous data with discretization.
tm_dist(y, breaks = 50)
}

\keyword{distribution}
\keyword{visualization}

