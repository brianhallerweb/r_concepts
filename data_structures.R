library(tidyverse)

# vectors are important because the functions you write will take vectors
# it is possible to write functions that take dataframes, like the tidyverse
# does, but I think that needs to be done with non standard evaluation in R,
# and apparently that is hard to work with. You can think of vectors as the
# building blocks of data frames

# 2 types of vectors - atomic vectors and lists
# atomic vectors must be homogenous (logical, integer, double, character, etc.)
# lists can be heterogenous (including other lists)
# NULL is the absence of a vector (NA is the absence of a value)
# All vectors have type and length
# factors, dates, and dataframes are built from vectors augmented with metadata

###################################################
# atomic vectors

# logical atomic vectors
# T, F, or NA

# numeric atomic vectors
# numeric means double or integer
# double is the default type for numbers
# integers can be NA
# doubles can be NA, NaN (0/0), inf (1/0), -inf(-1/0)

# character atomic vectors
# values are strings of any length
# in R, strings are copied by reference

# coercion 
# coercion can be explicity or implicit
# functions for explicit coercion are as.double() as.integer() as.logical() as.character()
# implicit coercion happens when a vector is used in certain contexts - like when a 
# logical atomic vector is summed. 

# two unique cases of coercion
# 1. when making vectors with c(), if you try to add hetergeous types, all values will be coerced
# to the most complex type. (logical, integer, double, character)
# 2. when doing math operations on two vectors of different lengths, the shorter vector
# coerced to be the same length as the longer vector. This is called vector recycling.
# the tidyverse throws errors for recycling. 

# testing for vector type
# base r has a bunch of functions like is.logical() but they are quirky. Use the functions
# like is_logical() from purr instead. They work as expected.

# subsetting vectors
# subsetting is done with the [] operator
# you can subset with numbers, names (if the vector is named), or with a logical vector
# How do you subset with a logical vector? 
x <- c(10, 3, NA, 5, 8, 1, NA)
x[!is.na(x)]
#> [1] 10  3  5  8  1

#######################################################
# lists
# atomic vectors and lists are somewhat analogous to python lists and dictionaries
# atomic vectors are used for simple collections of data and named lists are used 
# for hierarchical data. Of course, the analogy isn't perfect because r atomic vectors
# must be homogenous and they can be named. 

a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5), e = 6)

# subset a child numeric atomic vector
str(a["a"]) # returns a list
str(a[["a"]]) # returns an atomic vector
str(a$a) # also returns an atomic vector

# The difference between [] and [[]] is important
# [] doesn't drill down the hierarchy. It returns the same list just with a subset of the children
# [[]] returns a child alone (same as $)

# example of drilling down a hierarchy
parent_list <- list(child_list = list(1, 2))
str(parent_list[["child_list"]][[1]]) # this extracts the number 1 two levels down the hierarchy

#############################################################
# attributes
# All vectors can carry metadata through attributes
# think of attributes as a named list of vectors that a vector (or any object) carries around

x <- 1:10
attr(x, "greeting")
#> NULL
attr(x, "greeting") <- "Hi!"
attr(x, "farewell") <- "Bye!"
attributes(x)
#> $greeting
#> [1] "Hi!"
#> $farewell
#> [1] "Bye!"

# the names attribute is special 
# that is how elements of vectors are named
x <- c("one" = 1, "two" = 2)
attributes(x)
#> $names
#> [1] "one" "two"
# so the most explicit way of adding names to a vector is to go directly to the attributes
x <- c(1,2,3)
attributes(x) #NULL
attr(x, "names") <- c("one", "two", "three")

# the dimensions and class attributes are also special but an advanced topic
# dimensions are how a vector comes to behave like a matrix
# class is for the S3 object oriented system
# you add class attribute to a function in order to make a generic function
# generic functions behave differently for different classes of input

# Atomic vectors and lists are building blocks that can be augmented with attributes
# when augmented, atomic vectors and lists can become factors, dates, date-times, and tibbles

# factors
# factors are integer atomic vectors with a levels attribute (and a class attribute)
x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef"))
typeof(x)
#> [1] "integer"
attributes(x)
#> $levels
#> [1] "ab" "cd" "ef"
#> 
#> $class
#> [1] "factor"

# dates
# dates are just numeric atomic vectors with a class attribute of "date"
# the numeric atomic vector is just a single value - the number of days since 1/1/1970
x <- as.Date("1971-01-01")
unclass(x)
#> [1] 365
typeof(x)
#> [1] "double"
attributes(x)
#> $class
#> [1] "Date"

# date-times
# these are similar to dates except for the class is POSIXct and the numeric vector represents 
# seconds since 1/1/1970
# date-times also have a timezone attribute
# I believe all times are kept in an absolute form in UTC and the timezone attribute merely
# changes the date and time that is printed. 
# beware that there is another type of datetime called POSIXlt. They are rare and hard to work
# with so they should be converted to POSIXct

# package for dates and times
# lubridate is for dates and times in the tidyverse

# tibbles
# tibbles are augmented lists. They have 3 attributes: names, row.names, and class
# names are for columns
# row.names are for rows
# class is “tbl_df” + “tbl” + “data.frame”
# Regular data frames are the same as tibbles except they only have class "data.frame"
# Since tibbles have class data.frame too, they inherit all abilities of a regular
# data frame

# what is the difference between a tibble and list?
# They are actually very similar. A tibble is really just a list of lists. The only difference
# is that a list of lists places no constraint on the length of the inner lists, whereas
# a tibble requires that they all be the same length. 


	

