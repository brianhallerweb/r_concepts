# Factors with forcats
rm(list=ls())

library(tidyverse) #forcats comes with the tidyverse

# factors used to be much easier to work with than character 
# strings, so R was designed with many defaults to be stringsAsFactors

# creating a factor
# factor() comes from base R
month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
x1 <- factor(c("Jan", "Aug", "May"), levels = month_levels)
# ommiting the levels arg will cause the levels to come from the data itself. 
x2 <- factor(c("Mar", "Apr", "Dec", "Jan"))

# if you try to create a factor vector with invalid inputs (inputs that are not
# in the levels vector), they will be silently converted to NA 

#--------------------------------------------------------
# forcats helper functions
# The main purpose of the these helper functions is to either change the order
# of a factor or change the values

# gss_cat is a sample data set from the general social survey in the US
# it includes social data from 2000 to 2014

#-------- Changing the levels of a factor

# How to find the levels of a factor
levels(gss_cat$race)
# To do it in the tidyverse (with tibble inputs and outputs)
# use dplyr or ggplota to create a table or a plot
table <- gss_cat %>%
	count(race)
plot <- ggplot(gss_cat) +
	geom_bar(aes(race))

# How to change the order of levels (fct_reorder, fct_relevel, fct_infreq)
# fct_reorder is used to set the entire order of the levels of a factor
# fct_relevel is used to any number of levels to the front. 
# fct_infreq is used to order in increasing values 

# fct_reorder example
# create a plot that shows tvhours by religion, in order of
# watching time
df <- gss_cat %>%
      group_by(relig) %>%
      summarize(age = mean(age, na.rm=T), 
                tvhours = mean(tvhours, na.rm=T), 
		n = n()
		)
plot <- ggplot(df) +
        geom_col(aes(fct_reorder(relig, tvhours), tvhours)) + 
	theme(axis.text.x = element_text(angle = 90, hjust = 1))

# fct_relevel example
# avg age and income level
df <- gss_cat %>%
      group_by(rincome) %>%
      summarize(age = mean(age, na.rm=T), 
		n = n()
		)
plot <- ggplot(df) +
        geom_point(aes(age, fct_relevel(rincome, "Not applicable"))) + 
	theme(axis.text.x = element_text(angle = 90, hjust = 1))

# example of fct_infreq
# bar plot of marital status
# fct_rev() just reverses the order
df <- gss_cat %>%
	mutate(marital=marital %>% fct_infreq() %>% fct_rev())
plot <- ggplot(df) +
	geom_bar(aes(marital))
print(plot)


#-------------------- Changing the values of a factor

# How to change the values of levels 
# fct_recode()
# fct_collapse()
# fct_lump()

# fct_recode() is most flexible function
# It allows you to rename any value you choose. It leaves the ones you don't
# touch alone, and it allows combining groups by simply assigning the same new
# level to multiple old levels. 
df <- gss_cat %>%
	mutate(partyid=fct_recode(partyid, 
				  "Republican, strong" = "Strong republican",
				  "Republican, weak" = "Not str republican", 
				  "Independent, near rep" = "Ind,near rep",
				  "Indenpendent, near dem" = "Ind,near dem", 
				  "Democrat, weak" = "Not str democrat",
				  "Democrat, strong" = "Strong democrat")) %>%
count(partyid)

# fct_collapse is good for grouping multiple old levels into just a few new
# levels
# This collapses a bunch of different political party labels down to just
# democrat, replican, independent and other
df <- gss_cat %>%
	mutate(partyid = fct_collapse(partyid, other=c("No answer", "Don't know", "Other party"), rep=c("Strong republican", "Not str republican"),ind=c("Ind,near rep", "Independent", "Ind,near dem"),dem=c("Not str democrat", "Strong democrat"))) %>%
	count(partyid)

# fct_lump
# find the top 3 most populous religious groups
df <- gss_cat %>%
	mutate(relig=fct_lump(relig, n=2)) %>%
	count(relig)


