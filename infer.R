rm(list=ls())

library(tidyverse)
library(infer)
library(moderndive)
library(skimr)

# The infer package
# created by Andrew Bray
# statistical inference for the tidyverse

# Traditionally, to do a test of the mean age of pennies, you
# would just pass the sample to the t.test function.
t.test(pennies_sample$age_in_2011)
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
# now we have a tibble of 1000 samples, each of size n

# calculate() is for condensing each sample down to a single stat
bootstrap_distribution <- pennies_sample %>%
    specify(formula=age_in_2011~NULL) %>%
    generate(reps=1000) %>%
    calculate(stat="mean")

# visualize() produces a historgram of the stat variable in
# bootstrap_distribution. It shows the bootstrap distribution for x bar

# but first, you can use specify and calculate to nicely compute x_bar
# of the original sample. This step could also be done with dplyr summarize()
x_bar <- pennies_sample %>%
	specify(age_in_2011~NULL) %>%
	calculate(stat="mean")

plot <- pennies_sample %>%
    specify(formula=age_in_2011~NULL) %>%
    generate(reps=1000) %>%
    calculate(stat="mean") %>%
    visualize(obs_stat=x_bar)

# get_ci() will get a confidence interval
ci <- pennies_sample %>%
    specify(formula=age_in_2011~NULL) %>%
    generate(reps=1000) %>%
    calculate(stat="mean") %>%
    get_ci(level=.95, type="percentile")

# visualize the ci
plot <- pennies_sample %>%
    specify(formula=age_in_2011~NULL) %>%
    generate(reps=1000) %>%
    calculate(stat="mean") %>%
    visualize(endpoints=ci, direction="between")

# The traditional multiplier (1.96) times standard error based method of
# finding a ci can also be used. Think of it as a shortcut to finding the real
# percentile based confidence interval. It works fine when the sampling
# distribution is close to normal. 
ci <- pennies_sample %>%
    specify(formula=age_in_2011~NULL) %>%
    generate(reps=1000) %>%
    calculate(stat="mean") %>%
    get_ci(level=.95, point_estimate=x_bar, type="se")

#############################################
# practice single proportion test 
# what is the proportion of red balls in the bowl dataset?
proportion_true <- bowl %>%
	summarize(p=sum(color=="red")/n())
proportion_true #.375

# use a sample to estimate proportion
sample <- bowl %>%
	sample_n(50) %>%
	select(color)

p_hat <- sample %>%
	specify(color~NULL, success="red") %>%
	calculate(stat="prop")
p_hat #approx .3
		  
bootstrap_props <- sample %>%
    specify(color~NULL, success="red") %>%
    generate(reps=1000) %>%
    calculate(stat="prop")

proportion_ci <- bootstrap_props %>% 
    get_ci(level=.95, type="percentile")
print(proportion_ci)

proportion_ci_plot <- bootstrap_props %>%
    visualize(bins=25, endpoints=proportion_ci, direction="between")
print(proportion_ci_plot)

