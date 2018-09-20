rm(list=ls())
library(tidyverse)
library(moderndive)

# moderndive has a dataset called bowl that has 2400 red and white balls
# the goal is to use traditional estimation methods to estimate the number
# of red balls in the bowl

proportion_true <- bowl %>%
	summarize(p=sum(color=="red")/n())
print("########### true proportion ##########")
print(proportion_true) #.375

# create a sample 
sample <- bowl %>%
	sample_n(50) %>%
	select(color)
print("########### sample ##########")
print(sample)

# calculate a point estimate, standard error, and ci endpoints
estimates <- sample %>%
	summarize(n=n(),
		  p_hat=sum(color=="red")/n,
		  se=sqrt(p_hat*(1-p_hat)/n),
		  conf=1.96,
		  lower_ci=p_hat-(conf*se),
		  upper_ci=p_hat+(conf*se)
		  )
print("########### estimates ##########")
print(estimates) 

##############################################
# Repeat this process to show the traditional visualization for the meaning of
# confidence

# create 100 samples
samples <- bowl %>%
	rep_sample_n(size=50, reps=100)
print("########### 100 samples ##########")
print(samples)

# for each sample, calculate a point estimate, standard error, and ci endpoints
estimates <- samples %>%
	group_by(replicate) %>%
	summarize(n=n(),
		  p_hat=sum(color=="red")/n,
		  se=sqrt(p_hat*(1-p_hat)/n),
		  conf=1.96,
		  lower_ci=p_hat-(conf*se),
		  upper_ci=p_hat+(conf*se),
		  captured=lower_ci<=proportion_true & upper_ci>=proportion_true
		  )
print("########### 100 estimates ##########")
print(estimates) 

# make the fancy visualization
plot <- ggplot(estimates, aes(p_hat, replicate), show.legend=F) +
	geom_point(aes(col=captured), size=2.4)+
	geom_vline(aes(xintercept=proportion_true$p, col="red")) +
	geom_segment(aes(x=lower_ci, xend=upper_ci, y=replicate, yend=replicate, col=captured), size=1.1) +
	labs(x="proportion of red balls", y="replication", title="95% confidence intervals for proportion")

print(plot)
