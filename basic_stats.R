rm(list=ls())
library(tidyverse)
library(mosaic)
library(infer)
library(moderndive)
library(skimr)

####################################################
# how to take samples 

# sample_n() is a dplyr function

# rep_sample_n() is a function from the moderndive package that allows you to
# take multiple samples for creating bootstrapped sampling distributions. It
# returns a df with a replicate column to inicate which sample a value belongs
# to

# To sample from common probability distributions, use rnorm() (or other dist)
# a single random sample from a standard normal
sample <- tibble(num=rnorm(999))
print(skim(sample))
print(ggplot(sample) +
      geom_histogram(aes(num)))

# there is also a sample() function

################################################
# Confidence intervals for mean 

# The pennies dataset from moderndive. It includes year and age_in_2011 of a
# population of pennies. 
# pennies_sample is a sample of size 40

# base R would have you simple do this
t.test(pennies_sample$age_in_2011)
# But you can do it in a more manual way
 
###############
# confidence interval for the mean age_in_2011

# true mean
true_mean <- pennies %>%
    summarize(true_mean = mean(age_in_2011))
true_mean # 21.2

# calculate x_bar and se
estimates <- pennies_sample %>%
	summarize(x_bar = mean(age_in_2011),
		  se = sd(age_in_2011)/sqrt(n()), 
	          conf = 1.96,
		  lower_ci = x_bar - conf*se,
		  upper_ci = x_bar + conf*se)
print(estimates)
 

################
# bootstrapped sampling distribution for the mean
# take 999 samples of 40
bootstrap_999 <- pennies_sample %>% 
  rep_sample_n(size = 39, replace = TRUE, reps = 1000)

# find the mean for each of those 999 samples
# the distribution of those means is the bootstrap sampling distribution
mean_by_sample <- bootstrap_999 %>%
	group_by(replicate) %>%
	summarize(mean=mean(age_in_2010)) 

# visualize the bootstrap sampling distribution
# the confidence interval could be found by finding upper and lower percentiles
# I did that in the proportion example
plot <- ggplot(mean_by_sample)+
      geom_histogram(aes(mean), binwidth=0, col="white")


###############################################se
# Confidence intervals for proportion

# The bowl dataset comes from moderndive and it is a virtual bowl of red and white balls

##########
# Traditional inference about proportion of red balls

# find the true proportion
true_p <- bowl %>%
    summarize(true_p = sum(color=="red")/n())
# print(true_p) #.375

# take a sample of 50
sample_50 <- bowl %>%
	select(color) %>%
	sample_n(50)

# calculate p_hat and se
estimates <- sample_50 %>%
	summarize(p_hat = sum(color=="red")/n(),
		  se = sqrt(p_hat*(1-p_hat)/n()), 
	          conf = 1.96,
		  lower_ci = p_hat - conf*se,
		  upper_ci = p_hat + conf*se
) 

#############
# Inference from a bootstrapped sampling distribution

# bootstrap a sampling distribution of the bowl dataset
sample_dist_50 <- bowl %>%
	rep_sample_n(size=50, reps=1000, replace=T) %>%
	group_by(replicate) %>%
	summarize(p_hat=sum(color=="red")/n()) %>%
        mutate(percentile=ntile(p_hat,100))

# create a "summary" df of the boostrap sampling distribution.
# "summary" has columns for mean, lower bound (2.5 percentile), 
# and upper bound (97.5 percentile)
# this code is sloppy but I couldn't figure out how to do it better. 
mean <- mean(sample_dist_50$p_hat) 
lower_bound <- sample_dist_50 %>%
	filter(percentile == 2 | percentile == 3) %>%
        summarize(lower_bound = mean(p_hat), 
)
lower_bound = lower_bound$lower_bound
upper_bound <- sample_dist_50 %>%
	filter(percentile == 97 | percentile == 98) %>%
        summarize(upper_bound = mean(p_hat), 
)
upper_bound = upper_bound$upper_bound
summary <- tibble(mean, lower_bound, upper_bound)

# create a plot of the bootstrap sampling distribution, including
# vertical lines that show the confidence interval
plot <- ggplot(sample_dist_50) +
	geom_histogram(aes(p_hat), binwidth=.02, col="white") +
	geom_vline(data=summary, aes(xintercept=mean)) +
	geom_vline(data=summary, aes(xintercept=lower_bound), col="red") +
	geom_vline(data=summary, aes(xintercept=upper_bound), col="red")
         

#######################################
# Hypothesis Testing

# "there is only one test" framework, by Allen Downey
# his examples use python so this is just an aside

# The "there is only one test" framework says all tests involve
# calculating  a test statistic from observed data and then comparing
# that test statistic against a model of the null hypthesis. 
# The p value is the probably of observing your test statistic,
# or one more extreme, assumming the truth of the null. 

# How do you get a model of the null? The best way by far is 
# simulation because it is programmatically easy and doesn't
# require memorization of the assumptions behind traditional
# theoretical methods. 

# How to generate simulated data?
# the example is for before and after test scores
# did mean test scores improve? The null hypothesis is no. 
# The test statistic is d, difference between before and after 
# tests.
# first you want to generate a fake_exam(pc, num_questions)
# for each student
# you will get pc from the before test from the sample  
# then, fake_diff() will generate 2 fake exams and calculate
# the difference. Both fake exams will contain the same 
# probability of correct answers for each student, therby
# simulating the data under the null hypothesis. 
# next, you run fake_diffs(pcs, num_questions) for the
# entire class. That will give you one simulated distribution 
# of statistics under the null hypothesis for you to compare 
# the observed difference to. 
# finally, you run p_value(delta, pcs, num_questions, iterations=1000)
# p_value must wrap fake_diffs()
# p_value will run fake_diffs 1000 times and take the mean 
# difference for each student and iterate a counter if it is
# equal to or greater than the observerd difference (delta)

# what makes this framework remarkable is that the simulation
# avoids the difficult questions about the assumptions required
# for using statistical theory. Simulation takes all those concerns
# into account automatically. You never have to break out of 
# thinking about the problem (the statistic you want to use and
# how to model the null) to think about statistical theory. 

# another benefit to simulation
# say you wanted to test median score difference instead of mean
# it is just one little change in the code

# The only reason to use traditional statistical theory is for
# speed. The methods are not more accurate and they require
# careful checking of assumptions

# when to use simulation vs theoretical techniques
# 1. start with simulation
# 2. if fast enough, you are done
# 3. otherwise, look for theoretical shortcuts
# 4. and use your simulation as a sanity check
####################################################

# The infer package follows the logic of "there is only one test"

# hypothesis test for difference between 2 means
# Are action movies rated higher than romance on IMBD? 

# looking at the population data
movies_trimmed <- movies %>% 
  filter(!(Action == 1 & Romance == 1)) %>%
  mutate(genre = case_when(Action == 1 ~ "Action",
                           Romance == 1 ~ "Romance",
                           TRUE ~ "Neither")) %>%
  filter(genre != "Neither") %>%
  select(title, year, rating, genre)

plot <- ggplot(movies_trimmed) +
	geom_boxplot(aes(genre, rating))
# romance is rated a little higher than action
# now do a statistical test to see if we find the same thing

# take a sample of 34 movies
movies_genre_sample <- movies_trimmed %>% 
  group_by(genre) %>%
  sample_n(34) %>%
  ungroup()

summary <- movies_genre_sample %>% 
  group_by(genre) %>%
  summarize(mean = mean(rating),
            std_dev = sd(rating),
            n = n())

plot <- ggplot(movies_genre_sample) +
	geom_boxplot(aes(genre, rating))
# It looks like there is evidence for romance being about 1 point higher

# calculate observed difference in means
obs_diff <- movies_genre_sample %>% 
  specify(formula = rating ~ genre) %>% 
  calculate(stat = "diff in means", order = c("Romance", "Action"))

# Now the tricky part - simulating the mean under the null 
# This is a simulation of one sample. The idea is that becaue 
# the null hypothesis says that both genres are the same, we 
# can suffle all the cards and then randomly assign the genre.
shuffled_ratings_old <- movies_genre_sample %>%
     mutate(genre = mosaic::shuffle(genre)) %>%
     group_by(genre) %>%
     summarize(mean = mean(rating))
# this is the "infer" way of doing to same thing
permuted_ratings <- movies_genre_sample %>% 
  specify(formula = rating ~ genre) %>% 
  generate(reps = 1)

# The full "infer" way of creating a null distribution of d and
# visualizing it along with the critical regions
null_distribution_two_means <- movies_genre_sample %>% 
  specify(formula = rating ~ genre) %>% 
  hypothesize(null = "independence") %>% 
  generate(reps = 5000) %>% 
  calculate(stat = "diff in means", order = c("Romance", "Action"))
print(null_distribution_two_means %>% visualize(bins = 100, obs_stat = obs_diff, direction = "both"))
# find the p value
print(null_distribution_two_means %>% get_pvalue(obs_stat = obs_diff, direction = "both"))

# So, as expected, we conclude that there is a difference between
# mean rating for romance and action. 

# Now create a CI
# you only have to remove the hypothesize() function 
# a bootstrap distribution is created (genre isn't shuffled)
percentile_ci_two_means <- movies_genre_sample %>% 
  specify(formula = rating ~ genre) %>% 
  generate(reps = 5000) %>% 
  calculate(stat = "diff in means", order = c("Romance", "Action")) %>%  get_ci()
print(percentile_ci_two_means)
# So, as expected, Romance is gets about 1 point higher ratings





