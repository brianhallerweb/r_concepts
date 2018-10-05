rm(list=ls())

library(tidyverse)
library(modelr) #a package that wraps base R models and provides some nice 
# functions for typical the typical tidyverse workflow with pipes.

##############################################
# Modeling basics from R for data science

# This book only offers a high level overview of modeling. But I still learned
# a few things.

# 1. models for exploration vs confirmation
# Models are typically thought about as confirming a hypothesis but they are
# very good tools for exploring data as well. To properly confirm a hypothesis,
# you have to reserve test data and honestly only use that test data once. It
# is always possible to overfit a model to your data through repeated tweaking,
# but that isn't confirmation of its accuracy on unseen data

# 2. Two approaches to model selection. 
# The classic approach is to use math theory (general linear models). However,
# you can also do something like this - generate a lot of random models and
# test each one, picking the one that performs best. As you would imagine, the
# second approach becomes very sophisticated - much more so than just creating
# a large number of random models. One step beyond randomization is to do a
# "grid search". I don't understand the technique very well but the basic idea
# is to generage something like a uniform distribution of all possible models
# (then test each one to find the optimum) 

# 3. pattern and residuals
# At the highest level, models are simple low dimensional summaries of data
# that can be partitioned into pattern and residual. The typical pattern is to
# transform and visualize data until you an implicit understanding of the system,
# then to make that implicit knowledge explicit.

# 4. Put predictions and residuals into a data frame.
# The cycle of tranform and visualize should be applied to models as well as
# original datasets. Visualizing both pattern and residual is very helpful for
# understanding the lessons of a model and avoiding common misinterpretations.
# modelr has useful functions for getting predictions and residuals into a
# dataframe. The examples below show how to do that.  


##############################
# one continuous predictor

# the sim datasets are intented to provide data that follows simple patterns
# visualize the data
plot <- ggplot(sim1) +
	geom_point(aes(x,y))

# create a model
sim1_mod <- lm(y~x, data = sim1)

# add model predictions and residuals to original data set and then visualize
plot <- sim1 %>%
	add_predictions(sim1_mod) %>%
	add_residuals(sim1_mod) %>%
	ggplot()+
	geom_point(aes(x,y))+
	geom_line(aes(x,pred), col="red")
plot <- sim1 %>%
	add_predictions(sim1_mod) %>%
	add_residuals(sim1_mod) %>%
	ggplot()+
	geom_freqpoly(aes(resid), binwidth=1.5)
# the predictions obviously form a typical regression line and the residuals
# are normal and show no correlation with the x values - which is everything
# you would expect from modeling such a simple dataset.

######################
# one categorical predictor

# sim2 is a dataset with continuous y and categorical x
sim2_mod <- lm(y~x, data = sim2)

# data_grid() creates a data frame of every combination of variables it is
# given. In this situtation, it just creates a single row for each value of x
# (a,b,c, and d)
# The data_grid() method is useful for creating model prediction data because it allows you to
# create a more complete dataset for the model (you aren't limited to only the
# points included in the original dataset). However, the residuals can only be
# calculated for the original data set because you obviously need the actual
# values to calculate the residuals. 
grid <- sim2 %>%
	data_grid(x) %>%
	add_predictions(sim2_mod)

plot <- ggplot(sim2) +
	geom_point(aes(x, y)) +
	geom_point(data=grid, aes(x, pred), col="red", size=3)

##########################
# continuous and categorical predictors 
# sim3 contains both continuous and categorical predictors

# just plot the data
plot <- ggplot(sim3) +
	geom_point(aes(x1, y, col=x2))

# the major question in modeling is whether there is an interaction between x1
# and x2. 
# you can fit both models (non interaction and interaction) and then compare
# them

sim3_mod1 <- lm(y~x1+x2, data=sim3)
sim3_mod2 <- lm(y~x1*x2, data=sim3)

# creating a model df 
# spread_predictions allows for putting multiple model predictions into 1 df
# spread_predictions() puts each model in a column, gather_predictions() puts
# each model on rows. If that is confusing, just try both functions, print the 
# data, and you'll see it isn't complicated. 
grid <- sim3 %>%
	data_grid(x1, x2) %>%
	gather_predictions(sim3_mod1, sim3_mod2)

plot <- ggplot(sim3) +
	geom_point(aes(x1, y, col=x2)) +
	geom_line(data=grid, aes(x1, pred, col=x2)) +
	facet_wrap(~model)

# The plots show clearly improved performance for the interaction model but we
# should also look at the residuals
sim3 <- sim3 %>%
	gather_residuals(sim3_mod1, sim3_mod2)

plot <- ggplot(sim3) +
	geom_point(aes(x1, resid, col=x2)) +
	facet_grid(model~x2)
# The residuals in model 2 are also much better

####################################
# two continuous predictors with interactions
# the question is whether to include interactions or not

# create both models, one with interactions, one without
sim4_mod1 <- lm(y~x1+x2, sim4)
sim4_mod2 <- lm(y~x1*x2, sim4)

# create a df of predictions from the models
# the seq_range() function will create 5 values from min to max
grid <- sim4 %>%
	data_grid(x1=seq_range(x1,5), 
		  x2=seq_range(x2,5)
		  ) %>%
        gather_predictions(sim4_mod1, sim4_mod2)

# it is then possible to create a 3d visualization but they seem bad to me
# you can either look at it from the "top" or "side"
# there isn't a nice way to visualize the plane. 

###########################################
# this is the end of the first chapter in the models section

