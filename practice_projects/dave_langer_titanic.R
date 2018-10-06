rm(list=ls())
library(tidyverse)
library(magrittr)
library(stringr)

#####################################
# Dave Langer Data Science course

# The goal is to build a classification model to predict survival on
# individuals on the titanic

#----------------------------------------
# import the data

train <- read_csv("/home/bsh/Downloads/train.csv") 
test <- read_csv("/home/bsh/Downloads/test.csv") 

#----------------------------------------
# clean the data 


# change Pclass, Survived, and Sex to factors
train <- train %>%
	 mutate(Pclass = as.factor(Pclass),
	        Survived = as.factor(Survived),
	        Sex = as.factor(Sex))

test <- test %>%
	 mutate(Pclass = as.factor(Pclass),
	        Sex = as.factor(Sex))

# combine data sets
combined <- train %>%
	bind_rows(test)

# rename the variables to lower snake
train <- train %>%
    rename("survived" = Survived,
	   "p_class" = Pclass,
	   "name" = Name, 
	   "sex" = Sex,
	   "age" = Age,
	   "sib_sp" = SibSp,
	   "par_ch" = Parch,
	   "ticket" = Ticket,
	   "fare" = Fare,
	   "cabin" = Cabin,
	   "embarked" = Embarked)
test <- test %>%
    rename("p_class" = Pclass,
	   "name" = Name, 
	   "sex" = Sex,
	   "age" = Age,
	   "sib_sp" = SibSp,
	   "par_ch" = Parch,
	   "ticket" = Ticket,
	   "fare" = Fare,
	   "cabin" = Cabin,
	   "embarked" = Embarked)
combined <- combined %>%
    rename("survived" = Survived,
	   "p_class" = Pclass,
	   "name" = Name, 
	   "sex" = Sex,
	   "age" = Age,
	   "sib_sp" = SibSp,
	   "par_ch" = Parch,
	   "ticket" = Ticket,
	   "fare" = Fare,
	   "cabin" = Cabin,
	   "embarked" = Embarked)

# check to see if there are any accidental duplicates by checking for 
# duplicate names
unique_names_count <- combined %>%
	summarize(unique_names = n_distinct(name), 
		  total_names = n())
# yes there are 2 duplicate names
# check if they are unique people or errors in the data
duplicate_names <- combined %>%
        filter(duplicated(name)) %>%
	select(name)
# alternative solution
#duplicate_names <- combined %>%
#        group_by(as.factor(name)) %>%
#        filter(n()>1) 
duplicates <- combined %>%
	filter(name %in% duplicate_names$name)
# they are unique people who just happen to share the same name

########################################
#---------------------------------------
# Exploratory data analysis

# look at the distribution of Survived
survived_dist <- combined %>%
	filter(!is.na(survived)) %>%
	group_by(survived) %>%
	summarize(count = n())

plot <- combined %>%
	filter(!is.na(survived)) %>% 
	ggplot() +
        geom_bar(aes(survived))

# look at the distribution of p_class
p_class_dist <- combined %>%
	group_by(p_class) %>%
	summarize(count = n()) 
plot <- ggplot(combined) +
        geom_bar(aes(p_class))

# look at the distribution of survived by p_class
# I need to improve this. I had to make 3 separate tables which is not right. 
survived_pclass1_dist <- combined %>%
	filter(!is.na(survived), p_class == 1) %>%
	group_by(survived) %>%
        summarize(count = n())


survived_pclass2_dist <- combined %>%
	filter(!is.na(survived), p_class == 2)  %>%
	group_by(survived) %>%
        summarize(count = n())

survived_pclass3_dist <- combined %>%
	filter(!is.na(survived), p_class == 3)  %>%
	group_by(survived) %>%
        summarize(count = n())

plot <- combined %>%
	filter(!is.na(survived)) %>%
	ggplot() +
        geom_bar(aes(p_class, fill=survived))

# look at survived by sex and p_class
plot <- combined %>%
	filter(!is.na(survived)) %>%
	ggplot() +
        geom_bar(aes(sex, fill=survived), position="fill") +
	facet_wrap(~p_class)

# look at the name titles (Mr, Mrs, Master, Miss)
mr <- combined %>%
        filter(str_detect(name, " Mr. ")) %>%
	select(name)
mrs <- combined %>%
        filter(str_detect(name, " Mrs. ")) %>%
	select(name)

master <- combined %>%
        filter(str_detect(name, " Master. ")) %>%
	select(name)

miss <- combined %>%
        filter(str_detect(name, " Miss. ")) %>%
	select(name)

# Are those the only 4 titles?
test <- nrow(combined) == (nrow(mr) + nrow(mrs) + nrow(master) + nrow(miss))
# False, but why? 
# there are 34 rows without mr mrs master or miss titles
# there are some other titles (like Dr.) but they all seem to be relatively
# rare so I will disregard them by calling them "Other"

# make a new column for title
extract_title <- function(name) {
	if(grepl(" Mr. ", name)){
            return("Mr.")
	}
	if(grepl(" Mrs. ", name)){
            return("Mrs.")
	}
	if(grepl(" Master. ", name)){
            return("Master.")
	}
	if(grepl(" Miss. ", name)){
            return("Miss.")
	}
	return("Other")
}

titles <- vector("character", nrow(combined))
for(i in 1:nrow(combined)){
    titles[i] = extract_title(combined$name[i])
}

combined <- combined %>%
	mutate(title = as.factor(titles))

###########################
# working with ages


# distribution of ages by title
# master is a proxy for young males
# The distribution is pretty uniform from 0 to 15
plot <- ggplot(combined) +
	geom_histogram(aes(age), col="white", binwidth=1) +
	facet_wrap(~title)
# master age dist
age_dist <- combined %>%
	filter(title == "Master.") %$%
	summary(age)

# plot of survived by title and by pclass
plot <- combined %>%
        filter(!is.na(survived)) %>%	
	ggplot() +
	geom_bar(aes(p_class, fill=survived), position="fill") +
	facet_wrap(~title)

# plot of survived by age, sex, and class
plot <- combined %>%
	filter(!is.na(survived)) %>%
	ggplot() +
	geom_histogram(aes(age, fill=survived), col="white", binwidth=5) +
	facet_wrap(sex~p_class)

# There are a lot of missing values in age
# you could use a model to predict - imputation 
# you could also find a proxy - If the missing value has a title="Master." then
# you know the age is young
# there are 8 missing values for "Master."

# there are other proxies for age as well - sib_sp and par_ch
# Those variables are also interesting in their own right. They allow for fine
# grained analysis like the survivability of a young male with many siblings in
# 3rd class. 

###################################
# sib_sp par_ch

# feature engineering family size
# A reasonable hypothesis is that people would be less likely to survive
# if they came from big families

# create the family size variable
combined_with_family_size <- combined %>%
	mutate(family_size = as.factor(1 + sib_sp + par_ch))

# bar plot of family size
plot <- ggplot(combined_with_family_size) +
	geom_bar(aes(family_size))

plot <- combined_with_family_size %>%
        filter(!is.na(survived)) %>%	
	ggplot() +
	geom_bar(aes(family_size, fill=survived), position="fill") +
	facet_wrap(p_class~title)

####################################
# ticket
# There doesn't appear to be any structure in the ticket names but you 
# can explore it in much more sophisticated ways than just looking at the
# values.

# extract the first letter, convert to factor, then plot vs survival, p_class,
# etc. 
# patterns will start to emerge - and even if the patterns don't immediately
# make narrative sense, they may help a model to make accurate predictions

# however, overall, ticket isn't great and so you should leave it out of the
# modeling 

#####################################
# fare

plot <- combined %>%
	filter(!is.na(survived)) %>%
        ggplot() +
	geom_histogram(aes(fare, fill=survived), position="fill", col="white")
# as expected, this plot shows the strong relationship between ticket price and 
# survived
# however it is likely redundant with pclass so we won't use fare in modelling
# either, at least not initally. 

################################
# cabin

# there a lot of missing values
# the first letter of the cabin is probably the deck level so you could get
# that first level and do some visualizations

# once again, cabin and p_class are redundant so we will leave out cabin too

################################
# embarked (the city where people boarded)
# it is intuitively unlikely and the plot doesn't show much so skip it

#########################
#####################
# so this is the end of the data analysis. The major lesson is that you want to 
# spend a lot of time in this stage in order to develop a feel and intuition
# for the data. That understanding will inform your feature engineering and the 
# variables you would like to try to use in modeling. 
##########################
#########################



#######################################################
# exploratory modeling 
# these are simple and fast inital models that do feature selection
# logistic regression and random forests are common

# feature selection is when ml algos are able to determine which features are
# important
# so exploratory modeling can supplement our data analysis in figuring out
# which variables matter
# you can even start the process with exploratory modeling
# it can also be used to support the intuition we used in feature engineering
# (is family_size important?)

################################
# random forests
# It sounds like random forests make a whole bunch of trees by randomly
# selecting some columns and some rows. The rows that aren't selected are
# called OOB (out of bag)

library(randomForest)

# random forests have hyperparameters for tuning but R defaults are pretty good

## train a random forest with p_class and title
#rf_train <- combined %>%
#	filter(!is.na(survived)) %>%
#	select(p_class, title)
#rf_label <- combined %>%
#	filter(!is.na(survived)) %>%
#	select(survived)
#
#rf_model <- randomForest(x=rf_train, y=rf_label$survived, importance=TRUE, ntree=1000)
#print(rf_model)
## how to read the confusion matrix 
## rows are true survival and columns are predicted survival
## The model is much better at predicting dead than lived. That is expected
## because there are roughly twice as many dead than lived in the training data 
## The model is better than just predicting everyone died but not all that much
## better. 
#
#print(varImpPlot(rf_model))
## how to read the plot
## MeanDecreaseGini shows the importance of features. The further right, the
## more important. 
#
## add sib_sp to the rf 
#rf_train <- combined %>%
#	filter(!is.na(survived)) %>%
#	select(p_class, title, sib_sp)
#rf_label <- combined %>%
#	filter(!is.na(survived)) %>%
#	select(survived)
#rf_model <- randomForest(x=rf_train, y=rf_label$survived, importance=TRUE, ntree=1000)
#print(rf_model)
#print(varImpPlot(rf_model))
## it is now better because sib_sp is predictive
#
## add par_ch to the rf 
#rf_train <- combined %>%
#	filter(!is.na(survived)) %>%
#	select(p_class, title, sib_sp, par_ch)
#rf_label <- combined %>%
#	filter(!is.na(survived)) %>%
#	select(survived)
#rf_model <- randomForest(x=rf_train, y=rf_label$survived, importance=TRUE, ntree=1000)
#print(rf_model)
#print(varImpPlot(rf_model))
## it now even better

# rf with p_class, title, and family_size
# sometimes it is helpful to the algo to combine 2 features into one
rf_train <- combined_with_family_size %>%
	filter(!is.na(survived)) %>%
	select(p_class, title, family_size)
rf_label <- combined_with_family_size %>%
	filter(!is.na(survived)) %>%
	select(survived)
rf_model <- randomForest(x=rf_train, y=rf_label$survived, importance=TRUE, ntree=1000)
print(rf_model)
print(varImpPlot(rf_model))
# he says this is the best model but mine is a little worse than sib_sp and
# par_ch separate


# summary of random forest modeling 
# It appears that this simple random forest algo is good enough to get you near
# the top of the kaggle competition (it is actally a little lower because we
# haven't used cross validation yet). All we did was some simple analysis and
# feature engineering for title and family size but those choices were more
# influential than picking fancy algos and tuning them. 

###############################
# Cross Validation
# the purpose is to maximize the utility of training data and to measure the 
# accuracy of the model on unseen data
# there are other methods of evaluating models but cross validation is really
# the standard

# the recommendation is to do 10 fold cross validation and to repeat that 10
# times. That means something like this: break the training data into 10 parts
# train the model 10 times, using 1 part as test data each time. I guess the 
# idea is to manufacture a test data set without sacrificing any of your
# training data. The repitition is probably just to reduct the effect of random
# chance. This process gets computationally intensive really quickly so there
# are packages to help R get beyond its single threaded design and use all the
# cores on your cpu. 
# he is using doSNOW because it can work on windows but I think doMC is more 
# popular on mac and linux
# I think a fold means to break the training data into 10 sets
# So 10 fold cv repeated 10 times means that we need 100 total folds

# overfitting is an extremely common problem because you can use lots of
# variables
# and do lots of feature engineering in order to pump up the training data
# accuracy. That will likely result in overfitting, and surprisingly poor
# performance on new data. 

# kaggle test data
# they give you a test data to allow you cross validate your models but then
# they keep a secret test data set to actually judge the competition. I think
# the leaderboard is for the public test data set so you will see unreasonably 
# good scores on the leaderboard. 
# it is very common for people to drop hundreds of places in the competition
# because they have overfit their model.

# learn more about cross validation from jeff leek
# he has a good data analysis course from coursera that is on youtube
###############################

# cross validation on the random forest model

rf_test <- combined_with_family_size %>% 
	filter(is.na(survived)) %>%
	select(p_class, title, family_size)

# predict survival with the model
rf_preds <- predict(rf_model, rf_test)

rf_preds <- tibble(id = rep(892:1309), survived=rf_preds)
# this dataframe is what you would write to a csv in order to submit to kaggle

# caret package
library(caret)

# max kuhn wrote the package and an excellent book called applied predictive
# modeling

# caret has a family of functions used for splitting training data (folding)
# it also does stratified sampling (deals with the skew problem of survived)

set.seed(2348) #start randomization algo at the same point 

# createMultiFolds will return a list of 100 vectors. Each vector has a fold
# number (1-10) and a rep number (1-10). The fold number is 1 of the 10 in "10
# fold cv". The rep number is the rep in "repeat 10 times". So there are a
# total of 100 samples, each sample being 9/10ths the size of the training data
# set (about 800). The stratified nature of these samples should preserve the
# general pattern of about 2/3rds dead to 1/3 lived.  
# Each sample contains the indeces of people in rf_label$survived
cv_10_folds <- createMultiFolds(rf_label$survived, k=10, times=10)

# the distribution of survived in the training data
table(rf_label$survived)

# the distribution of survived in one sample
# this should look similar to the entire distribution in the training data
table(rf_label$survived[cv_10_folds[[33]]])
# it does look similar

# now we need to set up caret to use those folds to train for our cross
# validation
# the trainControl() function created a trainControl object
# this says to train a model using repeated cross validation (10 folds repeated
# 10 times) using this collection of 100 samples
ctrl <- trainControl(method="repeatedcv", number=10, repeats=10, index=cv_10_folds)

# now train the model
# rf means random forest
# This code essentially does the same random forest we did before but does it
# 200,000 times and checks its accuracy against the unsampled data
################
# commended out so it doesn't run again
#rf_cv <- train(x=rf_train, y=rf_label$survived, method="rf", tuneLength=2, ntree=1000, trControl=ctrl)
##################
# it took about 3 minutes to run and it predicted about the same level of
# accuracy as the OOB estimate from the rf algorithm. 
# We know that is an overestimate because kaggle says so (81% vs 79%)
# that means we are still overfitting to some degree. That may be happening
# because we are still using too much training data. A way to reduce that is to
# use a smaller number of folds. Rather than using 9/10ths of the data, we
# could use 4/5ths of the data
cv_5_folds <- createMultiFolds(rf_label$survived, k=5, times=10)
ctrl <- trainControl(method="repeatedcv", number=5, repeats=10, index=cv_10_folds)
rf_cv <- train(x=rf_train, y=rf_label$survived, method="rf", tuneLength=2, ntree=1000, trControl=ctrl)
# no change
# we want to be more pessimistic in our prediction of accuracy. 
# you could reduce the folds further... he recommends 3 but even that doesn't
# bring it down to 79% - it stays about 81%


###############################################
# Decision tree
# using a single decision tree instead of a random forest can lead to clearer
# results

# CART algorithm
# the package for CART trees is called rpart

########## 10/5 I finished watching all the lectures but these notes stop at
###the beginning of the 5th video. The 5th and 6th videos do more feature
###engineering to slightly improve the random forest model. The major technique
###used was to use a single tree to understand how decisions were made in the
###model. This process revealed some problems with the title "Other." Doing a
###little extra feature engineering on title improved the model. Then there
###were a couple more improvements in a similar vein. Finally, the model was
###submitted to Kaggle and performed at least as good as the top quarter of
###competitors. 

# I would like to go back through this material again, create a pretty
# rmarkdown report, and submit to kaggle
