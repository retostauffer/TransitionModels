#!/usr/bin/env Rscript
library("TransitionModels")
library("gamlss2")


## Data generating processes.
dgp_NO <- function(n = 1000, probs = c(0.01, 0.1, 0.5, 0.9, 0.99), breaks = 20, ...)
{
  ## Covariate.
  x <- runif(n, -3, 3)

  ## Parameters.
  mu <- sin(x)
  sigma <- exp(-1 + cos(x))

  ## Response
  y_cont <- rnorm(n, mean = mu, sd = sigma)

  ## Discretize the normal data into count categories.
  yr <- range(y_cont)
  breaks <- seq(-4, 4, length.out = breaks)
  y_count <- cut(y_cont, breaks = breaks, labels = FALSE, include.lowest = TRUE) - 1

  ## Combine.
  d <- data.frame("x" = x, "counts" = y_count, "num" = y_cont)

  ## Add quantiles.
  qu <- quc <- NULL
  for(j in probs) {
    qj <- qNO(j, mu = mu, sigma = sigma)
    qu <- cbind(qu, qj)
    quc <- cbind(quc, cut(qj, breaks = breaks, labels = FALSE, include.lowest = TRUE) - 1)
  }
  colnames(qu) <- colnames(quc) <- paste0(probs * 100, "%")
  d$quantiles <- qu
  d$count.quantiles <- quc

  return(d)
}


sim_NO <- function(d, nd, breaks, ncores, counts = FALSE, family = NO, engine = "bam", useC = FALSE, ...)
{
  breaks <- as.integer(breaks)[1L]
  stopifnot(is.integer(breaks), length(breaks) == 1L, breaks > 0)
  if(counts) {
    d$num <- d$counts
    nd$num <- nd$counts
    d$quantiles <- d$count.quantiles
    nd$quantiles <- nd$count.quantiles
  }

  ## Set quantiles.
  qu <- colnames(nd$quantiles)
  qu <- as.numeric(gsub("%", "", qu, fixed = TRUE))/100

  ## Estimate transition model.
  warning("Using num ~ theta for testing")
  f <- num ~ theta
  #f <- num ~ s(theta) + s(x) + te(theta,x)
  message("\n\n ====== running model estimation with useC = ", useC, " ===== \n")
  b <- tm(f, data = d, ncores = ncores, breaks = breaks, engine = engine,
    scale.x = TRUE, size = 40, maxit = 1000, decay = 0.01, useC = useC,
    verbose = TRUE)

  message("\n\n ====== end of model estimation =========\n\n")

  ## Predict quantiles.
  p <- do.call("cbind",
    lapply(qu, function(j) {
      predict(b, newdata = nd, prob = j, ncores = ncores, useC = useC)
  }))

  return(b)
}


# Sim
#n <- 50000
n <- 10000
#n <- 2000
##n <- 3
probs <- 0.5
set.seed(111)
d  <- dgp_NO(n, probs = probs)
nd <- dgp_NO(1000, probs = probs)

message("    -------------------------------")
message("       Using N = ", n)
#message("       Calling devtools load_all")
devtools::load_all("../")
message("    -------------------------------")
ncores <- -1
#t1 <- system.time(
#    mod1 <- sim_NO(d, nd, ncores, breaks = 40, counts = FALSE, family = NO, engine = "bam", useC = FALSE, ncores = ncores)
#)
t2 <- system.time(
    mod2 <- sim_NO(d, nd, ncores, breaks = 40, counts = FALSE, family = NO, engine = "bam", useC = TRUE)
)
#print(t1)
print(t2)
#print(c("R version" = logLik(mod1), "C version" = logLik(mod2)))
print(c("C version" = logLik(mod2)))
tm_detect_cores()

devtools::load_all("../")

#####################################
mod2
eps <- residuals(mod2)
hist(eps)
qqnorm(eps); qqline(eps)

head(d)
summary(d$counts)
nbin <- length(mod2$bins)
u <- sapply(0:(nbin - 1), function(y) predict(mod2, newdata = d[1, ], type = "pdf", y = y))
barplot(u)
sum(u)
hist(d$num, freq = FALSE)
lines(mod2$bins, u, lwd = 2, col = "tomato")
with(density(d$num), lines(x, y, col = "steelblue", lwd = 2))

set.seed(111)
t1 <- system.time(eps1 <- residuals(mod2))
t1 # 20 s
devtools::load_all("../")
set.seed(111)
t2 <- system.time(eps2 <- residuals(mod2, useC = TRUE))
t2 # 1 s
plot(eps1, eps2)

devtools::load_all("../")
system.time(rootogram(mod2, useC = TRUE, verbose = TRUE))


