rm(list=ls())
library(tidyverse)
library(infer)
library(moderndive)
library(skimr)

# The bowl dataset
# Bowl comes from moderndive and it is a virtual bowl of red and white balls

# create the sampling distribution for the proportion of red balls
samp_dist_50 <- bowl %>%
	rep_sample_n(size=50, reps=1000) %>%
	group_by(replicate) %>%
	summarize(red=sum(color=="red")) %>%
	mutate(prop_red=red/50)

samp_dist_50 %>%
	summarize(mean=mean(prop_red),
		  standard_error=sd(prop_red)) %>%
        print() # mean is approx .37 and se is approx .06

print(ggplot(samp_dist_50) +
    geom_histogram(aes(prop_red), binwidth=.05))

# Notice how increasing the sample size, decreases the standard error
# likewise, decreasing the sample size will increase the standard error
samp_dist_100 <- bowl %>%
	rep_sample_n(size=100, reps=1000) %>%
	group_by(replicate) %>%
	summarize(red=sum(color=="red")) %>%
	mutate(prop_red=red/100)

samp_dist_100 %>%
	summarize(mean=mean(prop_red),
		  standard_error=sd(prop_red)) %>%
        print() # mean is approx .37 and se is approx .04

print(ggplot(samp_dist_100) +
    geom_histogram(aes(prop_red), binwidth=.05))
    

####################################################
# how to take samples 

# rep_sample_n() is just a wrapper function from the moderndive package

# To sample from common probability distributions, use rnorm() (or other dist)
# a single random sample from a standard normal
sample <- tibble(num=rnorm(1000))
print(skim(sample))
print(ggplot(sample)+
      geom_histogram(aes(num)))

# to sample from a distribution you created, use the sample() function

################################################
# Bootstraping a sampling distribution (resampling with replacement)

# modern dive has a sample of 40 pennies. Find the mean age (as of 2011) of ALL
# pennies

# visualize the sample
print(skim(pennies_sample))
print(ggplot(pennies_sample)+
      geom_histogram(aes(age_in_2011), binwidth=1, col="white")
)

# take 1000 samples of 40
bootstrap_1000 <- pennies_sample %>% 
  rep_sample_n(size = 40, replace = TRUE, reps = 1000)

# find the mean for each of those 1000 samples
# the distribution of those means is the bootstrap sampling distribution
mean_by_sample <- bootstrap_1000 %>%
	group_by(replicate) %>%
	summarize(mean=mean(age_in_2011)) 

# visualize the bootstrap sampling distribution
bsd_mean <- mean(mean_by_sample$mean)
bsd_sd <- sd(mean_by_sample$mean)
print(ggplot(mean_by_sample)+
      geom_histogram(aes(mean), binwidth=1, col="white") +
      geom_vline(xintercept=bsd_mean) +
      geom_vline(xintercept=bsd_mean + bsd_sd, linetype="dashed", color="red") +
      geom_vline(xintercept=bsd_mean - bsd_sd, linetype="dashed", color="red") 
)


##########################################################
# The infer package, created by Andrew Bray
# statistical inference for the tidyverse

# Traditionally, to do a test of the mean age of pennies, you
# would just pass the sample to the t.test function.
print(t.test(pennies_sample$age_in_2011))
# Infer doesn't use theoretical sampling distributions. It uses 
# computational methods instead, like permutations or bootstrapping.
# Also infer has a dplyr-like way of building up tests that makes the 
# whole process more transparent and easier to reason about. 

# specify(formula=...) is for selecting the variables
# There are 2 notations but the "formula" notation is preferred. 
pennies_sample %>%
    specify(formula=age_in_2011~NULL)

# generate(reps=..., type=...) is for techniques like bootstrapping
thousand_bootstrap_samples <- pennies_sample %>%
    specify(formula=age_in_2011~NULL) %>%
    generate(reps=1000)
print(thousand_bootstrap_samples)
# now we have a tibble of 1000 samples, each of size n

# calculate() is for condensing each sample down to a single stat
bootstrap_distribution <- pennies_sample %>%
    specify(formula=age_in_2011~NULL) %>%
    generate(reps=1000) %>%
    calculate(stat="mean")
print(bootstrap_distribution)

# visualize() produces a historgram of the stat variable in
# bootstrap_distribution. It shows the bootstrap distribution for x bar

# but first, you can use specify and and calculate to nicely compute x_bar
# of the original sample. This step could also be done with dplyr summarize()
x_bar <- pennies_sample %>%
	specify(age_in_2011~NULL) %>%
	calculate(stat="mean")

plot <- pennies_sample %>%
    specify(formula=age_in_2011~NULL) %>%
    generate(reps=1000) %>%
    calculate(stat="mean") %>%
    visualize(obs_stat=x_bar)
print(plot)

# get_ci() will get a confidence interval
ci <- pennies_sample %>%
    specify(formula=age_in_2011~NULL) %>%
    generate(reps=1000) %>%
    calculate(stat="mean") %>%
    get_ci(level=.95, type="percentile")
print(ci)

# visualize the ci
plot <- pennies_sample %>%
    specify(formula=age_in_2011~NULL) %>%
    generate(reps=1000) %>%
    calculate(stat="mean") %>%
    visualize(endpoints=ci, direction="between")
print(plot)

# The traditional multiplier (1.96) times standard error based method of
# finding a ci can also be used. Think of it as a shortcut to finding the real
# percentile based confidence interval. It works fine when the sampling
# distribution is close to normal. 
ci <- pennies_sample %>%
    specify(formula=age_in_2011~NULL) %>%
    generate(reps=1000) %>%
    calculate(stat="mean") %>%
    get_ci(level=.95, point_estimate=x_bar, type="se")
print(ci)

#############################################
# practice single proportion test 
# what is the proportion of red balls in the bowl dataset?
proportion_true <- bowl %>%
	summarize(p=sum(color=="red")/n())
print("true proportion")
print(proportion_true) #.375

# use a sample to estimate proportion
sample <- bowl %>%
	sample_n(50) %>%
	select(color)
print(sample)

p_hat <- sample %>%
	specify(color~NULL, success="red") %>%
	calculate(stat="prop")
print("p_hat")
print(p_hat) #approx .3
		  
bootstrap_props <- sample %>%
    specify(color~NULL, success="red") %>%
    generate(reps=1000) %>%
    calculate(stat="prop")

proportion_ci <- bootstrap_props %>% 
    get_ci(level=.95, type="percentile")
print("proportion ci")
print(proportion_ci)

proportion_ci_plot <- bootstrap_props %>%
    visualize(bins=25, endpoints=proportion_ci, direction="between")
print(proportion_ci_plot)
####################################
# bray lecture on infer
load("gss.Rda")
gss <- gss %>%
	select(party, NASA)

# this plot shows that republicans might favor giving NASA more money.
ggplot(gss) +
      geom_bar(aes(party, fill=NASA), position="fill")

# But is the difference between politcal parties statistically significant?
# This is contingency table inference with the chi square distribution 
# R has chisq.test() but the arguments are inconsistent with other tests and
# they moving the data out of the dataframe structure. 
# Also, the base R statistical tests are like black boxes. It would be better
# if the code was a little more transparent to encourage good reasoning while 
# building tests. 

# you can divide tests into classical mathemtical tests and modern
# computational tests. They are both useful but I think infer uses entirely computational tests. 
# those computational tests are primarily permutation and bootstrapping. I need
# to learn about permutation tests.

# 5 verbs
# specify()
# hypothesize()
# generate()
# calculate()
# visualize()

#plot <- gss %>%
#	specify(NASA ~ party) %>%
#	hypothesize(null = "independence") %>%
#	generate(reps = 1000, type = "permute") %>%
#	calculate(stat = "Chisq") %>%
#       	visualize()
#print(plot)




