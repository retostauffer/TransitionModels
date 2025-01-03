\name{tm_data}
\alias{tm_data}

\title{
  Transition Model Data Preparer
}

\description{
  Transforms a data frame into the format required for estimating transition models. 
  The function generates binary response data for fitting GLM-type models,
  specifically designed to represent transitions between counts or states in
  a probabilistic framework.
}

\usage{
  tm_data(data, response = NULL, verbose = TRUE)
}

\arguments{
  \item{data}{A data frame containing the raw input data.}
  \item{response}{Character string specifying the name of the response variable 
    to be used for transition modeling. This variable must represent 
    counts or categorical states.}
  \item{verbose}{Logical value indicating whether information about the transformation 
    process should be printed to the console. Default is \code{TRUE}.}
}

\details{
  Transition models focus on modeling the conditional probabilities of transitions 
  between states or counts. This function converts the input data into a long format 
  suitable for such models. Each row in the resulting data frame corresponds to a 
  binary transition indicator, representing whether a transition to a higher category 
  occurred. For details on the modeling framework, see Berger and Tutz (2021).
}

\value{
  A transformed data frame in the long format. Each row represents a binary transition 
  indicator (\code{Y}) for the response variable. Additional columns in the output include:
  \itemize{
    \item \code{index}: The original row index from the input data.
    \item \code{Y}: The binary indicator for whether a transition to a higher
      category occurred.
    \item \code{theta}: The level corresponding to the current transition.
  }
  This format is required for fitting transition models using GLM or GAM frameworks. 
  For instance, a response variable with a value of 3 will generate rows with 
  transitions up to its value (0, 1, 2, and 3).
}

\seealso{
  \code{\link{tm}}, \code{\link{tm_dist}}
}

\examples{
## Raw data frame.
d <- data.frame(
  "id" = 1:5,
  "counts" = c(1, 0, 2, 3, 1),
  "x" = 1:5 * 10
)

## Transformed data frame.
dtm <- tm_data(d, response = "counts", verbose = TRUE)
print(dtm)
}

\keyword{data transformation}
\concept{transition modeling}

