# Visualization with ggplot2

# The grammar of graphics is based on the insight that you can
# uniquely describe any plot as a combination of a dataset, a geom,
# a set of mappings, a stat, a position adjustment, a coordinate
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
ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_point() +
  facet_wrap(~ drv, nrow = 2)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

#Jitter overlapping points on scatterplots 
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

# Adding labels with ggrepel package
library(ggrepel)

ggplot(df, aes(x = cost, y = leads)) +
    geom_point() +
    geom_smooth(method='lm', formula=y~x) + 
    geom_label_repel(aes(label = name),
                  box.padding   = 0.35, 
                  point.padding = 0.5,
                  segment.color = 'grey50')

