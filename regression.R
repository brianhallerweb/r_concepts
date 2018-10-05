# Regression
# regression is a technique for modeling an outcome variable as a function of
# explanatory/predictor variables (also called a covariates). 
# The terms explantory and predictor are important because modeling can be done
# for both reasons - sometimes you only want to be able to make an accurate
# prediction given all the covariates and other times you want to try to
# explain a system by understanding the individual contributions of each
# covariate. 

# You can divide regression situations into 5 types
# 1. single continuous explanatory variable
# 2. single categorical explanatory variable
# 3. multiple continuous explanatory variables
# 4. multiple explanatory variable, some continuous, some categorical
# 5. Correlated explantory variables (called interaction models) 

# these are notes from the moderndive textbook and it uses a package called
# moderndive which has some simple wrapper functions designed to easily get
# residual information into a dataframe and ready for residual analysis. 
library(tidyverse)
library(moderndive)
library(skimr) # better summary stats than summary()


########################################################
# Simple linear regression with a continuous explanatory variable
# The goal of this analysis is to understand the relationship between a
# professor's appearance and their student evaluations
# We assume that better looking professors get better scores but is there
# evidence for it?
download.file("http://www.openintro.org/stat/data/evals.RData", destfile = "evals.RData")
load("evals.RData")

# quickly look at the data as univariates to get a sense of it and check for missing values
evals <- evals %>%
	as_data_frame() %>%
	select(score, bty_avg, age)
summary <- skim(evals)

# check for a correlation between beauty and teaching score
# there is a weak positive correlation, about what you would expect. 
c <- cor(x=evals$score, y=evals$bty_avg)
c # .187

# plot the relationship
plot <- ggplot(evals, aes(bty_avg, score)) + 
	geom_point(position = "jitter") +
	geom_smooth(method="lm") +
	labs(x="beauty score", y="teaching score", title="Beauty vs teaching score")

# repeat all these steps to investigate the relationship between age and score
c <- cor(x=evals$score, y=evals$age)
c # .187
plot <- ggplot(evals, aes(age, score)) + 
	geom_point(position = "jitter") +
	geom_smooth(method="lm") +
	labs(x="age", y="teaching score", title="age vs teaching score")

# create linear models
score_by_beauty_model <- lm(score~bty_avg, evals)
score_by_age_model <- lm(score~age, evals)

# These linear model reports give information on coefficients (estimate, std
# error, t, and p), residuals (summary stats for rough distribution, residual
# std error which I thihk is RMSE and an R squared adjusted value. It also
# gives an F statistic. 

# Residual analysis
# plot the residuals, They should not show any pattern with respect to the
# explanatory variable and they should be normally distributed 
# These conditions must hold for the linear regression model to have valid
# interpretations. 

# get_regression_points is a function from the moderndive package that easily
# gives a dataframe with each observation, estimate, and residual. 
residual_df <- get_regression_points(score_by_beauty_model)
# The scatter plot shows no obvious pattern with respoect to the beauty score
plot <- ggplot(residual_df) +
	geom_point(aes(bty_avg, residual))
#The histogram shows that the residuals aren't quite normal. There is some left
#skew but it is pretty close. 
plot <- ggplot(residual_df) +
	geom_histogram(aes(residual))

#############################################################
##########################################################

# Simple linear regression with a categorical explanatory variable

library("gapminder")
str(gapminder)

df <- gapminder %>%
	filter(year==2007) %>%
        select(country, continent, lifeExp, gdpPercap)	

# investigate the variables continent and lifeExp
df %>%
	select(continent, lifeExp) %>%
	skim() 

df1 <- df %>%
	   group_by(continent) %>%
	   summarize(mean=mean(lifeExp), median=median(lifeExp)) %>%
           select(continent, mean, median)



# some visualizations of continent and life expectancy
plot <- ggplot(df) +
	    geom_histogram(aes(lifeExp), binwidth=5, col="white") +
	    labs(title="worldwide life expectancy")
plot <- ggplot(df) +
	    geom_histogram(aes(lifeExp), binwidth=5, col="white") +
	    facet_wrap(~continent, nrow=5)
	    labs(title="life expectancy by continent (histograms)")
plot <- ggplot(df) +
	    geom_boxplot(aes(continent, lifeExp, fill=continent)) +
	    labs(title="life expectancy by continent (boxplots)")

# linear regression goal
# The goal is to use linear regression to see if there is evidence for a
    # difference in life expectancy relative to a baseline by continent. Notice
    # how the interpretation needs to be relative to baseline, which, in this
    # case, is arbitrarily chosen to be Africa.  

df %>%
	group_by(continent) %>%
	summarize(mean=mean(lifeExp), "mean vs Africa"=mean-54.806) %>%
	select(continent, mean, "mean vs Africa")
# This model returns an intercept and 4 coefficients. The "intercepts"
# really means africa (africa is chosen by R as default because it is first
# alphabetically. Use forcats to better handle categorical variables) and the
# other coeffiencents can be interpreted as the expected difference between
# each country and africa.
model <- lm(lifeExp~continent, df)

# The difference between ANOVA and regression is still confusing to me. I
# believe the way to understand it is that they are equivalent mathematically
# but they need to be interpreted differently. Continuous explanatory variables
# are intereted as expected change in y given unit change in x. Categorical
# explanatory variables are interpreted as an expected difference from a
# baseline. 


# Residual Analysis is the same for regression with continuous or categorical
# explanatory variables
regression_points <- get_regression_points(model)

plot <- ggplot(regression_points, aes(x = continent, y = residual)) +
  geom_jitter(width = 0.1) +
  labs(x = "Continent", y = "Residual") +
  geom_hline(yintercept = 0, col = "blue")
plot <- ggplot(regression_points, aes(x = residual)) +
  geom_histogram(binwidth = 5, color = "white") +
  labs(x = "Residual")

#############################################################
##########################################################

# Multiple Regression
# The immediate issue with multiple regression is that interetation of
# individual explanatory variables is complicated by correlations between the
# explanatory variables. 

# datasets from the book intro to statistical learning with r (ISLR)
# you should read that book, it is the practical side of Friedman's elements of
# statistical learning
# we will use the Credit dataset
library(ISLR)
glimpse(Credit)

# The goal of this multiple regression project is to predict credic card
# balance from cc limit and income

Credit <- Credit %>%
  select(Balance, Limit, Income, Rating, Age)

# summary stats
Credit %>% 
  select(Balance, Limit, Income) %>% 
  skim() %>%
  print()

# get a correlation matrix
Credit %>%
  select(Balance, Limit, Income) %>%
  cor() %>%
  print()
# The most important finding is that there is colinearity between limit and
# income (the are strongly correlated with each other)

# visualize the response variable with each explanatory variable separately
plot <- ggplot(Credit, aes(Limit, Balance)) +
	geom_point() +
	geom_smooth(method="lm")
plot <- ggplot(Credit, aes(Income, Balance)) +
	geom_point() +
	geom_smooth(method="lm")
	
# I don't think ggplot has the ability to draw 3d graphs, which is what you
# would need to visualize the "best fitting plane"

# create a multiple regression model
model <- lm(Balance ~ Limit + Income, data = Credit)
print(summary(model))
print(get_regression_table(model))

# paramter interpretations
# the intercept should not be interpreted because limit 0 and income 0 is
# extreme extrapolation 
# cc limit paramter is .26. That means that for every unit increase in cc
# limit, balance will increase .26 dollars on average. It is very important
# that you recognize this result only holds when Income is also in the model -
# So you say, taking all other variables into account... the effect of cc limit
# is...
# # the income parameter is -7.66. Taking all other variables into account, for
# every increate is one unit of income ($1000), there is an associated decrease
# of 7.66 in cc balance, on average.

# Residual analysis
# The residuals need to be random with respect to either explanatory variable
# and they should be normally distributed. 

regression_points <- get_regression_points(model)

ggplot(regression_points, aes(x = Limit, y = residual)) +
  geom_point() +
  labs(x = "Credit limit (in $)", y = "Residual", title = "Residuals vs credit limit")
  
ggplot(regression_points, aes(x = Income, y = residual)) +
  geom_point() +
  labs(x = "Income (in $1000)", y = "Residual", title = "Residuals vs income")

ggplot(regression_points, aes(x = residual)) +
  geom_histogram(color = "white") +
  labs(x = "Residual")
# Those conditions are not met

#########################################################
# Multiple Regression with two explanatory variables, one categorical and one
# continuous

# The goal is to model teaching eval score by gender and age
rm(list=ls())
evals <- evals %>%
  select(score, age, gender)

evals %>% 
  skim() %>%
  print()

# find correlation between the 2 continuous variables
print(cor(evals$score, evals$age))
# -0.107, which makes sense because older age leads to less attractiveness


