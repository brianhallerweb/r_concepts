# iteration

# for loops in R exist but functional alternatives with the apply()
# family or Purr is preferred

###############################
# for loops

# Create an atomic double vector that holds the means for each column in mtcars
mtcars_means <- vector("double", ncol(mtcars))
for (i in 1:length(mtcars)){
    mtcars_means[i] <- mean(mtcars[[i]])
}

# Create an atomic character vector that holds the types of each column in
# flights
library(nycflights13)
flights_type <- vector("character", ncol(flights))
for (i in 1:length(flights)){
	flights_type[i] <- typeof(flights[[i]])
}
print(flights_type)
#################################
# Purr

# The most commonly used part of Purr are the map functions. They provide a
# superior alternative to for loops. The apply family of functions in base R
# exist for the same purpose but they are less consistent than map family from
# Purr.  

# The map functions all take a vector (atomic or list) and applies a function to each element. What
# they return varies...
# map() returns a list (identical to lapply())
# map_lgl() returns a logical vector
# map_int() returns a integer vector
# map_dbl() returns a double vector
# map_chr() returns a character vector
# map_df() returns a data frame
# walk() returns nothing

# An example of splitting the the mtcars df by cylinders into a list of 3 dfs
# and then running a linear regression on each. A list of linear regressions is
# returned 
models <- mtcars %>% 
  split(.$cyl) %>% 
  map(function(df) lm(mpg ~ wt, data = df))
 
# anonymous function shorthand
# if the function you pass as an argument to map only contains 1 or 2 arguments
# you can omit the function() syntax and use . for 1 argument and .x and .y for
# 2 arguments

# using the anonymous function shorthand to create a list of R^2 valuesfor each
# model
models %>% 
  map(summary) %>% 
  map_dbl(~.$r.squared)
# or even more shorthanded. 
models %>% 
  map(summary) %>% 
  map_dbl("r.squared") 
  
# Purr also has improved functions for dealing with list hierarchies 
# These are often used with JSON data from web apis 
# I will come back to this later. There is good material in R for Data Science
# lists. 






