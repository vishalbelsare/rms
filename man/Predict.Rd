\name{Predict}
\alias{Predict}
\alias{print.Predict}
\alias{rbind.Predict}
\title{Compute Predicted Values and Confidence Limits}
\description{
\code{Predict} allows the user to easily specify which predictors are to
vary.  When the vector of values over which a predictor should vary is
not specified, the
range will be all levels of a categorical predictor or equally-spaced
points between the \code{\link{datadist}} \code{"Low:prediction"} and
\code{"High:prediction"} values for the variable (\code{datadist} by
default uses the 10th smallest and 10th largest predictor values in the
dataset).  Predicted values are 
the linear predictor (X beta), a user-specified transformation of that
scale, or estimated probability of surviving past a fixed single time
point given the linear predictor.  \code{Predict} is usually used for
plotting predicted values but there is also a \code{print} method.

When the first argument to \code{Predict} is a fit object created by
\code{bootcov} with \code{coef.reps=TRUE}, confidence limits come from
the stored matrix of bootstrap repetitions of coefficients, using 
bootstrap percentile nonparametric confidence limits, basic bootstrap,
or BCa limits.  Such confidence 
intervals do not make distributional assumptions.  You can force
\code{Predict} to instead use the bootstrap covariance matrix by setting
\code{usebootcoef=FALSE}.  If \code{coef.reps} was \code{FALSE},
\code{usebootcoef=FALSE} is the default.

There are \code{ggplot}, \code{plotp}, and \code{plot} methods for
\code{Predict} objects that makes it easy to show predicted values and
confidence bands. 

The \code{rbind} method for \code{Predict} objects allows you to create
separate sets of predictions under different situations and to combine
them into one set for feeding to \code{plot.Predict}, 
\code{ggplot.Predict}, or \code{plotp.Predict}.  For example you
might want to plot confidence intervals for means and for individuals
using \code{ols}, and have the two types of confidence bands be
superposed onto one plot or placed into two panels.  Another use for
\code{rbind} is to combine predictions from quantile regression models
that predicted three different quantiles.

If \code{conf.type="simultaneous"}, simultaneous (over all requested
predictions) confidence limits are computed.  See the
\code{\link{predictrms}} function for details.

If \code{fun} is given, \code{conf.int} > 0,  the model is not a
Bayesian model, and the bootstrap was not used, \code{fun} may return
\code{limits} attribute when \code{fun} computed its own confidence
limits.  These confidence limits will be functions of the design matrix,
not just the linear predictor.
}
\usage{
Predict(object, ..., fun=NULL, funint=TRUE,
        type = c("predictions", "model.frame", "x"),
        np = 200, conf.int = 0.95,
        conf.type = c("mean", "individual","simultaneous"),
        usebootcoef=TRUE, boot.type=c("percentile", "bca", "basic"),
        posterior.summary=c('mean', 'median', 'mode'),
        adj.zero = FALSE, ref.zero = FALSE,
        kint=NULL, ycut=NULL, time = NULL, loglog = FALSE, digits=4, name,
        factors=NULL, offset=NULL)

\method{print}{Predict}(x, \dots)

\method{rbind}{Predict}(\dots, rename)
}
\arguments{
  \item{object}{
	an \code{rms} fit object, or for \code{print} the result of \code{Predict}.
	\code{options(datadist="d")} must have been specified (where
	\code{d} was created by \code{datadist}), or 
	it must have been in effect when the the model was fitted.}
  \item{\dots}{
	One or more variables to vary, or single-valued adjustment values.
	Specify a variable name without an equal sign to use the default
	display range, or any range 
	you choose (e.g. \code{seq(0,100,by=2),c(2,3,7,14)}). 
	The default list of values for which predictions are made
	is taken as the list of unique values of the variable if they number fewer
	than 11. For variables with \eqn{>10} unique values, \code{np}
	equally spaced values in the range are used for plotting if the
	range is not specified.  Variables not specified are set to the default
	adjustment value \code{limits[2]}, i.e. the median for continuous
	variables and a reference category for 	non-continuous ones.
	Later variables define adjustment settings.
	For categorical variables, specify the class labels in quotes when
	specifying variable values.  If the levels of a categorical variable
	are numeric, you may omit the quotes.  For variables not described
	using \code{datadist}, you must specify explicit ranges and
	adjustment settings for predictors  that were in the model.
	If no variables are specified in \dots, predictions will be made by
	separately varying all predictors in the model over their default
	range, holding the other predictors at their adjustment values.
	This has the same effect as specifying \code{name} as a vector
	containing all the predictors.  For \code{rbind}, \dots represents a
	series of results from \code{Predict}.  If you name the results,
	these names will be taken as the values of the new \code{.set.}
	variable added to the concatenated data frames.  See an example below.
  }
  \item{fun}{an optional transformation of the linear predictor.
	Specify \code{fun='mean'} if the fit is a proportional odds model
	fit and you ran \code{bootcov} with \code{coef.reps=TRUE}.  This
	will let the mean function be re-estimated for each bootstrap rep to
	properly account for all sources of uncertainty in estimating the
	mean response.  \code{fun} can be a general function and can compute
	confidence limits (stored as a list in the \code{limits} attribute) of
the transformed parameters such as means.}
 \item{funint}{set to \code{FALSE} if \code{fun} is not a function such
	as the result of \code{Mean}, \code{Quantile}, or \code{ExProb} that
	contains an \code{intercepts} argument}
  \item{type}{
	defaults to providing predictions.  Set to \code{"model.frame"} to
	return a data frame of predictor settings used.  Set to \code{"x"}
	to return the corresponding design matrix constructed from the
	predictor settings.
  }
  \item{np}{
	the number of equally-spaced points computed for continuous
	predictors that vary, i.e., when the specified value is omitted (with the 
  variable name appearing without an equals sign) or is \code{NA}
  }
  \item{conf.int}{
	confidence level (highest posterior density interval probability for
	Bayesian models).  Default is 0.95.  Specify \code{FALSE} to suppress.}
  \item{conf.type}{
	type of confidence interval.  Default is \code{"mean"} which applies
	to all models.  For models containing a residual variance (e.g,
	\code{ols}), you can specify \code{conf.type="individual"} instead,
	to obtain limits on the predicted value for an individual subject.
	Specify \code{conf.type="simultaneous"} to obtain simultaneous
	confidence bands for mean predictions with family-wise coverage of
	\code{conf.int}.
  }
  \item{usebootcoef}{set to \code{FALSE} to force the use of the bootstrap
	covariance matrix estimator even when bootstrap coefficient reps are
	present}
  \item{boot.type}{set to \code{'bca'} to compute BCa confidence
	limits or \code{'basic'} to use the basic bootstrap.  The default is
	to compute percentile intervals}
  \item{posterior.summary}{defaults to using the posterior mean of the
		regression coefficients.  Specify \code{'mode'} or \code{'median'}
		to instead use the other summaries.}
  \item{adj.zero}{
	Set to \code{TRUE} to adjust all non-plotted variables to 0 (or
	reference cell for categorical variables) and to omit intercept(s)
	from consideration. Default is \code{FALSE}.
  }
  \item{ref.zero}{
	Set to \code{TRUE} to subtract a constant from \eqn{X\beta}{X beta}
	before plotting so that the reference value of the \code{x}-variable
	yields \code{y=0}.  This is done before applying function \code{fun}.
	This is especially useful for Cox models to make the hazard ratio be
	1.0 at reference values, and the confidence interval have width zero.
  To set the reference value, either (a) set the reference value by editing the \code{datadist} object prior to fitting the model, or (b) if the model is already fit, edit the \code{datadist} object and then run the update command.
  }
  \item{kint}{
	This is only useful in a multiple intercept model such as the ordinal
	logistic model. There to use to second of three intercepts, for example,
	specify \code{kint=2}. The default is 1 for \code{lrm} and the middle
	intercept corresponding to the median \code{y} for \code{orm} or
	\code{blrm}.  You can specify \code{ycut} instead, and the intercept
	corresponding to Y >= ycut will be used for \code{kint}.
}
  \item{ycut}{for an ordinal model specifies the Y cutoff to use in
		evaluating departures from proportional odds, when the constrained
		partial proportional odds model is used.  When omitted, \code{ycut}
		is implied by \code{kint}.  The only time it is absolutely mandatory
		to specify \code{ycut} is when computed an effect (e.g., odds ratio)
		at a level of the response variable that did not occur in the data.
		This would only occur when the \code{cppo} function given to
		\code{blrm} is a continuous function.}
  \item{time}{
	Specify a single time \code{u} to cause function \code{survest} to
	be invoked to plot the probability of surviving until time \code{u}
	when the fit is from \code{cph} or \code{psm}.
  }
  \item{loglog}{
	Specify \code{loglog=TRUE} to plot \code{log[-log(survival)]}
	instead of survival, when \code{time} is given.
  }
  \item{digits}{
	Controls how ``adjust-to'' values are plotted.  The default is 4
	significant digits.
  }
  \item{name}{
	Instead of specifying the variables to vary in the
	\code{variables} (\dots) list, you can specify one or more variables
	by specifying a vector of character string variable names in the
	\code{name} argument.  Using this mode you cannot specify a list of
	variable values to use; prediction is done as if you had said e.g.
	\code{age} without the equal sign.  Also, interacting factors can
	only be set to their reference values using this notation.
  }
  \item{factors}{
	an alternate way of specifying \dots, mainly for use by
	\code{survplot} or \code{gendata}.  This must be a list with one or
	more values for each variable listed, with \code{NA} values for
	default ranges.}
  \item{offset}{a list containing one value for one variable, which is
		mandatory if the model included an offset term.  The variable name
		must match the innermost variable name in the offset term.  The
		single offset is added to all predicted values.}
	\item{x}{an object created by \code{Predict}}
  \item{rename}{
	If you are concatenating predictor sets using \code{rbind} and one
	or more of the variables were renamed for one or more of the sets,
	but these new names represent different versions of the same
	predictors (e.g., using or not using imputation), you can specify a
	named character vector to rename predictors to a central name.  For
	example, specify \code{rename=c(age.imputed='age',
	  corrected.bp='bp')} to rename from old names \code{age.imputed,
	  corrected.bp} to \code{age, bp}.  This happens before
	concatenation of rows.
	}
}
\details{
When there are no intercepts in the fitted model, plot subtracts
adjustment values from each factor while computing variances for
confidence limits. 

Specifying \code{time} will not work for Cox models with time-dependent
covariables.  Use \code{survest} or \code{survfit} for that purpose.
}
\value{
  a data frame containing all model predictors and the computed values
  \code{yhat}, \code{lower}, \code{upper}, the latter two if confidence
  intervals were requested.  The data frame has an additional
  \code{class} \code{"Predict"}.  If \code{name} is specified or no
  predictors are specified in \dots, the resulting data frame has an
  additional variable called \code{.predictor.} specifying which
  predictor is currently being varied.   \code{.predictor.} is handy for
  use as a paneling variable in \code{lattice} or \code{ggplot2} graphics.
}
\author{
Frank Harrell\cr
Department of Biostatistics, Vanderbilt University\cr
fh@fharrell.com
}
\seealso{
	\code{\link{plot.Predict}}, \code{\link{ggplot.Predict}},
	\code{\link{plotp.Predict}},
	\code{\link{datadist}}, \code{\link{predictrms}},
	\code{\link{contrast.rms}}, \code{\link{summary.rms}},  
	\code{\link{rms}}, \code{\link{rms.trans}}, \code{\link{survest}},
	\code{\link{survplot}}, \code{\link{rmsMisc}},
	\code{\link[Hmisc]{transace}}, \code{rbind}, \code{\link{bootcov}},
	\code{\link{bootBCa}}, \code{\link[boot]{boot.ci}}
}
\examples{
n <- 1000    # define sample size
set.seed(17) # so can reproduce the results
age            <- rnorm(n, 50, 10)
blood.pressure <- rnorm(n, 120, 15)
cholesterol    <- rnorm(n, 200, 25)
sex            <- factor(sample(c('female','male'), n,TRUE))
label(age)            <- 'Age'      # label is in Hmisc
label(cholesterol)    <- 'Total Cholesterol'
label(blood.pressure) <- 'Systolic Blood Pressure'
label(sex)            <- 'Sex'
units(cholesterol)    <- 'mg/dl'   # uses units.default in Hmisc
units(blood.pressure) <- 'mmHg'

# Specify population model for log odds that Y=1
L <- .4*(sex=='male') + .045*(age-50) +
  (log(cholesterol - 10)-5.2)*(-2*(sex=='female') + 2*(sex=='male'))
# Simulate binary y to have Prob(y=1) = 1/[1+exp(-L)]
y <- ifelse(runif(n) < plogis(L), 1, 0)

ddist <- datadist(age, blood.pressure, cholesterol, sex)
options(datadist='ddist')

fit <- lrm(y ~ blood.pressure + sex * (age + rcs(cholesterol,4)))
Predict(fit, age, cholesterol, np=4)
Predict(fit, age=seq(20,80,by=10), sex, conf.int=FALSE)
Predict(fit, age=seq(20,80,by=10), sex='male')  # works if datadist not used
# Get simultaneous confidence limits accounting for making 7 estimates
# Predict(fit, age=seq(20,80,by=10), sex='male', conf.type='simult')
# (this needs the multcomp package)

ddist$limits$age[2] <- 30    # make 30 the reference value for age
# Could also do: ddist$limits["Adjust to","age"] <- 30
fit <- update(fit)   # make new reference value take effect
Predict(fit, age, ref.zero=TRUE, fun=exp)

# Make two curves, and plot the predicted curves as two trellis panels
w <- Predict(fit, age, sex)
require(lattice)
xyplot(yhat ~ age | sex, data=w, type='l')
# To add confidence bands we need to use the Hmisc xYplot function in
# place of xyplot
xYplot(Cbind(yhat,lower,upper) ~ age | sex, data=w, 
       method='filled bands', type='l', col.fill=gray(.95))
# If non-displayed variables were in the model, add a subtitle to show
# their settings using title(sub=paste('Adjusted to',attr(w,'info')$adjust),adj=0)
# Easier: feed w into plot.Predict, ggplot.Predict, plotp.Predict
\dontrun{
# Predictions form a parametric survival model
require(survival)
n <- 1000
set.seed(731)
age <- 50 + 12*rnorm(n)
label(age) <- "Age"
sex <- factor(sample(c('Male','Female'), n, 
              rep=TRUE, prob=c(.6, .4)))
cens <- 15*runif(n)
h <- .02*exp(.04*(age-50)+.8*(sex=='Female'))
t <- -log(runif(n))/h
label(t) <- 'Follow-up Time'
e <- ifelse(t<=cens,1,0)
t <- pmin(t, cens)
units(t) <- "Year"
ddist <- datadist(age, sex)
Srv <- Surv(t,e)

# Fit log-normal survival model and plot median survival time vs. age
f <- psm(Srv ~ rcs(age), dist='lognormal')
med <- Quantile(f)       # Creates function to compute quantiles
                         # (median by default)
Predict(f, age, fun=function(x)med(lp=x))
# Note: This works because med() expects the linear predictor (X*beta)
#       as an argument.  Would not work if use 
#       ref.zero=TRUE or adj.zero=TRUE.
# Also, confidence intervals from this method are approximate since
# they don't take into account estimation of scale parameter

# Fit an ols model to log(y) and plot the relationship between x1
# and the predicted mean(y) on the original scale without assuming
# normality of residuals; use the smearing estimator.  Before doing
# that, show confidence intervals for mean and individual log(y),
# and for the latter, also show bootstrap percentile nonparametric
# pointwise confidence limits
set.seed(1)
x1 <- runif(300)
x2 <- runif(300)
ddist <- datadist(x1,x2); options(datadist='ddist')
y  <- exp(x1+ x2 - 1 + rnorm(300))
f  <- ols(log(y) ~ pol(x1,2) + x2, x=TRUE, y=TRUE)  # x y for bootcov
fb <- bootcov(f, B=100)
pb <- Predict(fb, x1, x2=c(.25,.75))
p1 <- Predict(f,  x1, x2=c(.25,.75))
p <- rbind(normal=p1, boot=pb)
plot(p)

p1 <- Predict(f, x1, conf.type='mean')
p2 <- Predict(f, x1, conf.type='individual')
p  <- rbind(mean=p1, individual=p2)
plot(p, label.curve=FALSE)   # uses superposition
plot(p, ~x1 | .set.)         # 2 panels

r <- resid(f)
smean <- function(yhat)smearingEst(yhat, exp, res, statistic='mean')
formals(smean) <- list(yhat=numeric(0), res=r[!is.na(r)])
#smean$res <- r[!is.na(r)]   # define default res argument to function
Predict(f, x1, fun=smean)

## Example using offset
g <- Glm(Y ~ offset(log(N)) + x1 + x2, family=poisson)
Predict(g, offset=list(N=100))
}
options(datadist=NULL)
}
\keyword{models}
