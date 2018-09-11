# Purr is for functional programming in R
# I believe most of it has to do with an alternative to loops
# Base R provides the apply family of functions for this purpose
# but the functions in Purr are preferrable because they are 
# more consistent. 

# Lists
# Lists are the R data structure for hierarchical data. 
# a named list is similar to a dictionary
my_list <- list(a = "a", b = 1L, c = 1.5, d = TRUE)
str(my_list)
#> List of 4
#>  $ a: chr "a"
#>  $ b: int 1
#>  $ c: num 1.5
#>  $ d: logi TRUE

# subsetting a list
# there are 3 ways to subset a list
# 1. Single brakets return another list (a subsetted list), not a component in a list. 
my_list["a"]
my_list[1]
# 2. Double backets extracts a component out of list
my_list[["a"]]
my_list[[1]]
# 3. The dollar sign is a shorthand for double brackets
my_list$a

