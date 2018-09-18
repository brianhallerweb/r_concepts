# The dplyr verbs
# 1. select(tbl, column names to select). 
# 2. filter(tbl, logical test). 
# 3. arrange(tbl, column name, column name as tie breaker). 
#    arrange changes the display order of rows
# 4. mutate(tbl, new column name = expression).
# 5. summarize(tbl, summary stat name = expression). 
# 6. Group_by(tbl, column to group by)
# All these verbs output a data frame 

#Select helper functions
# starts_with("X"): every name that starts with "X",
# ends_with("X"): every name that ends with "X",
# contains("X"): every name that contains "X",
# matches("X"): every name that matches "X", where "X" can be a regular expression,
# num_range("x", 1:5): the variables named x01, x02, x03, x04 and x05,
# one_of(x): every name that appears in x, which should be a character vector.
# The logical tests for the filter function include all the ones you are familiar with plus:
# x %in% c(a, b, c) , TRUE if x is in the vector c(a, b, c)
#   

# Summary statistics for summarize()
# min(x) - minimum value of vector x.
# max(x) - maximum value of vector x.
# mean(x) - mean value of vector x.
# median(x) - median value of vector x.
# quantile(x, p) - pth quantile of vector x.
# sd(x) - standard deviation of vector x.
# var(x) - variance of vector x.
# IQR(x) - Inter Quartile Range (IQR) of vector x.
# diff(range(x)) - total range of vector x.
# first(x) - The first element of vector x.
# last(x) - The last element of vector x.
# nth(x, n) - The nth element of vector x.
# n() - The number of rows in the data.frame or group of observations that summarise() describes.
# n_distinct(x) - The number of unique values in vector x.

# Renaming and reordering columns
# rename(oldname = newname)
# select(newfirstcol, newsecondcol, ..., everything()) 
# The everything() function means all the other columns. 

library(nycflights13)

delays <- flights %>% 
  group_by(dest) %>% 
  summarize(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")
