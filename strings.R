# Strings (stringr and stringi)

# it is best to always use stringr for string manipulation
# because it is designed to replace and improve base R
# string manipulation. Stringr is actually a simpler version
# of stringi. Stringr is usually sufficient but stringi
# can be useful for complex string manipulation tasks. 

library(stringr)
library(tidyverse)
library(htmlwidgets)
###############################
# Basics

# length
name <- "Obie"
str_length(name) #4

# concatenation
one <- "first"
two <- "second"
three <- "third"
str_c(one, two, three, sep=", ") # first, second, third
# or collapse an entire vector of strings into one
str_c(c("x", "y", "z"), collapse = ", ") # "x, y, z"

# subsetting
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3) #"App", "Ban", "Pea"
# what is the diff between str_sub and str_subset?

# changing case 
name <- "OBIE"
str_to_lower(name) #obie
str_to_upper(name) #OBIE
str_to_title(name) #Obie

###############################
# Regex
# There is no special syntax for R regex. Regex expressions are just
# strings and there are no unusual exceptions for using regex in R.

# str_view() is an interesting function that helps identify
# what your regex is matching. It requires the htmlwidgets package.
x <- c("apple", "banana", "pear")
str_view(x, "a")
str_view(x, regex("A", ignore_case=T))

# str_view_all() identifies all matches (not just the first)
str_view_all(x, "a")

# the str_ functions wrap regex functions
# str_view(x, "a") is actually str_view(x, regex("a"))
# this is important to know because it allows you to use regex arguments
# like ignore_case=TRUE and multiline=TRUE. Ignore_case does just what
# you would expect and multiline allows ^ and $ to match the start and
# end of each line rather than the start and end of the complete string.
str_view(x, regex("a", ignore_case=TRUE, multiline=TRUE))

###############################
# stringr and regex
# there are stringr functions for:
# 1. Determine which strings match a pattern.
# 2. Find the positions of matches.
# 3. Extract the content of matches.
# 4. Replace matches with new values.
# 5. Split a string based on a match.

### 1. 
# str_detect
x <- c("apple", "banana", "pear")
str_detect(x, "e")
#> [1]  TRUE FALSE  TRUE
# str_detect() is often useful as an argument to filter()

# str_count() is just like str_detect() but it returns the 
# number of matches
x <- c("apple", "banana", "pear")
str_count(x, "a")
#> [1]  1 3 1
# str_count() is often useful as an argument to mutate()

### 2.
# str_locate() will return the position of a match. 
# you can then extract the match with str_sub()

### 3.
# str_extract
# create a regex to match sentences with color
colors <- c("red", "orange", "yellow", "green", "blue", "purple")
color_match <- str_c(colors, collapse = "|")
# subset the sentences vector
has_color <- str_subset(sentences, color_match)
# extract the match out of each sentence
matches <- str_extract(has_color, color_match)
# str_extract will only return the first match
# use str_extract_all() to get all matches

### 4.
# str_replace
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
#> [1] "-pple"  "p-ar"   "b-nana"
str_replace_all(x, "[aeiou]", "-")
#> [1] "-ppl-"  "p--r"   "b-n-n-"
# a very nice application is to use vectors to accomplish multiple
# replacements
