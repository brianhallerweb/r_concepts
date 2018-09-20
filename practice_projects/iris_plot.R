rm(list=ls())
library(tidyverse)

# Plot of iris data
# This plot has the distribution of each measurement (petal/sepal length/width)
# shown as a boxplot, faceted by species. This design allows for a visual
# comparison of the petal and sepal properties for each species. For example,
# it shows very clearly that the setosa iris has the smallest flower.


# The first step is to get the data into the proper shape. The natural way to
# think about iris observations is as a whole flower but, for this plot, the
# observational unit is each measurement. That means that columns are values
# not variable names in the original dataset. Those value columns need to be gathered
# into a single "measure" variable column.   
iris_by_measurement <- iris %>%
	select(Species, everything()) %>%
	gather(2:5, key=measure, value=distance)

# The plot - 
plot <- ggplot(iris_by_measurement) +
	geom_boxplot(aes(x=measure, y=distance, fill=measure), show.legend=F) +
	facet_wrap(~Species, nrow=3) +
	labs(title="Iris flower measurements by species") 

print(plot)

