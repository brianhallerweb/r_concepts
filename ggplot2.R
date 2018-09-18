# Visualization with ggplot2

# The grammar of graphics is based on the insight that you can
# uniquely describe any plot as a combination of a dataset, a geom (points,
# lines, bars, etc),
# a set of mappings (data variables are mapped to aesthetics such as xy position, color, shape, size, etc
# ), a stat, a position adjustment, a coordinate
# system, and a faceting scheme.

#The ggplot2 template
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>, 
#     position = <POSITION>
#   ) +
#   <COORDINATE_FUNCTION> +
#   <FACET_FUNCTION>

#Basic plotting with one geom layer
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy)) 
#The aesthetics are just on the geom_point layer.
#Putting the aesthestics argument after the data argument results
#in gloabal aesthetics. Both global and local aesthetics are often
#used. The local overrides the global for its specific layer only. 
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() 

#Adding variables beyond x and y
#2 ways: aesthetics and facets 

#Aesthetics
ggplot(data = mpg) + 
  geom_point(aes(x = displ, y = hwy, color = class))
#Adding a variable to the aesthetics function means
#that the variable will be given a unique level 
#and a legend will be created. 
#There are many variable aesthetics - size, shape, color, etc.  

#Facets
#Facets are an alternative to using aesthetics for incorporating a third
#categorical variable.
ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_point() +
  facet_wrap(~ drv, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

# Jitter overlapping points on scatterplots 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
# shorthand notation:
ggplot(data = mpg) + 
  geom_jitter(mapping = aes(x = displ, y = hwy))

#Adding geoms
#Each geom is a layer, so making complex graphs is all about layering
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

#Plots of stats 
#A bar chart plots the count of a categorical variable
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
#This works because the stat argument in geom_bar is set to 
#"count" by default. 
#This code is equivalent to the geom code. That is because geoms
#have a default stat and stats have a default geom. 
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))

#Adding color to a bar chart
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

#Adding a third variable to a bar chart
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))
#This isn't great because the bars are stacked. You need to add a 
#position.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")
#Filling the entire height makes relative comparisons better. 
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")
#Dodge is also good - it puts the bars side by side. 

###############################
# 5 major graph types
# 1. scatterplot
# 2. linegraph
# 3. boxplot
# 4. histogram
# 5. barplot

# 1. scatterplot
# Scatterplots show relationships between 2 continuous variables
# These plots are simple - just use geom_point(). Sometimes there is an
# overplotting problem and that can be fixed with position = jitter (jitter has
# width and height arguments too) or with
# using transparency (alpha = .5)

# Linegraphs
# Linegraphs are most commonly used with timeseries
# time is on the x and another continuous variable on the y
# geom_line()
# you often have to convert day to a date with as.POSIXct() because day as a
# character or factor causes problems

# Histograms
# Histograms are statistical distributions of random variables
# use geom_histogram() or stat_bin()
# to adjust the number of bins, use bins=30 (30 is default) or binwidth=10
# the border color is controlled with col="white" and the fill color is
# controlled with fill="blue"
# geom_density() is a smoothed histogram and good for data that comes from a
# smooth distribution

# boxplot
# geom_boxplot()
# a boxplot is similar to a histogram in that it provides a visualization of a
# statistical distributions of random variables
# A boxplot does this by showing a 5 number summary of a random variable
# a major benefit to boxplots is that they allow visualizaing a third
# categorical variable on the x axis. An example is temperature by month. You
# could compare the distributions of temperature by each month side by side in
# one boxplot. 

# Barplot
# barplots are essentially histograms for categorical variables
# there are 2 different geoms - geom_bar and geom_col
# the difference between the two geoms is that geom_bar takes a categorical
# variable and automatically calculates a count whereas geom_col takes x and y
# variables. When would you use geom_col? Use it will data frames that have
# precalculated counts (meaning that there is actually a count column in the
# data frame)

# when adding a second categorical variable to a barplot, you have to decide
# between stacked, dodged, or faceted bars. In general, faceting is preferred. 

###############################
# Facets
# Facets are good for visualizing a distribution of a variable over another
# categorical variable. 
# a good example is the distribution of temperature by month

# facet_wrap() will make a grid of small plots, each with identical y axis 
# nrow and ncol are attributes that control the total number of rows and/or
# columns

###############################
# Some appearance techniques

# Adding labels with ggrepel package
library(ggrepel)

ggplot(df, aes(x = cost, y = leads)) +
    geom_point() +
    geom_smooth(method='lm', formula=y~x) + 
    geom_label_repel(aes(label = name),
                  box.padding   = 0.35, 
                  point.padding = 0.5,
                  segment.color = 'grey50')

# Changing the general appearance
# There are many possible themes including theme_classic(), theme_minimal() 

# Add a title, change axis labels
# labs(x=xlabel, y=ylabel, title=plottitle)

